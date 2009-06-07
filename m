Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:43628 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752289AbZFGSfP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2009 14:35:15 -0400
Subject: Re: Leadtek Winfast DTV-1000S
From: hermann pitton <hermann-pitton@arcor.de>
To: braddo@tranceaddict.net
Cc: mkrufky@linuxtv.org, linux-media@vger.kernel.org
In-Reply-To: <20090607084707.ADBA25BE@resin15.mta.everyone.net>
References: <20090607084707.ADBA25BE@resin15.mta.everyone.net>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 20:30:08 +0200
Message-Id: <1244399408.9764.10.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Sonntag, den 07.06.2009, 08:47 -0700 schrieb Brad Allen:
> Dear Mike,
> 
> Have not heard from you in quite some time, has there been any progress on getting this card up and running? As I said to you in a previous email it is extremely close using the settings for card #156, however it fails to detect any DVB-T channels, although the signal strength meter works while its scanning for them.
> 
> I have not tried the FM component of the card.
> 
> Here is lspci -vvv -nn output,
> 
> 00:0e.0 Multimedia controller [0480]: Philips Semiconductors SAA7130 Video Broadcast Decoder [1131:7130] (rev 01)
> 	Subsystem: LeadTek Research Inc. Device [107d:6655]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 32 (21000ns min, 8000ns max)
> 	Interrupt: pin A routed to IRQ 12
> 	Region 0: Memory at eb001000 (32-bit, non-prefetchable) [size=1K]
> 	Capabilities: <access denied>
> 
> For anyone else reading this card is a DVB-T and FM receiver using the SAA7130, TDA10048 and TDA18271. 
> 
> Please let me know if theres anything I can do to be of further assistance.
> 
> Thanks,
> 
> Brad Allen

for your information and for all others interested.

Henry Wu did send modified saa7134 files with support for this card on
Tuesday off list.

Mike replied, that he will set up a test repository as soon he gets some
time for doing so.

The most noticeable difference to the Hauppauge card is, that it works
in TS parallel mode.

Please wait a little until Mike is done with his review and announces
the card for testing here on the list.

Cheers,
Hermann




