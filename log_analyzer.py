import psycopg2

DBNAME = "news"


def main():
    # Open a file. This is where we will write the data that we will fetch from the database.
    output_file = open("analysis.txt", "w")
    final_output = ""

    # Create a connection with the database
    conn = psycopg2.connect(database=DBNAME)
    cursor = conn.cursor()

    # Fetch all the needed data from the database
    cursor.execute("select * from top_authors limit 3")
    top_authors = cursor.fetchall()

    cursor.execute("select * from top_articles limit 3")
    top_articles = cursor.fetchall()

    cursor.execute(
        "select * from view_perc_log where status like '%404%' and perc > 1")
    errors = cursor.fetchall()
    conn.close()  # Close connection after we have fetched all the needed data.

    # Format the data that we have fetched in the database
    output_authors = "The Most Popular Article Authors of All Time:\n"
    for author in top_authors:
        output_authors += "* {} - {} views\n".format(author[0], author[1])
    output_authors += "\n\n"

    output_articles = "The Most Popular Articles of All Time:\n"
    for article in top_articles:
        output_articles += "* \"{}\" - {} views\n".format(
            article[0], article[1])
    output_articles += "\n\n"

    output_errors = "Days where more than 1% of requests led to errors:\n"
    for error in errors:
        output_errors += "* {} - {}% errors\n".format(
            error[0].strftime('%B %d, %Y'), error[2])

    final_output = '''********************
*   Log Analyzer   *
********************

{}{}{}
***  END  ***'''.format(output_articles, output_authors, output_errors)

    # Write the formatted data in the file
    # Close the file after writing the data.
    output_file.write(final_output)
    output_file.close()


main()