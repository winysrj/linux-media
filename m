Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50070 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1JBWrt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Oct 2011 18:47:49 -0400
Received: by pzk1 with SMTP id 1so10140317pzk.1
        for <linux-media@vger.kernel.org>; Sun, 02 Oct 2011 15:47:48 -0700 (PDT)
Message-ID: <4E88EA0F.2090700@gmail.com>
Date: Sun, 02 Oct 2011 19:47:43 -0300
From: =?ISO-8859-1?Q?S=E9bastien_le_Preste_de_Vauban?=
	<ulpianosonsi@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Bttv and composite audio
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a ATV-TUNER-F  tv card.
This is the manufacturer web site: 
http://advanteknetworks.com/products/tvtuners/atvtunerf.html

Here is some info of the card:

lspci -v
02:0a.0 Multimedia video controller: Brooktree Corporation Bt878 Video 
Capture (rev 11)
         Flags: bus master, medium devsel, latency 64, IRQ 21
         Memory at faffe000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2
         Kernel driver in use: bttv
         Kernel modules: bttv

02:0a.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture 
(rev 11)
         Flags: bus master, medium devsel, latency 64, IRQ 3
         Memory at fafff000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2

cat /etc/modprobe.d/bttv
options bttv card=38 tuner=43 radio=1 pll=1

uname -r
3.0-ARCH

dmesg | grep bttv
[27086.701904] bttv: driver version 0.9.18 loaded
[27086.701909] bttv: using 8 buffers with 2080k (520 pages) each for capture
[27086.702544] bttv: Bt8xx card found (0).
[27086.702566] bttv0: Bt878 (rev 17) at 0000:02:0a.0, irq: 21, latency: 
64, mmio: 0xfaffe000
[27086.702614] bttv0: using: Askey CPH06X TView99 [card=38,insmod option]
[27086.702658] bttv0: gpio: en=00000000, out=00000000 in=00f9807f [init]
[27086.703500] bttv0: tuner type=43
[27086.729122] bttv0: audio absent, no audio device found!
[27086.748110] bttv0: registered device video0
[27086.748286] bttv0: registered device vbi0
[27086.748393] bttv0: registered device radio0
[27086.748416] bttv0: PLL: 28636363 => 35468950 .
[27086.754854] bttv0: PLL: 28636363 => 35468950 .. ok
[27086.782948] input: bttv IR (card=38) as 
/devices/pci0000:00/0000:00:1e.0/0000:02:0a.0/rc/rc3/input8
[27086.783099] rc3: bttv IR (card=38) as 
/devices/pci0000:00/0000:00:1e.0/0000:02:0a.0/rc/rc3


Tv-tuner video and audio works fine, composite video works fine but I 
have no composite audio.
The adapter shipped with the card is very similar to this one:
http://www.avermedia-usa.com/AVerTV/Upload/SpecialPagePic/S-Video%20Composite%20Dongle%20Cable.jpg
but the usb connector on the picture is some sort of S-video like 
connector in my tv card.


