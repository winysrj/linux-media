Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1KdDzP-000478-2A
	for linux-dvb@linuxtv.org; Wed, 10 Sep 2008 02:55:24 +0200
Message-ID: <48C71AF5.2080700@linuxtv.org>
Date: Tue, 09 Sep 2008 20:55:17 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: William Austin <bsdskin@yahoo.com>
References: <273704.19765.qm@web31108.mail.mud.yahoo.com>
In-Reply-To: <273704.19765.qm@web31108.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge HVR-1950 with Ubuntu Intrepid
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

William Austin wrote:
> I have a Hauppauge WinTV HVR-1950 USB box on a box running Ubuntu Intrepid.  Although I should expect problems from a testing distro, I've tried getting this box working on stable, Live-CD versions of Ubuntu, Open Suse, and Mandriva as well (because they were what I had around the house.)
> 
> First, there is a kernel problem in Ubuntu Intrepid where, if the 1950 is plugged into USB, the system will hang on boot.  Yet, if I boot without it and plug it in after boot, the drivers (pvrusb2 et al) seem to load, but no device nodes are created.  I have downloaded the firmware, renamed it properly, and placed it in /lib/firmware.  So I'm at a loss on how to troubleshoot.  Here's the relevant information on plug-in the box in after the system has been booted.

What firmware did you " download and rename " ??

Where did you get " v4l-pvrusb2-73xxx-01.fw " ??  or did you forget it?


> 
> dmesg says:
> usbcore: registered new interface driver pvrusb2
> pvrusb2: Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/Tuner : V4L in-tree version
> pvrusb2: Debug mask is 31 (0x1f)


Those lines will show up is you simply "modprobe pvrusb2" even if the device is not present.  What comes next?  It should download firmware, disconnect & reconnect USB automatically, then continue on with driver initialization.


> 
> lsmod (edit):
> usbcore
> pvrusb2
> i2c_core
> v4l2_common
> tveeprom
> dvb_core
> cx2341x
> videodev
> v4l1_compat


lsmod doesnt tell us anything.  You can load all those modules by hand, and it says nothing about the device that you have plugged in.

> /proc/devices lists DVB as a character device.
> 
> Now, I'm assuming I'm missing some chip drivers.  I think I should have at least three, if memory serves, but only cx2341x is loading on plug-in.  Unfortunately (and I assume this is another Ubuntu problem) I can't unload pvrusb2 once loaded.  It hangs the terminal.  It makes playing around with it a tedious endeavor.
> 
> If anyone has had the same problems or could give some advice, I appreciate it in advance.

I think you're best off taking a look at the pvrusb2 home page and reading the information there.  If you are still having trouble, then please just paste your full dmesg into an email so that we can have a better idea of what's wrong.

Good Luck,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
