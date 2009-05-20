Return-path: <linux-media-owner@vger.kernel.org>
Received: from [195.7.61.12] ([195.7.61.12]:44622 "EHLO killala.koala.ie"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbZETOFv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 10:05:51 -0400
Message-ID: <4A140936.6020001@koala.ie>
Date: Wed, 20 May 2009 14:44:22 +0100
From: Simon Kenyon <simon@koala.ie>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: liplianin@me.by
Subject: Re: [linux-dvb] SDMC DM1105N not being detected
References: <e6ac15e50904022156u40221c3fib15d1b4cdf36461@mail.gmail.com>
In-Reply-To: <e6ac15e50904022156u40221c3fib15d1b4cdf36461@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

mp3geek wrote:
> Not even being detected in Linux 2.6.29.1, I have the modules "dm1105"
> loaded, but since its not even being detected by linux..
>
> lspci -vv shows this (I'm assuming this is the card..), dmesg shows
> nothing dvb being loaded
>
> 00:0b.0 Ethernet controller: Device 195d:1105 (rev 10)
>     Subsystem: Device 195d:1105
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>     Latency: 30 (4000ns min, 8000ns max), Cache Line Size: 32 bytes
>     Interrupt: pin A routed to IRQ 5
>     Region 0: I/O ports at 9400 [size=256]
>
>
> The chip says the following, SDMC DM1105N, EasyTV-DVBS V1.0B
> (2008-04-26), 0735 E280034
>   
because i saw that there was a driver written by igor, i took a chance 
and bought a DM04 DVB-S card on ebay. it only cost €20 (including 
shipping from HK to Ireland) so i reckoned "nothing ventured, nothing 
gained"
on a windows box it runs rather nicely. granted that the software 
provided does not provide a BDA driver, so you are pretty much limited 
to the stuff that comes with the card.
but a big "me too" on linux (which is what i bought it for)
i similarly get an "ethernet controller" and nothing in the kernel log 
when i load the dm1105 module.

what do i need to do to debug the situation and/or update the driver?

regards
--
simon
