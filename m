Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Tue, 9 Sep 2008 21:11:07 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: William Austin <bsdskin@yahoo.com>
In-Reply-To: <868475.15080.qm@web31102.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0809092058410.3290@cnc.isely.net>
References: <868475.15080.qm@web31102.mail.mud.yahoo.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [linux-dvb] Hauppauge HVR-1950 with Ubuntu Intrepid
Reply-To: Mike Isely <isely@pobox.com>
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Tue, 9 Sep 2008, William Austin wrote:

> 
> If I hadn't already checked out the pvrusb2 home page and read the information there, I wouldn't be feeling patronised on a mailing list asking for help.  But then, I understand requests like this can get tedious, so no worries.
> 
> I just rebooted with the device unplugged.  Here is the end of my dmesg (the changes after I plugged in the HVR-1950):
> [ 5115.393036] usb 2-2: new high speed USB device using ehci_hcd and address 12
> [ 5115.529015] usb 2-2: configuration #1 chosen from 1 choice
> [ 5115.616658] Linux video capture interface: v2.00
> [ 5115.672945] usbcore: registered new interface driver pvrusb2
> [ 5115.674849] pvrusb2: Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/Tuner : V4L in-tree version
> [ 5115.674857] pvrusb2: Debug mask is 31 (0x1f)
> [ 5116.673636] firmware: requesting v4l-pvrusb2-73xxx-01.fw
> [ 5116.697396] pvrusb2: Device microcontroller firmware (re)loaded; it should now reset and reconnect.
> [ 5116.861037] usb 2-2: USB disconnect, address 12
> [ 5116.862449] pvrusb2: Device being rendered inoperable
> [ 5118.488036] usb 2-2: new high speed USB device using ehci_hcd and address 13
> [ 5118.625005] usb 2-2: configuration #1 chosen from 1 choice
> 

These same symptoms came across the pvrusb2 mailing list recently.  A 
couple things (unfortunately not very helpful)...

First, missing firmware should NEVER cause the driver to get stuck.  
Even if the FX2 firmware is missing it should still be possible to 
remove the kernel module.  You're saying that isn't working, which is a 
serious problem.  But right now I have nothing to go on.  This could be 
a real bug.  But it'd be nice to reproduce the problem using a vanilla 
kernel from kernel.org.

Second, from the messages above, the point where things are getting 
stuck is very, very early in initialization.  The HVR-1950 (and similar 
devices) actually have to appear "twice" before each will work.  The 
first time the driver is supposed to load the FX2 microcontroller's 
firmware and reset the device.  As part of that reset process, the 
hardware will logically disconnect from the USB cable and then 
reconnect.  It's just like unplugging then re-plugging the device back 
into the USB port.  Except on this reconnect, the driver (pvrusb2 in 
this case) must "figure out" that the FX2 firmware has already been 
loaded - and take a different course of action.  In the case of the 
pvrusb2 driver, a test is performed to figure out if the firmware is 
present and if the test passes then the driver continues normal 
initialization and eventually you get stuff appearing in /dev.

But what you have showing above is running aground on that reconnect.  
The hardware connects up, the driver sends the FX2 firmware, a reset 
takes place, the device reappears, BUT the USB core never reassociates 
the hardware with the pvrusb2 driver.  The pvrusb2 driver hasn't even 
started to run that second time yet so there's nothing in the driver 
itself (e.g. the "test") that could have gone wrong.  Thus the 
initialization process gets stuck.

Bad FX2 firmware *could* do that (e.g. FX2 processor resets and crashes 
after being loaded), however the extraction process simply won't let you 
extract incorrect firmware and I think you said you tried downloaded FX2 
firmware as well.  In fact, in all the work I've done on the pvrusb2 
driver, I've *never* actually had a case of bad FX2 firmware.  Ever.  
That makes me wonder if instead something with that kernel is causing 
the FX2 firmware to be corrupted during the download process.  But if 
that were the case pretty much anything in your system requiring a 
firmware download would probably be messed up (it's all common code 
elsewhere in the kernel).  So far the only reports I've heard of this 
have involved Ubuntu's build of the 2.6.27 kernel - which itself is not 
considered release-stable yet.  Makes me wonder...

Well I said it wouldn't be very helpful.  But that's where my line of 
thinking is right now.

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
