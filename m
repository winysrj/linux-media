Return-path: <linux-media-owner@vger.kernel.org>
Received: from out.selfhost.de ([82.98.82.95]:52467 "EHLO outgoing.selfhost.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753057AbbLKOiA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 09:38:00 -0500
Message-ID: <1449844281.21939.5.camel@oenings.de>
Subject: Problems with TV card "TeVii S472"
From: Hendrik Oenings <debian@oenings.de>
To: linux-media@vger.kernel.org
Date: Fri, 11 Dec 2015 15:31:21 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've got a DVB-S2 PCI-Express tv card ("Tevii S472", http://tevii.com/P
roducts_S472_1.asp) with Debian testing, but I'm not able to get it
work.
On TeVii's webpage there is a linux driver availible (http://tevii.com/
Support.asp), but if I try to compile the driver, it says that my
kernel version isn't supported (current debian testing installed).

The PCIe bridge is cx23885, the demodulator is m88ds3103 and I assume
that the RF Tuner is m88ts2022.

The kernel messages just say:
> $ dmesg | grep dvb
> $ dmesg | grep cx23885
> [    8.295142] cx23885[0]:    card=46 -&gt; DVBSky T980C
> [    8.295143] cx23885[0]:    card=47 -&gt; DVBSky S950C
> [    8.295143] cx23885[0]:    card=48 -&gt; Technotrend TT-budget
> CT2-4500 CI
> [    8.295144] cx23885[0]:    card=49 -&gt; DVBSky S950
> [    8.295145] cx23885[0]:    card=50 -&gt; DVBSky S952
> [    8.295145] cx23885[0]:    card=51 -&gt; DVBSky T982
> [    8.295146] cx23885[0]:    card=52 -&gt; Hauppauge WinTV-HVR5525
> [    8.295147] cx23885[0]:    card=53 -&gt; Hauppauge WinTV Starburst
> [    8.295159] CORE cx23885[0]: subsystem: d472:9022, board:
> UNKNOWN/GENERIC [card=0,autodetected]
> [    8.422227] cx23885_dev_checkrevision() Hardware revision = 0xa5
> [    8.422230] cx23885[0]/0: found at 0000:03:00.0, rev: 4, irq: 19,
> latency: 0, mmio: 0xf7c00000
> $ dmesg | grep ds3103
> $ dmesg | grep ts2022

The firmware (dvb-fe-ds3103.fw) was copied to /lib/firmware.

Regards,
Hendrik

