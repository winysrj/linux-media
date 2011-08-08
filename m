Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55670 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752040Ab1HHOi2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 10:38:28 -0400
Date: Mon, 8 Aug 2011 10:38:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Adam Baker <linux@baker-net.org.uk>
cc: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	<linux-usb@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
In-Reply-To: <201108080130.57394.linux@baker-net.org.uk>
Message-ID: <Pine.LNX.4.44L0.1108081034590.1944-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Aug 2011, Adam Baker wrote:

> Further testing reveals the situation is more complex than I first thought - 
> the behaviour I get depends upon whether what gets plugged in is a full speed 
> or a high speed device. After I've run the test of running gphoto whilst 
> streaming from a supported dual mode camera, lsusb fails to recognise a high 
> speed device plugged into the port the camera was plugged into (it works fine 
> if plugged in elsewhere) and lsusb hangs if I plug in a new low speed or full 
> speed device. When I get some time I'll see if I can recreate the problem 
> using libusb with a totally different device. Looking around my pile of USB 
> bits for something full speed with a kernel driver I've got a PL2303 serial 
> port. Would that be a good choice to test with?

I have no idea.  But the symptoms you describe are indicative of a 
hardware problem, not a driver bug.

> Just for reference with a full speed device I see the messages below in dmesg
> with the second one only appearing when I do lsusb
> [10832.128039] usb 3-2: new full speed USB device using uhci_hcd and address 
> 34
> [10847.240031] usb 3-2: device descriptor read/64, error -110
> 
> and with a high speed device I see a continuous stream of
> [11079.820097] usb 1-4: new high speed USB device using ehci_hcd and address 
> 103
> [11079.888355] hub 1-0:1.0: unable to enumerate USB device on port 4
> [11080.072377] hub 1-0:1.0: unable to enumerate USB device on port 4
> [11080.312053] usb 1-4: new high speed USB device using ehci_hcd and address 
> 105
> [11080.380418] hub 1-0:1.0: unable to enumerate USB device on port 4
> [11080.620030] usb 1-4: new high speed USB device using ehci_hcd and address 
> 106
> [11080.688322] hub 1-0:1.0: unable to enumerate USB device on port 4

The dmesg log is relatively uninformative unless you enable 
CONFIG_USB_DEBUG in the kernel build.

Have you tried running these tests on a different computer, preferably 
one using a different chipset?

Alan Stern

