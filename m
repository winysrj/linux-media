Return-path: <mchehab@pedra>
Received: from as-10.de ([212.112.241.2]:49391 "EHLO mail.as-10.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab0HJI0j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Aug 2010 04:26:39 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.as-10.de (Postfix) with ESMTP id E04D033A6D3
	for <linux-media@vger.kernel.org>; Tue, 10 Aug 2010 10:26:37 +0200 (CEST)
Received: from mail.as-10.de ([127.0.0.1])
	by localhost (as-10.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HAiqae1RgYDA for <linux-media@vger.kernel.org>;
	Tue, 10 Aug 2010 10:26:37 +0200 (CEST)
Received: from gentoo.local (pD9E3E9E6.dip.t-dialin.net [217.227.233.230])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: web11p28)
	by mail.as-10.de (Postfix) with ESMTPSA id ADF7433A6CD
	for <linux-media@vger.kernel.org>; Tue, 10 Aug 2010 10:26:37 +0200 (CEST)
Date: Tue, 10 Aug 2010 10:26:41 +0200
From: Halim Sahin <halim.sahin@t-online.de>
To: linux-media@vger.kernel.org
Subject: knc1 dvb-c card frequently looses CAM when switching channels
 quickly
Message-ID: <20100810082640.GA13226@gentoo.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,
Really no idea?
BR.
halim

Hello,
I have experienced the following on my vdr machine:

When changing channels quickly between encrypted channels, the card
loosses cam and I get the following in my /var/log/messages:


[   67.645354] dvb_ca adapter 0: DVB CAM detected and initialised successfully
[   84.659047] budget-av: cam inserted A
[   85.656855] dvb_ca adapter 0: DVB CAM detected and initialised successfully
[60706.931218] budget-av: cam inserted A
[60707.485891] dvb_ca adapter 0: DVB CAM detected and initialised
successfully


lspci -vvv

03:00.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
	Subsystem: KNC One Device 0022
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (3750ns min, 9500ns max)
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at f9fffc00 (32-bit, non-prefetchable) [size=512]
	Kernel driver in use: budget_av

I am using drivers from kernel 2.6.34.
Any Ideas for solving this issue?
Thx.
Halim

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
