Return-path: <linux-media-owner@vger.kernel.org>
Received: from ado-01.adocentral.net.au ([203.88.117.121]:37206 "EHLO
	ado-01.adocentral.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbZAPLb7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2009 06:31:59 -0500
Received: from localhost (localhost [127.0.0.1])
	by ado-01.adocentral.net.au (Postfix) with ESMTP id 32E855890C
	for <linux-media@vger.kernel.org>; Fri, 16 Jan 2009 22:31:58 +1100 (EST)
Received: from ado-01.adocentral.net.au ([127.0.0.1])
	by localhost (ado-01.adocentral.net.au [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sxXFUR3wuDVA for <linux-media@vger.kernel.org>;
	Fri, 16 Jan 2009 22:31:57 +1100 (EST)
Received: from [192.168.1.20] (ppp167-251-1.static.internode.on.net [59.167.251.1])
	by ado-01.adocentral.net.au (Postfix) with ESMTP id 7F4215890B
	for <linux-media@vger.kernel.org>; Fri, 16 Jan 2009 22:31:57 +1100 (EST)
Message-ID: <4970702D.2040907@bat.id.au>
Date: Fri, 16 Jan 2009 22:31:57 +1100
From: Aaron Theodore <aaron@bat.id.au>
Reply-To: aaron@bat.id.au
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Twinhan DST stops working under latest v4l-dvb
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It seems the latest v4l-dvb causes issues with my Twinhan 1020


bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
ACPI: PCI Interrupt 0000:05:08.0[A] -> Link [APC3] -> GSI 18 (level, 
low) -> IRQ 18
bttv0: Bt878 (rev 17) at 0000:05:08.0, irq: 18, latency: 32, mmio: 
0xcb000000
bttv0: using: Twinhan DST + clones [card=113,insmod option]
bttv0: gpio: en=00000000, out=00000000 in=00fefffe [init]
bttv0: tuner absent
bttv0: add subdevice "dvb0"
bt878: AUDIO driver version 0.0.0 loaded
dvb_bt8xx: unable to determine DMA core of card 0,
dvb_bt8xx: if you have the ALSA bt87x audio driver installed, try 
removing it.
dvb-bt8xx: probe of dvb0 failed with error -14

i tried unloading all the sound modules made no difference (even though 
i didnt have the bt87x module loaded)

This card works on earlier kernel modules.

Any ideas?
