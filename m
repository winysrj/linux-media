Return-path: <linux-media-owner@vger.kernel.org>
Received: from web54201.mail.re2.yahoo.com ([206.190.39.243]:21567 "HELO
	web54201.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758434Ab0AOXff convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 18:35:35 -0500
Message-ID: <55579.13932.qm@web54201.mail.re2.yahoo.com>
Date: Fri, 15 Jan 2010 15:28:53 -0800 (PST)
From: Chuck McCrobie <mccrobie2000@yahoo.com>
Subject: Avermedia A317
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Wow!  I see I need a flame retardant suit here after the last few emails from the list...  but to the point:

I have an HP HDX 18t with a PCI-E TV Card.  Looks to be an Avermedia A317 based on the Windows .inf file and the PCI vendor/product and subsystem vendor/product ids.

I've started to kick around the saa716x_hybrid.c file to support the card.  I can sort-of see how to add support in saa716x_hybrid.c, but I'm not sure as to what is needed.

1)  Looks like I need a separate MAKE_ENTRY for the combination of 7160 and 1055 product ids.

2)  Looks like I need a separate config structure.  However, I'm not sure of the I2C addresses - do all 7160 cards have things at the same I2C addresses?

3)  Windows oem9.inf file suggests this card has a TDA18271 thingy - I assume this is the tuner chip.

4)  I see the tda18271_attach routine - and I see that it can be called via dvb_attach, but I don't know where to get the "frontend" structure thingy.

Details: (apologies if word wrap is messed up...)

05:00.0 0480: 1131:7160 (rev 03)
        Subsystem: 1461:1055    
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx- 
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 11                        
        Region 0: Memory at da000000 (64-bit, non-prefetchable) [size=1M]                               
        Capabilities: <access denied>                                                                        

Pointers and/or hints are appreciated.

Thanks,

Chuck McCrobie



      
