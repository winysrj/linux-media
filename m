Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:33954 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbbFMDQ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 23:16:26 -0400
Received: by obbsn1 with SMTP id sn1so33727704obb.1
        for <linux-media@vger.kernel.org>; Fri, 12 Jun 2015 20:16:25 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 12 Jun 2015 21:16:25 -0600
Message-ID: <CAGGr8Nt3pWTOsDJZQ9_hQo1j1Aow47W6xrTsPgXsH_+0S1sksA@mail.gmail.com>
Subject: AverMedia HD Duet (White Box) A188WB drivers
From: David Nelson <nelson.dt@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have the AverMedia HD Duet (White Box) A188WB. Which has been
working great for several years in Windows 7 Media Center. I just
tried installing Mythbuntu but it does not appear to be recognized. I
am a bit of a newbie but I managed to find some info about it.

Does anyone know of a driver for it? lspci says it uses the Philips
SAA7160 which does appear to be in a few other supported devices.

Details follow

I get the following from lspci -vvnnk

03:00.0 Multimedia controller [0480]: Philips Semiconductors SAA7160
[1131:7160] (rev 01)
Subsystem: Avermedia Technologies Inc Device [1461:1e55]
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 10
Region 0: Memory at ef800000 (64-bit, non-prefetchable) [size=1M]
Capabilities: <access denied>


I can see that there is a driver for a few other devices with this
chip at http://www.linuxtv.org/wiki/index.php/NXP_SAA716x  (i.e.
heading "As of (2014-06-07)"


-- 
-David Nelson
