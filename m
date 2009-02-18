Return-path: <linux-media-owner@vger.kernel.org>
Received: from web35806.mail.mud.yahoo.com ([66.163.179.175]:42041 "HELO
	web35806.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754028AbZBRSFo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 13:05:44 -0500
Date: Wed, 18 Feb 2009 09:58:59 -0800 (PST)
From: Amy Overmyer <aovermy@yahoo.com>
Subject: vbox cat's eye 3560 usb device
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <538926.88491.qm@web35806.mail.mud.yahoo.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I’m trying to write a driver for the 
device, just as a learning exercise. So far, I’ve got the firmware in intel hex 
format (from usbsnoop on windows, then a couple perl scripts to mutate it) and 
am able to use fxload to load it with –t fx2 and there are 2 separate files, a 
short one (the loader) and the firmware proper; so in fxload I have a –s and a 
–I. 
 
I’m able to take it from cold to 
warm that way solely within Linux. 
 
The device itself has a cypress CY7C68013A fx2 chip and a large tin can tuner/demod stamped with 
Thomson that has a sticker on it identifying it as 8601A. Helpfully, the 3560 
opens up easily with the removal of two screws on the shell.
 
It’s cold boot usb id is 14f3:3560 and its warm boot is 
14f3:a560.
 
I have taken that hex file and 
created a binary file out of the 2nd file (-I in fxload speak). I 
think, correct me if I’m wrong, there is already a fx2 loader available, thus I 
will not need the loader file.
 
One of the stranger things I saw in 
the usbsnoop trace in windows was when it came to reset of the CPUCS, the driver 
sent down both a poke at x0e600 and a poke at 0x7f92. One is the fx CPUCS 
register, I believe the other is a fx2 CPUCS register. 
 
Currently I am mutating dibusb-mc 
just to see if I can get it to the point of going from cold to warm in the 
driver. 
 
I have taken usb sniffs from windows 
of doing things such as scanning for channels, watching a channel, etc. so I can 
try to figure out if anything else in the v4l-dvb collection behaves 
similarly.
 
I guess what I’m looking for is any 
hints that might be useful to figuring this out. 
 
Like I said, it’s a learning 
exercise, I already have enough tuners, and anyway, the cost of buying a 
supported tuner is far cheaper than the time needed to develop 
this!
 
Thanks for any info! I’ve pretty 
much devoured everything available on the wiki.
 
Amy


      
