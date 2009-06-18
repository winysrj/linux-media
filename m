Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout01.t-online.de ([194.25.134.80]:41658 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbZFRKS7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 06:18:59 -0400
Date: Thu, 18 Jun 2009 12:18:31 +0200
From: Halim Sahin <halim.sahin@t-online.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Trent Piepho <xyzzy@speakeasy.org>, linux-media@vger.kernel.org
Subject: ok more details: Re: bttv problem loading takes about several
	minutes
Message-ID: <20090618101831.GA5760@halim.local>
References: <20090617162400.GA11690@halim.local> <Pine.LNX.4.58.0906171001510.32713@shell2.speakeasy.net> <200906172206.27230.hverkuil@xs4all.nl> <20090618095808.GA5685@halim.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090618095808.GA5685@halim.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
sorry for the nusable output!
I found the time consuming funktion:
        bttv_init_card2(btv);
This takes about 4 min. today.
my new testcode:
        /* needs to be done before i2c is registered */
printk("linke 2:bttv_init_card1(btv);\n");

        bttv_init_card1(btv);

        /* register i2c + gpio */
printk("line 3: init_bttv_i2c(btv);\n");

        init_bttv_i2c(btv);

        /* some card-specific stuff (needs working i2c) */
printk("line4:         some card-specific stuff needs working i2c \n");
        bttv_init_card2(btv);
printk("irq init\n");

        init_irqreg(btv);

dmesg output:
[ 2282.430209] bttv: driver version 0.9.18 loaded
[ 2282.430216] bttv: using 8 buffers with 2080k (520 pages) each for capture
[ 2282.430313] bttv: Bt8xx card found (0).
[ 2282.430334] bttv0: Bt878 (rev 17) at 0000:00:0b.0, irq: 19, latency: 32, mmio
: 0xf7800000
[ 2282.430777] bttv0: using: Leadtek WinFast 2000/ WinFast 2000 XP [card=34,insm
od option]
[ 2282.430839] bttv_gpio_tracking(bt
[ 2282.430843] bttv0: gpio: en=00000000, out=00000000 in=003ff502 [init]
[ 2282.430845] linke 2:bttv_init_card1(btv);
[ 2282.430859] line 3: init_bttv_i2c(btv);
[ 2282.430917] line4:         some card-specific stuff needs working i2c
[ 2282.430922] bttv0: tuner type=24

Ok here is the 4 min dely and after that the following linkes were printed out:

[ 2416.836017] bttv0: audio absent, no audio device found!
[ 2416.836024] irq init
[ 2416.840551] bttv0: registered device video1
[ 2416.840684] bttv0: registered device vbi0
[ 2416.840716] bttv0: registered device radio0
[ 2416.840736] bttv0: PLL: 28636363 => 35468950 .<6>bttv0: PLL: 28636363 => 3546
8950 . ok
[ 2416.856221] input: bttv IR (card=34) as /devices/pci0000:00/0000:00:0b.0/inpu
t/input10
[ 2416.864069]  ok

Hope that helps!
Regards
Halim
-- 
Halim Sahin
E-Mail:				
halim.sahin (at) t-online.de
