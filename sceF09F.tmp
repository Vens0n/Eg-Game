using Godot;
using System;
using System.Runtime.InteropServices;

public class TransparentWindow : Node
{
	private const int GWL_EXSTYLE = -20;
	private const int WS_EX_LAYERED = 0x80000;
	private const int WS_EX_TRANSPARENT = 0x20;

	[DllImport("user32.dll", SetLastError = true)]
	private static extern int GetWindowLong(IntPtr hWnd, int nIndex);

	[DllImport("user32.dll", SetLastError = true)]
	private static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);

	[DllImport("user32.dll", SetLastError = true)]
	private static extern IntPtr GetActiveWindow();

	public override void _Ready()
	{
		// Ensure this runs only on Windows
		if (OS.GetName() == "Windows")
		{
			var hwnd = GetActiveWindow();
			int style = GetWindowLong(hwnd, GWL_EXSTYLE);
			SetWindowLong(hwnd, GWL_EXSTYLE, style | WS_EX_LAYERED | WS_EX_TRANSPARENT);
		}
	}
}
