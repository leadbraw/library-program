import pyodbc
from constants import *
import tkinter as tk
from tkinter import messagebox

def create_connection():
    """
    Creates a connection to the database.

    :return: A connection to the database.
    """
    try:
        """Troubleshooting? Make sure you have the odbc driver installed (try running print(pyodbc.drivers)).
        Also make sure that you have enabled Named Pipes and TCP/IP connections on your server. Also make sure 
        the server name was properly copied. Also make sure the server is using Windows Authentication. If it isn't,
        then replace the Trusted_Connection argument with username and password ones (your mileage may vary, I
        recommend just using Windows Authentication, and making the current user an admin of the server during
        creation). Consult docs as needed."""
        connection = pyodbc.connect(r'''
                                    DRIVER={ODBC Driver 17 for SQL Server};
                                    SERVER=DESKTOP-595A4VQ\LIBRARYSERVER;
                                    DATABASE=LibraryProject;
                                    Trusted_Connection=yes;
                                    ''')
        return connection
    except Exception as e:
        messagebox.showerror("Connection Error", f"Failed to connect to database: {e}")
        return None

# Function to fetch data from the database
def fetch_data(query):
    """
    Runs a query on the server. Is used by display_data.

    :param query: Query to run on database
    :return: A list of rows returned, or an empty list if no connection could be made.
    """
    connection = create_connection()
    if connection:
        cursor = connection.cursor()
        cursor.execute(query)
        rows, col_names = cursor.fetchall(), [col[0] for col in cursor.description]
        connection.close()
        return rows, col_names
    return []

# Function to display data in the GUI
def display_data():
    """
    Determines which query to run on the database, calls fetch_data, and displays the data.
    """
    query = query2 = None
    match choice.get():
        case 's1':
            query = SCENARIO1
        case 's2':
            query = SCENARIO2
        case 's3':
            query = SCENARIO3
        case 's4':
            query = SCENARIO4
        case 's5':
            query = SCENARIO5
        case 's6':
            query = SCENARIO6
            query2 = SCENARIO6B
        case 's7':
            query = SCENARIO7
        case 'a1':
            query = ANALYTICAL1
        case 'a2':
            query = ANALYTICAL2
        case 'a3':
            query = ANALYTICAL3
        case 'a4':
            query = ANALYTICAL4
        case 'a5':
            query = ANALYTICAL5

    rows, col_names = fetch_data(query)
    listbox.insert(tk.END, col_names)
    for row in rows:
        listbox.insert(tk.END, row)
    listbox.insert(tk.END, '---------------------------------------')
    if query2: # Necessary to show the second query of scenario 6. A bit redundant but whatever.
        rows, col_names = fetch_data(query2)
        listbox.insert(tk.END, col_names)
        for row in rows:
            listbox.insert(tk.END, row)
        listbox.insert(tk.END, '---------------------------------------')

def display_help():
    messagebox.showinfo("Query/Scenario Reference", HELP_MSG)

# Window setup
root = tk.Tk()
root.geometry('600x500')
root.title("Dangerfield Giroux Library DB App")

# Create a listbox to display query results
listbox = tk.Listbox(root, width=50, height=15)
listbox.pack(padx=10, pady=10, fill=tk.BOTH, expand=True)

choice = tk.StringVar(value='s1')

# Frame to contain buttons so I can put 'em in a grid.
button_frame = tk.Frame(master=root)
button_frame.pack(side=tk.BOTTOM, fill=tk.BOTH, expand=True)

# Making all the buttons, I didn't bother to  make this pretty.
s1_button = tk.Radiobutton(button_frame, text="scenario1", value='s1', variable=choice)
s1_button.grid(row=0, column=0)
s2_button = tk.Radiobutton(button_frame, text="scenario2", value='s2', variable=choice)
s2_button.grid(row=0, column=1)
s3_button = tk.Radiobutton(button_frame, text="scenario3", value='s3', variable=choice)
s3_button.grid(row=0, column=2)
s4_button = tk.Radiobutton(button_frame, text="scenario4", value='s4', variable=choice)
s4_button.grid(row=0, column=3)
s5_button = tk.Radiobutton(button_frame, text="scenario5", value='s5', variable=choice)
s5_button.grid(row=0, column=4)
s6_button = tk.Radiobutton(button_frame, text="scenario6", value='s6', variable=choice)
s6_button.grid(row=0, column=5)
s7_button = tk.Radiobutton(button_frame, text="scenario7", value='s7', variable=choice)
s7_button.grid(row=0, column=6)
a1_button = tk.Radiobutton(button_frame, text="analytical1", value='a1', variable=choice)
a1_button.grid(row=1, column=0)
a2_button = tk.Radiobutton(button_frame, text="analytical2", value='a2', variable=choice)
a2_button.grid(row=1, column=1)
a3_button = tk.Radiobutton(button_frame, text="analytical3", value='a3', variable=choice)
a3_button.grid(row=1, column=2)
a4_button = tk.Radiobutton(button_frame, text="analytical4", value='a4', variable=choice)
a4_button.grid(row=1, column=3)
a5_button = tk.Radiobutton(button_frame, text="analytical5", value='a5', variable=choice)
a5_button.grid(row=1, column=4)
confirm_button = tk.Button(root, text="Fetch Data", command=display_data)
confirm_button.pack(padx=5, pady=5, side=tk.LEFT)
help_button = tk.Button(root, text="Query Reference", command=display_help)
help_button.pack(padx=5, pady=5, side=tk.RIGHT)

# Main loop! Wahoo!!
root.mainloop()