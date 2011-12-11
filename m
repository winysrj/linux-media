Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:34600 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab1LKPEf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 10:04:35 -0500
Date: Sun, 11 Dec 2011 16:04:52 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Johannes Bauer <dfnsonfsduifb@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: zc3xx webcam crashes on in-focus pictures
Message-ID: <20111211160452.101da395@tele>
In-Reply-To: <4EE49B2B.8090502@gmx.de>
References: <4EE49B2B.8090502@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 11 Dec 2011 12:59:39 +0100
Johannes Bauer <dfnsonfsduifb@gmx.de> wrote:
	[snip]
> I have a Logitech Labtec webcam:
> 
> Bus 001 Device 012: ID 046d:08a2 Logitech, Inc. Labtec Webcam Pro
> 
> Which I use with the zc3xx driver on a 2.6.34 Linux:
> 
> usb 1-3.2: new full speed USB device using ehci_hcd and address 12
> gspca: probing 046d:08a2
> zc3xx: probe sensor -> 000e
> zc3xx: Find Sensor PAS202B
> input: zc3xx as /devices/pci0000:00/0000:00:1a.7/usb1/1-3/1-3.2/input/input7
> gspca: video0 created
> gspca: found int in endpoint: 0x82, buffer_len=8, interval=10
> gspca: probing 046d:08a2
> gspca: probing 046d:08a2
> 
> I'm using mplayer for playback. This works nicely for the most part.
> However, as soon as I get things in focus (or make images of things that
> have sharp edges), the driver chokes -- mplayer just displays
> 
> v4l2: select timeout
> 
> And no more frames appear. As soon as I put the pictures back out of
> focus, frames are updated again.
	[snip]

Hi Joe,

Your problem seems to be tied to the JPEG compression. It should have
been fixed in June, for the kernel 3.1.x (commit 93604b0fdde32). If you
cannot update your kernel, you may try the gspca test version from my
web page (see below).

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
