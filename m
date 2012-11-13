Return-path: <linux-media-owner@vger.kernel.org>
Received: from ks358065.kimsufi.com ([91.121.151.38]:59532 "EHLO
	ks358065.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab2KMJrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 04:47:17 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by ks358065.kimsufi.com (Postfix) with ESMTP id 3B36B1CC04E
	for <linux-media@vger.kernel.org>; Tue, 13 Nov 2012 10:40:37 +0100 (CET)
Received: from ks358065.kimsufi.com ([127.0.0.1])
	by localhost (ks358065.kimsufi.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eTfAja4qAmOl for <linux-media@vger.kernel.org>;
	Tue, 13 Nov 2012 10:40:23 +0100 (CET)
Received: from ceatux.localnet (localhost.localdomain [127.0.0.1])
	by ks358065.kimsufi.com (Postfix) with ESMTPS id 323DC1CC04D
	for <linux-media@vger.kernel.org>; Tue, 13 Nov 2012 10:40:22 +0100 (CET)
From: =?iso-8859-15?q?Fr=E9d=E9ric?= <fma@gbiloba.org>
To: linux-media@vger.kernel.org
Subject: Support for Terratec Cinergy 2400i DT in kernel 3.x
Date: Tue, 13 Nov 2012 10:40:22 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201211131040.22114.fma@gbiloba.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

This is my first post on this list; I hope I'm on the right place to discuss this problem. If 
not, feel free to tell me where I should post.

I bought this DVB-T dual tuner card, in order to put it in my HTPC (running geeXboX/XBMC).

As far as I know, there where only support (patches) for kernel 2.6.x; I didn't find anything 
for 3.x branch. So I tried to port the patches. And I think I got something... Well, maybe!

I followed the links on this wiki page:

    http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_2400i_DVB-T

It seems that the PCIe bridge used on this card needs a firmware in order to work; this is what 
the patch does. I used this files:

    http://wiki.ubuntuusers.de/_attachment?target=/Terratec_Cinergy_2400i_DT/ngene_p11.tar.gz

As my desktop PC runs under debian sid, I only have a 3.2 kernel, so this is the version I 
patched to test the driver.

I can provide all files needed, but I just want to know if the following messages sounds good 
or if there are still problems...

During boot, I get:

 nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
 ngene 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
 ngene: Found Terratec Integra/Cinergy2400i Dual DVB-T
 ngene 0000:03:00.0: setting latency timer to 64
 ngene: Device version 1
 ngene: Loading firmware file ngene_17.fw.
 cxd2099_attach: driver disabled by Kconfig
 DVB: registering new adapter (nGene)
 DVB: registering adapter 0 frontend 0 (Micronas DRXD DVB-T)...
 DVB: registering new adapter (nGene)
 DVB: registering adapter 1 frontend 0 (Micronas DRXD DVB-T)...

Then, when I launch w_scan, I get this from kernel:

 drxd: deviceId = 0000
 DRX3975D-A2
 read deviation -520
 drxd: deviceId = 0000
 DRX3975D-A2
 read deviation -333

and this from w_scan (no antenna pluged):

 $ w_scan -ft -cFR
 w_scan version 20120605 (compiled for DVB API 5.4)
 using settings for FRANCE
 DVB aerial
 DVB-T FR
 scan type TERRESTRIAL, channellist 5
 output format vdr-1.6
 output charset 'UTF-8', use -C <charset> to override
 Info: using DVB adapter auto detection.
         /dev/dvb/adapter0/frontend0 -> TERRESTRIAL "Micronas DRXD DVB-T": good :-) ¹
         /dev/dvb/adapter1/frontend0 -> TERRESTRIAL "Micronas DRXD DVB-T": good :-) ¹
 Using TERRESTRIAL frontend (adapter /dev/dvb/adapter0/frontend0)
 -_-_-_-_ Getting frontend capabilities-_-_-_-_ 
 Using DVB API 5.4
 frontend 'Micronas DRXD DVB-T' supports
 INVERSION_AUTO
 QAM_AUTO
 TRANSMISSION_MODE_AUTO
 GUARD_INTERVAL_AUTO
 HIERARCHY_AUTO
 FEC_AUTO
 FREQ (47.12MHz ... 855.25MHz)
 -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_ 
 Scanning 8MHz frequencies...
 474000: (time: 00:00) 
 474166: (time: 00:03) 
 473834: (time: 00:05) 
 ...
 849834: (time: 09:57) 
 850332: (time: 09:59) 
 850498: (time: 10:02) 
 858000: (time: 10:04)   skipped: (freq 858000000 unsupported by driver)

 initial_tune:2265: Setting frontend failed QAM_AUTO f = 858000 kHz I999B8C999D999T999G999Y999
 858166: (time: 10:04)   skipped: (freq 858166000 unsupported by driver)

 initial_tune:2265: Setting frontend failed QAM_AUTO f = 858166 kHz I999B8C999D999T999G999Y999
 857834: (time: 10:04)   skipped: (freq 857834000 unsupported by driver)

 initial_tune:2265: Setting frontend failed QAM_AUTO f = 857834 kHz I999B8C999D999T999G999Y999
 858332: (time: 10:04)   skipped: (freq 858332000 unsupported by driver)

 initial_tune:2265: Setting frontend failed QAM_AUTO f = 858332 kHz I999B8C999D999T999G999Y999
 858498: (time: 10:04)   skipped: (freq 858498000 unsupported by driver)

 initial_tune:2265: Setting frontend failed QAM_AUTO f = 858498 kHz I999B8C999D999T999G999Y999

 ERROR: Sorry - i couldn't get any working frequency/transponder
  Nothing to scan!!

Reading all these logs, can you tell me if you see obvious problems? I'm neither a kernel guru 
(this is my first driver contact), nor a DVB-T user (so far!), so a lot of things are not clear 
to me.

Thanks for reading.

¹ first time w_scan is launched, these lines take 2-3 seconds, and I guess this is when the 
drxd kernel messages are output.

-- 
   Frédéric
