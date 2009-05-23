Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:62869 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZEWNEk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 09:04:40 -0400
Received: by fxm12 with SMTP id 12so368390fxm.37
        for <linux-media@vger.kernel.org>; Sat, 23 May 2009 06:04:40 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Simon Kenyon <simon@koala.ie>
Subject: Re: [linux-dvb] SDMC DM1105N not being detected
Date: Sat, 23 May 2009 16:04:29 +0300
Cc: linux-media@vger.kernel.org
References: <e6ac15e50904022156u40221c3fib15d1b4cdf36461@mail.gmail.com> <4A140936.6020001@koala.ie>
In-Reply-To: <4A140936.6020001@koala.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905231604.29795.liplianin@tut.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20 May 2009 16:44:22 Simon Kenyon wrote:
> mp3geek wrote:
> > Not even being detected in Linux 2.6.29.1, I have the modules "dm1105"
> > loaded, but since its not even being detected by linux..
> >
> > lspci -vv shows this (I'm assuming this is the card..), dmesg shows
> > nothing dvb being loaded
> >
> > 00:0b.0 Ethernet controller: Device 195d:1105 (rev 10)
> >     Subsystem: Device 195d:1105
> >     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> > ParErr- Stepping- SERR- FastB2B- DisINTx-
> >     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> >     Latency: 30 (4000ns min, 8000ns max), Cache Line Size: 32 bytes
> >     Interrupt: pin A routed to IRQ 5
> >     Region 0: I/O ports at 9400 [size=256]
> >
> >
> > The chip says the following, SDMC DM1105N, EasyTV-DVBS V1.0B
> > (2008-04-26), 0735 E280034
>
> because i saw that there was a driver written by igor, i took a chance
> and bought a DM04 DVB-S card on ebay. it only cost €20 (including
> shipping from HK to Ireland) so i reckoned "nothing ventured, nothing
> gained"
> on a windows box it runs rather nicely. granted that the software
> provided does not provide a BDA driver, so you are pretty much limited
> to the stuff that comes with the card.
> but a big "me too" on linux (which is what i bought it for)
> i similarly get an "ethernet controller" and nothing in the kernel log
> when i load the dm1105 module.
>
> what do i need to do to debug the situation and/or update the driver?
>
> regards
> --
> simon

It seems, one can find GPIO values for LNB power control.
Do not forget about Vendor/Device ID's. 

I wrote code to support card with subsystem/device 195d/1105, but no one reported success, so I 
decided not to include it in commit :(

It was more then one year ago

http://liplianin.at.tut.by/dvblipl.tar.bz2

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
