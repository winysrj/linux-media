Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp10.online.nl ([194.134.42.55]:59269 "EHLO smtp10.online.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757314AbZEaI4X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 04:56:23 -0400
Received: from smtp10.online.nl (localhost [127.0.0.1])
	by smtp10.online.nl (Postfix) with ESMTP id 3C8CE402F8
	for <linux-media@vger.kernel.org>; Sun, 31 May 2009 10:56:24 +0200 (CEST)
Received: from sander-desktop.localnet (unknown [83.119.175.103])
	by smtp10.online.nl (Postfix) with ESMTP
	for <linux-media@vger.kernel.org>; Sun, 31 May 2009 10:56:24 +0200 (CEST)
From: Sander Pientka <cumulus0007@gmail.com>
To: linux-media@vger.kernel.org
Subject: Zolid Hybrid TV Card
Date: Sun, 31 May 2009 10:56:23 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905311056.23968.cumulus0007@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

First of all, I'm sorry if you received this message 3 times, frankly I didn't 
know how this mailing list worked.

So, I decided to give my miserable TV card one last shot. It's advert for eBay 
is done, the only thing that stops me from selling is the "Send" button.
 

Anyhow, after lots of searching mailing lists, I found out that I should have 
a look at the Vendor and Device ID and the Subdevice ID. So I did a deep lspci 
with the options vvvxxxnn:
 

04:09.0 Multimedia controller [0480]: Philips Semiconductors 
SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
 Subsystem: Philips Semiconductors Device [1131:2004]
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B- DisINTx-
 Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
 Latency: 32 (21000ns min, 8000ns max)
 Interrupt: pin A routed to IRQ 17
 Region 0: Memory at fdcfe000 (32-bit, non-prefetchable) [size=2K]
 Capabilities: [40] Power Management version 2
 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
 Kernel driver in use: saa7134
 Kernel modules: saa7134
 00: 31 11 33 71 06 00 90 02 d1 00 80 04 00 20 00 00
 10: 00 e0 cf fd 00 00 00 00 00 00 00 00 00 00 00 00
 20: 00 00 00 00 00 00 00 00 00 00 00 00 31 11 04 20
 30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 01 54 20
 40: 01 00 02 06 00 20 00 1c 00 00 00 00 00 00 00 00
 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 

SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
 Subsystem: Philips Semiconductors Device [1131:2004]
 

Apparently , the Vendor is Philips (1131), the device is the 
SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (7133), I'm getting this info 
from pci.ids. But what about the subsystem? What's a subsystem? I opened 
CARDLIST.saa7134 and searched for 1131:7133. And I did get a hit:
 

 17 -> AOPEN VA1000 POWER [1131:7133]
 

Erhm, huh? An AOPEN? That can't be right. I have a Zolid, unless this card was 
rebranded, which should be possible according to it's low cost.
 

Then, I hit ctrl+f and searched for my subsystem ID. Wow, and there were hits, 
2 to be precise!
 

 61 -> Philips TOUGH DVB-T reference design [1131:2004]
 

 69 -> Philips EUROPA V3 reference design [1131:2004]
 


Hmm, so my card can be a reference design too... A reference design, is it 
allowed to sell those things?
 

Now I'm confused.
 

Btw, I'm sorry for being a bit ironic, but I've had it with this card.
-- 
Met vriendelijke groet,
Sander Pientka
