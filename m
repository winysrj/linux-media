Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55536 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab0IIOLV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 10:11:21 -0400
Received: by fxm16 with SMTP id 16so881193fxm.19
        for <linux-media@vger.kernel.org>; Thu, 09 Sep 2010 07:11:20 -0700 (PDT)
MIME-Version: 1.0
From: Gregory Orange <gregory.orange@gmail.com>
Date: Thu, 9 Sep 2010 22:11:00 +0800
Message-ID: <AANLkTi=1cucc=LrMEp44xpWs=_f75C7iAgXfkC+r5dPP@mail.gmail.com>
Subject: Leadtek DTV2000DS remote
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi all, first post.

I have a newly purchased Leadtek DTV2000DS dual tuner card in my
machine, configured and running in Mythbuntu 10.04 (after installing
latest v4l-dvb from source). I am having a bit of trouble getting the
supplied remote control working. Is anyone here able to assist? I
asked on the LIRC sf.net list and after a bit of back and forth I was
directed to see if you guys can help me. In particular I wonder if the
author of dvb_usb_af9015 and af9013 is around - hmm, seems to be Antti
Palosaari, who seems to be a fairly recent poster. Don't get me wrong
though - anyone who can assist would be great (:

I have confirmed that the hardware works - I installed the drivers in
a Windows boot, and the remote works.

In terms of driver support I'm not sure exactly what I'm looking for,
but there is this line in dmesg:
[   22.263721] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:0e.0/0000:02:0a.2/usb2/2-1/input/input5

cat /proc/bus/input/devices yields
I: Bus=0003 Vendor=0413 Product=6a04 Version=0200
N: Name="IR-receiver inside an USB DVB receiver"
P: Phys=usb-0000:02:0a.2-1/ir0
S: Sysfs=/devices/pci0000:00/0000:00:0e.0/0000:02:0a.2/usb2/2-1/input/input5
U: Uniq=
H: Handlers=kbd event5
B: EV=3
B: KEY=108fc310 2802891 0 0 0 0 118000 200180 4803 e1680 0 100000 ffe

So I've been using /dev/input/event5 in my tests. I have tried using
evtest, mode2, and irw to no avail. I get no indication of any signal
coming from the remote. Am I missing a kernel driver module? Any
further advice or specific experience with this device would be
gratefully welcomed.

Cheers,
Greg.

-- 
Gregory Orange
