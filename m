Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:49415 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752342AbcIQP34 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Sep 2016 11:29:56 -0400
Date: Sat, 17 Sep 2016 17:29:51 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: linux-media@vger.kernel.org, 7eggert@gmx.de
Subject: BTTV problem: Terratec TV+ BT848 card: No composite input
Message-ID: <alpine.DEB.2.11.1609132237440.1532@be6.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hardware (short description): Terratec TV+ BT848 card "1.0", reactivated 
after several years. Video source is a camera (or a random DVB-T receiver 
displaying "no signal" text, just for testing).

Software used for testing: qv4l2, Debian Jessie. I assume neither they nor 
you changed something recently so I didn't try a git kernel.


Problem: No picture recognized on composite input.

The composite input did work previously (IIRC V4L 1). The video sources do 
work, I get a black & white picture when connecting the same source to the 
SVHS input (using an adapter).

On "Composite1", I get no picture at all, but a blue background. Sometimes 
I get a framecounter (25 FPS), but if I do, it keeps counting after I 
unplug the video source.

Using different card= values (1 .. 30), I get similar results.

I traced the input to the correct pin, according to the data sheet.

Off cause the card might just be broken, but maybe there is something else 
I might try?


Hardware (details):

#lspci -vnn
...
01:06.0 Multimedia video controller [0400]: Brooktree Corporation Bt848 
Video Capture [109e:0350] (rev 12)
...
Kernel driver in use: bttv

# modprobe -v bttv
insmod /lib/modules/3.16.0-4-amd64/kernel/drivers/media/pci/bt8xx/bttv.ko 
card=25 pll=2

On the card, there is a 35 MHz XTAL. Also I did test with pll=0, no 
obvious change.

The card is equipped with a radio connector - no radio connected.

# dmesg
[11861.804207] bttv: driver version 0.9.19 loaded
[11861.804220] bttv: using 8 buffers with 2080k (520 pages) each for 
capture
[11861.804309] bttv: Bt8xx card found (0)
[11861.804345] bttv: 0: Bt848 (rev 18) at 0000:01:06.0, irq: 17, latency: 
16, mmio: 0xfdeff000
[11861.804376] bttv: 0: using: Terratec TerraTV+ Version 1.0 (Bt848)/ 
Terra TValue Version 1.0/ Vobis TV-Boostar [card=25,insmod option]
[11862.804023] bttv: 0: tea5757: read timeout
[11862.804029] bttv: 0: tuner type=5
[11862.813526] bttv: 0: audio absent, no audio device found!
[11862.819402] All bytes are equal. It is not a TEA5767
[11862.819414] tuner 2-0060: Tuner -1 found with type(s) Radio TV.
[11862.819694] tuner-simple 2-0060: creating new instance
[11862.819697] tuner-simple 2-0060: type set to 5 (Philips PAL_BG (FI1216 
and compatibles))
[11862.821013] bttv: 0: PLL can sleep, using XTAL (35468950)
[11862.821753] bttv: 0: registered device video0
[11862.821816] bttv: 0: registered device vbi0

# uname -a
Linux be12 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt20-1+deb8u2 (2016-01-02) 
x86_64 GNU/Linux

