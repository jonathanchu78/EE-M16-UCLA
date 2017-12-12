// Example program
#include <iostream>
#include <string>
using namespace std;

int main()
{
	string s;
	cin >> s;
	int len = s.size();
	string out1 = "";
	string out2 = "";
	string out3 = "";
	string out4 = "";
	for (int k = 0; k < len; k += 4) {
		out1 += s[k];
	}
	for (int k = 1; k < len; k += 4) {
		out2 += s[k];
	}
	for (int k = 2; k < len; k += 4) {
		out3 += s[k];
	}
	for (int k = 3; k < len; k += 4) {
		out4 += s[k];
	}
	while (out1.size() < 8)
		out1 += "0";
	while (out2.size() < 8)
		out2 += "0";
	while (out3.size() < 8)
		out3 += "0";
	while (out4.size() < 8)
		out4 += "0";
	cout << out1 << endl << out2 << endl << out3 << endl << out4 << endl;
}
