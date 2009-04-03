Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63549 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933995AbZDCPgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2009 11:36:39 -0400
Received: by fxm2 with SMTP id 2so1033491fxm.37
        for <linux-media@vger.kernel.org>; Fri, 03 Apr 2009 08:36:36 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: mp3geek <mp3geek@gmail.com>
Subject: Re: SDMC DM1105N not being detected
Date: Fri, 3 Apr 2009 18:36:19 +0300
Cc: linux-media@vger.kernel.org
References: <e6ac15e50904022156u40221c3fib15d1b4cdf36461@mail.gmail.com> <e6ac15e50904022202k1f71120bgc10837efd1ec0f24@mail.gmail.com>
In-Reply-To: <e6ac15e50904022202k1f71120bgc10837efd1ec0f24@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904031836.19523.liplianin@tut.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3 April 2009 08:02:20 mp3geek wrote:
> Not even being detected in Linux 2.6.29.1, I have the modules "dm1105"
> loaded, but since its not even being detected by linux..
>
> lspci -vv shows this (I'm assuming this is the card..), dmesg shows
> nothing dvb being loaded
>
> 00:0b.0 Ethernet controller: Device 195d:1105 (rev 10)
>    Subsystem: Device 195d:1105
>    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>    Latency: 30 (4000ns min, 8000ns max), Cache Line Size: 32 bytes
>    Interrupt: pin A routed to IRQ 5
>    Region 0: I/O ports at 9400 [size=256]
>
>
> The chip says the following, SDMC DM1105N, EasyTV-DVBS V1.0B
> (2008-04-26), 0735 E280034
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I wrote code to support card with subsystem/device 195d/1105, but no one reported success, so I 
decided to not include it in commit :(

It was more then one year ago

http://liplianin.at.tut.by/dvblipl.tar.bz2

http://liplianin.at.tut.by/ds110en.html
-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
