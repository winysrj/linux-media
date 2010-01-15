Return-path: <linux-media-owner@vger.kernel.org>
Received: from webmail.velocitynet.com.au ([203.17.154.21]:52327 "EHLO
	webmail2.velocitynet.com.au" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756788Ab0AOJZh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 04:25:37 -0500
Received: from webmail.velocity.net.au (localhost [127.0.0.1])
	by webmail2.velocitynet.com.au (Postfix) with ESMTP id E6848366C6
	for <linux-media@vger.kernel.org>; Fri, 15 Jan 2010 09:15:26 +0000 (UTC)
MIME-Version: 1.0
Date: Fri, 15 Jan 2010 09:15:26 +0000
From: <paul10@planar.id.au>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: DM1105: could not attach frontend 195d:1105
Message-ID: <ea6e586942d83e4c727f335a200815a0@mail.velocitynet.com.au>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I bought a DVB-S card to attach to my mythtv setup.  I knew it was perhaps
not going to work, and I only spent $15 on it.  However, based on the info
the guy on eBay provided, it had a pci address of 195d:1105, which I could
see some people had cards that were working.

The card itself is a no-name jobby.  I can see the DM1105 chip on it, I
can't see any other chips with any significant pin count (lots with 3 - 8
pins, but nothing with enough to be important).  There is a metal case
around the connectors that might be hiding a frontend chip of some sort,
but it doesn't seem to have enough connectors in and out to be doing much
that is important beyond just providing connectivity to the LNB.

I've got the latest kernel (2.6.33-rc4) and I've checked the code and it
looks like the latest DM1105 code.  When booting I get:

[    9.766188] dm1105 0000:06:00.0: PCI INT A -> GSI 20 (level, low) ->
IRQ 20
[   10.047331] dm1105 0000:06:00.0: MAC 00:00:00:00:00:00
[   12.464628] dm1105 0000:06:00.0: could not attach frontend
[   12.479830] dm1105 0000:06:00.0: PCI INT A disabled

With lspci -vv I get:
06:00.0 Ethernet controller: Device 195d:1105 (rev 10)
        Subsystem: Device 195d:1105
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 20
        Region 0: I/O ports at b000 [size=256]

No DVB devices are created.

I see from other people using a card with this chipset that there probably
would be a tuner/frontend as well as the DM1105. I've also tried card=5 in
the insmod parameters.

It seems to me that the card probably has a tuner/frontend on id different
from the Axess board, but I'm not sure how I'd work out what that is.  Is
it possible that it doesn't have any chips on it other than the DM1105? 
Should I take the board apart a bit to find out?

Thanks,

Paul

