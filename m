Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from zeus.freepage.ro ([86.35.4.2] helo=freepage.ro)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <aron@aron.ws>) id 1KDxO5-00035N-3a
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 10:08:25 +0200
Received: from localhost (zeus.freepage.ro [127.0.0.1])
	by freepage.ro (Postfix) with ESMTP id 870AF794142
	for <linux-dvb@linuxtv.org>; Wed,  2 Jul 2008 13:10:38 +0300 (EEST)
Received: from freepage.ro ([127.0.0.1])
	by localhost (zeus.freepage.ro [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d4e+uAzMUzS3 for <linux-dvb@linuxtv.org>;
	Wed,  2 Jul 2008 13:10:32 +0300 (EEST)
Received: from webmail.aron.ws (aron.ws [195.70.62.6])
	by freepage.ro (Postfix) with ESMTP id DFC6C794141
	for <linux-dvb@linuxtv.org>; Wed,  2 Jul 2008 13:10:31 +0300 (EEST)
MIME-Version: 1.0
Date: Wed, 02 Jul 2008 10:07:37 +0200
From: <aron@aron.ws>
To: linux-dvb@linuxtv.org
Message-ID: <ebb5820836d39cba9b5b05d4b058d06a@freepage.ro>
Subject: [linux-dvb] em28xx problems
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

Hi!

Sorry if I write to the wrong place.

I have a problem with this driver... I've never used v4l so i don't really
understand it.
I want to use a USB 2.0 AV Grabber called GrabBeeX+

It has an s-video, stereo and a composite video input.
The sound and video are attached trough a saa7113h and EMP202 AC97 chip.
The USB is attached to the em2800-2 chip.

I tried to load the module, after that I tried to compile it, but i still
get the same effect.

It does not create a video device file :(.

Dmesg:

Linux video capture interface: v2.00
em28xx v4l2 driver version 0.0.1 loaded
usbcore: registered new interface driver em28xx
ACPI: EC: non-query interrupt received, switching to interrupt mode
usb 5-5: new high speed USB device using ehci_hcd and address 4
usb 5-5: configuration #1 chosen from 1 choice
usbcore: registered new interface driver snd-usb-audio

If you can please help me !

Thanks!


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
