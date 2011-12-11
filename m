Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:59461 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751743Ab1LKL7l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 06:59:41 -0500
Message-ID: <4EE49B2B.8090502@gmx.de>
Date: Sun, 11 Dec 2011 12:59:39 +0100
From: Johannes Bauer <dfnsonfsduifb@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: zc3xx webcam crashes on in-focus pictures
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi list,

the problem I'm having sounds really weird and strange, please bear with
me -- I do not know who else to ask or what to search for.

I have a Logitech Labtec webcam:

Bus 001 Device 012: ID 046d:08a2 Logitech, Inc. Labtec Webcam Pro

Which I use with the zc3xx driver on a 2.6.34 Linux:

usb 1-3.2: new full speed USB device using ehci_hcd and address 12
gspca: probing 046d:08a2
zc3xx: probe sensor -> 000e
zc3xx: Find Sensor PAS202B
input: zc3xx as /devices/pci0000:00/0000:00:1a.7/usb1/1-3/1-3.2/input/input7
gspca: video0 created
gspca: found int in endpoint: 0x82, buffer_len=8, interval=10
gspca: probing 046d:08a2
gspca: probing 046d:08a2

I'm using mplayer for playback. This works nicely for the most part.
However, as soon as I get things in focus (or make images of things that
have sharp edges), the driver chokes -- mplayer just displays

v4l2: select timeout

And no more frames appear. As soon as I put the pictures back out of
focus, frames are updated again.

I've noticed this problem about a year back when I tried automatic
recognition of QR codes with that camera. Since QR codes basically
consist ONLY of sharp edges (black/white), the camera totally choked
upon shown one. Back then I ditched the whole project and found another
solution.

Now I just tried to hook the camera up to my microscope for fun. As a
test image, I made an image of a ruler. It worked pretty nicely, but you
guessed it: As soon as I put the image in focus, the camera chokes.

Has anyone ever heared of a similar problem with that driver? Or may
that even be a hardware fault? Lastly, can anyone recommend a
high-quality webcam that runs smoothly on Linux?

Best regards,
Joe
