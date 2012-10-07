Return-path: <linux-media-owner@vger.kernel.org>
Received: from [92.246.25.51] ([92.246.25.51]:60061 "EHLO mail.multitrading.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab2JGQCp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Oct 2012 12:02:45 -0400
Date: Sun, 7 Oct 2012 17:56:02 +0200
From: Jens Bauer <jens-lists@gpio.dk>
To: linux-media@vger.kernel.org
Message-ID: <20121007175602425458.288c6720@gpio.dk>
Subject: Zolid USB DVB-T Tuner Pictures
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi...

I saw on this page...
<http://linuxtv.org/wiki/index.php/DVB-T_USB_Devices>
...That I can contribute to the project by writing to this list.

Now, I don't have much knowledge about USB; I don't even have Linux (but I probably will within a few months).
I saw that some of the mentioned devices on the above page, are missing a picture.
So what I can do, is that I have a Zolid USB DVB-T Tuner "bought from Aldi - like they all are".
I've taken some pictures, cut them in Photoshop, scaled, saved as png and finally optimized them using pngout.
Sizes are: Approx. 2100x500 for the originals, 1024x500..600 for the large ones, 512x190..300 for medium-size, 128x51..80 for the smaller ones.
(Whoa, 5 hours work for 5 pictures!)

Note: This is only one device, it seems a little difficult to figure out which version it is, but as I have the original box and a USB-Probe dump, it might be possible to identify it fully.

What I can say, is that it uses the IT9135 chip.
VID/PID 0x048D/00x9135.
Descriptor Version Number is 0x0200.
Device MaxPacketSize is 64 (see below)
Device Version Number is 0x0200
It has two configurations, each configuration has 4 interfaces.
The first configuration's interfaces have a max packet size of 512
The second configuration's interfaces have a max packet size of 64.
Apart from that, the configurations match eachother.

-So my guess is that this is a v2 device.

When looking at the above mentioned page, and I search the table for 'Zolid', I find an entry saying "ITE Inc. Zolid Mini DVB-T Stick Version 2".
My box says "Mini USB DVB-T Tuner" and the markings on the device just says "SMART GROUP" "Made in Taiwan", "www.unisupport.net", "PS0712" and "05/2011".
(In fact, I bought exactly this device, because I believe this is the one that's listed here!)

...Now...Who wants those pictures ? :)


Love
Jens
