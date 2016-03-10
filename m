Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37909 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbcCJQ67 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 11:58:59 -0500
Received: by mail-wm0-f49.google.com with SMTP id l68so37031908wml.1
        for <linux-media@vger.kernel.org>; Thu, 10 Mar 2016 08:58:58 -0800 (PST)
Subject: Re: Driver Technisat Skystar S2 and Compro VideoMate S350
To: neil@ferme-de-la-motte.com, linux-media@vger.kernel.org
References: <014e01d17ad4$45f1e070$d1d5a150$@ferme-de-la-motte.com>
From: Jemma Denson <jdenson@gmail.com>
Message-ID: <56E1A7CF.5050201@gmail.com>
Date: Thu, 10 Mar 2016 16:58:55 +0000
MIME-Version: 1.0
In-Reply-To: <014e01d17ad4$45f1e070$d1d5a150$@ferme-de-la-motte.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Neil,

Sorry, I can't help with the Compro, but maybe with the Technisat :)


On 10/03/16 13:53, Neil Cordwell wrote:
> Technisat Skystar S2
>
> When I first installed this card I couldn't find the firmware
> dvb-fe-cx24120-1.20.58.2.fw. Downloaded this from github and now there are
> no errors in dmesg, but I cannot get the card to tune in MythTV. I wondered
> if the <access denied> in the output of lspci is anything?
>
> 3:05.0 Multimedia controller [0480]: Philips Semiconductors
> SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
>          Subsystem: Compro Technology, Inc. VideoMate T750 [185b:c900]
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
>          Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>          Latency: 64 (21000ns min, 8000ns max)
>          Interrupt: pin A routed to IRQ 20
>          Region 0: Memory at febff800 (32-bit, non-prefetchable) [size=2K]
>          Capabilities: <access denied>
>          Kernel driver in use: saa7134

The above is for the Compro and not the Skystar, but <access denied> is 
likely to just be that it needs root.

<snip>

> I tried to use dvbv5-scan with a simple channel file and get an error. Scan
> does nothing
>
> neil@Sonata-Linux:~/Documents$ dvbv5-scan --input-format=CHANNEL Astra-28.2E
> ERROR Doesn't know how to handle delimiter '[CHANNEL]' while parsing line 2
> of Astra-28.2E
>
>
> [CHANNEL]
>                  DELIVERY_SYSTEM = DVBS2
>                  FREQUENCY = 11719500
>                  POLARIZATION = HORIZONTAL
>                  SYMBOL_RATE = 29500000
>                  INNER_FEC = 3/4
>                  MODULATION = QPSK
>                  INVERSION = AUTO

A few problems here - that's dvbv5 format and not channel so best to 
just skip the input-format, also 11719500 doesn't exist on 28.2E 
anymore, you probably want to be running this as root, and you should be 
specifying the lnb type.

This is how I ran it on mine quite recently whilst fixing a bug in the 
driver (you might need to change the adapter number on -a):
# dvbv5-scan -a 0 -l EXTENDED /usr/share/dvbv5/dvb-s/Astra-28.2E

That bug was patched only a few weeks ago so the above will probably 
fail on some of the transponders. MythTV wasn't affected though so that 
should scan fine, aslong as all the other things with myth are setup ok 
- it's quite fiddly!


Jemma.


