Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45611 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752945AbZJ1RNx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2009 13:13:53 -0400
Message-ID: <4AE87BD5.8010506@gmx.net>
Date: Wed, 28 Oct 2009 18:13:57 +0100
From: Michael Gius <m.gius@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: bt878 card: no sound and only xvideo support in 2.6.31 after perfect
 support in 2.6.24
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

My Hercules SmartTv Stereo PCI had perfect
support under 2.6.24 in Ubuntu 8.04  with below modprobe settings.

Now I switched to Ubuntu 9.10 and have:
- no sound except some faint garbled noises when I turn up the volume to 
max.
- only have a picture via xvideo/overlay (using the xvideo plugin in kdetv
  before it worked using the v4l2 plugin in kdetv)
Country is Belgium, TV Norm is PAL.

Using the latest version compiled from the mercurial repository
gives the same results.
In Ubuntu 9.04 with kernel 2.6.28 I had the same symptoms but could use the
tv card by simply reverting to kernel 2.6.24 without any other
changes.

Below are the modprobe settings that worked in 2.6.24,
the lspci -v output and the relevant dmesg lines.

Any pointers are more than welcome.

Thanks and best regards,
Michael

#/etc/modprobe.d/bttv.conf
alias char-major-89 i2c-dev
options bttv card=0x64 tuner=38  automute=1 i2c_udelay=128
options tvaudio tda9874a=1



lspci -v:
03:06.0 Multimedia video controller: Brooktree Corporation Bt878 Video 
Capture (rev 11)
    Subsystem: PROVIDEO MULTIMEDIA Co Ltd Device 952b
    Flags: bus master, medium devsel, latency 32, IRQ 16
    Memory at fdeff000 (32-bit, prefetchable) [size=4K]
    Capabilities: [44] Vital Product Data <?>
    Capabilities: [4c] Power Management version 2
    Kernel driver in use: bttv
    Kernel modules: bttv

03:06.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture 
(rev 11)
    Subsystem: PROVIDEO MULTIMEDIA Co Ltd Device 952b
    Flags: bus master, medium devsel, latency 32, IRQ 11
    Memory at fdefe000 (32-bit, prefetchable) [size=4K]
    Capabilities: [44] Vital Product Data <?>
    Capabilities: [4c] Power Management version 2


dmesg:

[   10.180614] Linux video capture interface: v2.00
[   10.206630] bttv: driver version 0.9.18 loaded
[   10.206632] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   10.206852] bttv: Bt8xx card found (0).
[   10.207136] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
[   10.207140] bttv 0000:03:06.0: PCI INT A -> Link[APC1] -> GSI 16 
(level, low) -> IRQ 16
[   10.207149] bttv0: Bt878 (rev 17) at 0000:03:06.0, irq: 16, latency: 
32, mmio: 0xfdeff000
[   10.207178] bttv0: subsystem: 1540:952b (UNKNOWN)
[   10.207180] please mail id, board name and the correct card= insmod 
option to linux-media@vger.kernel.org
[   10.207182] bttv0: using: Hercules Smart TV Stereo [card=100,insmod 
option]
[   10.207184] IRQ 16/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
[   10.207210] bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
[   10.234435] bttv0: tuner type=38
[   10.744660] tvaudio 1-0058: found tda9874a.
[   10.744662] tvaudio 1-0058: tda9874h/a found @ 0xb0 (bt878 #0 [sw])
[   11.460205] All bytes are equal. It is not a TEA5767
[   11.460258] tuner 1-0060: chip found @ 0xc0 (bt878 #0 [sw])
[   11.810349] tuner-simple 1-0060: creating new instance
[   11.810352] tuner-simple 1-0060: type set to 38 (Philips PAL/SECAM 
multi (FM1216ME MK3))
[   11.822666] bttv0: registered device video0
[   11.822685] bttv0: registered device vbi0
[   11.822705] bttv0: PLL: 28636363 => 35468950 .. ok

