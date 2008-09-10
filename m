Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web31102.mail.mud.yahoo.com ([68.142.200.35])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <bsdskin@yahoo.com>) id 1KdEtN-0006y4-PY
	for linux-dvb@linuxtv.org; Wed, 10 Sep 2008 03:53:17 +0200
Date: Tue, 9 Sep 2008 18:52:38 -0700 (PDT)
From: William Austin <bsdskin@yahoo.com>
To: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
Message-ID: <868475.15080.qm@web31102.mail.mud.yahoo.com>
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
>> I have a Hauppauge WinTV HVR-1950 USB box on a box running Ubuntu Intrepid.  Although I should expect problems from a testing distro, I've tried getting this box working on stable, Live-CD versions of Ubuntu, Open Suse, and Mandriva as well (because they were what I had around the house.)
>>
>>First, there is a kernel problem in Ubuntu Intrepid where, if the 1950 is plugged into USB, the system will hang on boot.  Yet, if I boot without it and plug it in after boot, the drivers (pvrusb2 et al) seem to load, but no device nodes are created.  I have downloaded the firmware, renamed it properly, and placed it in /lib/firmware.  So I'm at a loss on how to troubleshoot.  Here's the relevant information on plug-in the box in after the system has been booted.

>What firmware did you " download and rename " ??

I tried both the version on Stephen Toth's site and the version that came with my windows driver CD (4.5a).  The firmware was extracted with Mike Isely's perl script and renamed according to information on his website.  There were three files total.

>Where did you get " v4l-pvrusb2-73xxx-01.fw " ??  or did you forget it?

See above. 

>> dmesg says:
>> usbcore: registered new interface driver pvrusb2
>> pvrusb2: Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/Tuner : V4L in-tree version
>> pvrusb2: Debug mask is 31 (0x1f)


>Those lines will show up is you simply "modprobe pvrusb2" even if the device is not present.  What comes next?  It should download firmware, >disconnect & reconnect USB automatically, then continue on with driver initialization.

That was the end of my dmesg as far as the dvb stuff is concerned.  There were a few more lines dealing with my wireless adapter, but I didn't think it relevant.  I did not modprobe pvrusb2.  Those lines were the result of just plugging the device in.


>> lsmod (edit):
>> usbcore
>> pvrusb2
>> i2c_core
>> v4l2_common
>> tveeprom
>> dvb_core
>> cx2341x
>> videodev
>> v4l1_compat


>lsmod doesnt tell us anything.  You can load all those modules by hand, and it says nothing about the device that you have plugged in.

But I didn't load them by hand.  Just trying to help people help me.

>> /proc/devices lists DVB as a character device.
>>
>> Now, I'm assuming I'm missing some chip drivers.  I think I should have at least three, if memory serves, but only cx2341x is loading on plug-in.  Unfortunately (and I assume this is another Ubuntu problem) I can't unload pvrusb2 once loaded.  It hangs the terminal.  It makes playing around with it a tedious endeavor.
>>
>> If anyone has had the same problems or could give some advice, I appreciate it in advance.

>I think you're best off taking a look at the pvrusb2 home page and reading the information there.  If you are still having trouble, then please just paste your full dmesg into an email so that we can have a better idea of what's wrong.
>Good Luck,
>Mike

If I hadn't already checked out the pvrusb2 home page and read the information there, I wouldn't be feeling patronised on a mailing list asking for help.  But then, I understand requests like this can get tedious, so no worries.

I just rebooted with the device unplugged.  Here is the end of my dmesg (the changes after I plugged in the HVR-1950):
[ 5115.393036] usb 2-2: new high speed USB device using ehci_hcd and address 12
[ 5115.529015] usb 2-2: configuration #1 chosen from 1 choice
[ 5115.616658] Linux video capture interface: v2.00
[ 5115.672945] usbcore: registered new interface driver pvrusb2
[ 5115.674849] pvrusb2: Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/Tuner : V4L in-tree version
[ 5115.674857] pvrusb2: Debug mask is 31 (0x1f)
[ 5116.673636] firmware: requesting v4l-pvrusb2-73xxx-01.fw
[ 5116.697396] pvrusb2: Device microcontroller firmware (re)loaded; it should now reset and reconnect.
[ 5116.861037] usb 2-2: USB disconnect, address 12
[ 5116.862449] pvrusb2: Device being rendered inoperable
[ 5118.488036] usb 2-2: new high speed USB device using ehci_hcd and address 13
[ 5118.625005] usb 2-2: configuration #1 chosen from 1 choice

Now, for the first time (and it'd have to be after I've already written to the list asking about it) it seems to load the firmware correctly; however, I'm still without a device node for it.

Will



      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
