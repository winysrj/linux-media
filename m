Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailex.mailcore.me ([94.136.40.61]:52757 "EHLO
	mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980Ab3IOPfM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Sep 2013 11:35:12 -0400
Received: from 189-68-156-123.dsl.telesp.net.br ([189.68.156.123] helo=[192.168.1.123])
	by mail10.atlas.pipex.net with esmtpa (Exim 4.71)
	(envelope-from <it@sca-uk.com>)
	id 1VLE2F-0008C9-Lw
	for linux-media@vger.kernel.org; Sun, 15 Sep 2013 16:14:52 +0100
Message-ID: <5235CED8.3080804@sca-uk.com>
Date: Sun, 15 Sep 2013 12:14:32 -0300
From: Steve Cookson <it@sca-uk.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Hauppauge ImpactVCB-e 01381 PCIe driver resolution.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guys,

I seem to be having immense difficulty getting the Hauppauge ImpactVCB-e 
01381 PCIe card working on Linux (I'm using Kubuntu 13.04) with greater 
than 320x240 resolution.

This is what I've done:

lspci recognises the card but only as a Conexant card (Vendor ID = 
14f1:8852), not Hauppauge card (Vendor ID = 0070).  Hauppauge is shown 
as the subsystem (0070:7133).  I don't really know what this means.

lsmod returns nothing related to the card.

dmesg  | grep cx23885 suggested card=<n> insmod option (full output from 
dmesg below).  So I did:

echo cx23885 card=5 | sudo tee -a /etc/modules

So I tried a few version numbers, but they all give me 320x240 in 
s-video or composite mode.

If I use a Pinnacle Dazzle, I get perfect 640x480 for about the same 
price.  But I need an internal PCIe card, rather than a external card/box.

How can I add the card to video4Linux?

Any help much appreciated.

Regards

Steve




   8.921332] cx23885 driver version 0.0.3 loaded
[    8.921390] cx23885[0]: Your board isn't known (yet) to the driver.
[    8.921390] cx23885[0]: Try to pick one of the existing card configs via
[    8.921390] cx23885[0]: card=<n> insmod option.  Updating to the latest
[    8.921390] cx23885[0]: version might help as well.
[    8.921393] cx23885[0]: Here is a list of valid choices for the 
card=<n> insmod option:
[    8.921395] cx23885[0]:    card=0 -> UNKNOWN/GENERIC
[    8.921396] cx23885[0]:    card=1 -> Hauppauge WinTV-HVR1800lp
[    8.921397] cx23885[0]:    card=2 -> Hauppauge WinTV-HVR1800
[    8.921398] cx23885[0]:    card=3 -> Hauppauge WinTV-HVR1250
[    8.921399] cx23885[0]:    card=4 -> DViCO FusionHDTV5 Express
[    8.921400] cx23885[0]:    card=5 -> Hauppauge WinTV-HVR1500Q
[    8.921401] cx23885[0]:    card=6 -> Hauppauge WinTV-HVR1500
[    8.921402] cx23885[0]:    card=7 -> Hauppauge WinTV-HVR1200
[    8.921403] cx23885[0]:    card=8 -> Hauppauge WinTV-HVR1700
[    8.921404] cx23885[0]:    card=9 -> Hauppauge WinTV-HVR1400
[    8.921405] cx23885[0]:    card=10 -> DViCO FusionHDTV7 Dual Express
[    8.921406] cx23885[0]:    card=11 -> DViCO FusionHDTV DVB-T Dual 
Express
[    8.921407] cx23885[0]:    card=12 -> Leadtek Winfast PxDVR3200 H
[    8.921408] cx23885[0]:    card=13 -> Compro VideoMate E650F
[    8.921409] cx23885[0]:    card=14 -> TurboSight TBS 6920
[    8.921410] cx23885[0]:    card=15 -> TeVii S470
[    8.921411] cx23885[0]:    card=16 -> DVBWorld DVB-S2 2005
[    8.921412] cx23885[0]:    card=17 -> NetUP Dual DVB-S2 CI
[    8.921413] cx23885[0]:    card=18 -> Hauppauge WinTV-HVR1270
[    8.921414] cx23885[0]:    card=19 -> Hauppauge WinTV-HVR1275
[    8.921415] cx23885[0]:    card=20 -> Hauppauge WinTV-HVR1255
[    8.921416] cx23885[0]:    card=21 -> Hauppauge WinTV-HVR1210
[    8.921417] cx23885[0]:    card=22 -> Mygica X8506 DMB-TH
[    8.921418] cx23885[0]:    card=23 -> Magic-Pro ProHDTV Extreme 2
[    8.921419] cx23885[0]:    card=24 -> Hauppauge WinTV-HVR1850
[    8.921420] cx23885[0]:    card=25 -> Compro VideoMate E800
[    8.921421] cx23885[0]:    card=26 -> Hauppauge WinTV-HVR1290
[    8.921422] cx23885[0]:    card=27 -> Mygica X8558 PRO DMB-TH
[    8.921424] cx23885[0]:    card=28 -> LEADTEK WinFast PxTV1200
[    8.921425] cx23885[0]:    card=29 -> GoTView X5 3D Hybrid
[    8.921426] cx23885[0]:    card=30 -> NetUP Dual DVB-T/C-CI RF
[    8.921427] cx23885[0]:    card=31 -> Leadtek Winfast PxDVR3200 H XC4000
[    8.921428] cx23885[0]:    card=32 -> MPX-885
[    8.921429] cx23885[0]:    card=33 -> Mygica X8502/X8507 ISDB-T
[    8.921430] cx23885[0]:    card=34 -> TerraTec Cinergy T PCIe Dual
[    8.921431] cx23885[0]:    card=35 -> TeVii S471
[    8.921432] cx23885[0]:    card=36 -> Hauppauge WinTV-HVR1255
[    8.921433] cx23885[0]:    card=37 -> Prof Revolution DVB-S2 8000
[    8.921434] cx23885[0]:    card=38 -> Hauppauge WinTV-HVR4400
[    8.921435] cx23885[0]:    card=39 -> AVerTV Hybrid Express Slim HC81R
[    8.921526] CORE cx23885[0]: subsystem: 0070:7133, board: 
UNKNOWN/GENERIC [card=0,autodetected]
[    9.047515] cx23885_dev_checkrevision() Hardware revision = 0xa5
[    9.047518] cx23885[0]/0: found at 0000:03:00.0, rev: 4, irq: 18, 
latency: 0, mmio: 0xfbe00000
