Return-path: <linux-media-owner@vger.kernel.org>
Received: from imta-38.everyone.net ([216.200.145.38]:46351 "EHLO
	omta0109.mta.everyone.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751508AbZFGPrG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2009 11:47:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20090607084707.ADBA25BE@resin15.mta.everyone.net>
Date: Sun, 7 Jun 2009 08:47:07 -0700
From: "Brad Allen" <braddo@tranceaddict.net>
Reply-To: <braddo@tranceaddict.net>
To: <mkrufky@linuxtv.org>
Cc: <linux-media@vger.kernel.org>
Subject: Leadtek Winfast DTV-1000S
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Mike,

Have not heard from you in quite some time, has there been any progress on getting this card up and running? As I said to you in a previous email it is extremely close using the settings for card #156, however it fails to detect any DVB-T channels, although the signal strength meter works while its scanning for them.

I have not tried the FM component of the card.

Here is lspci -vvv -nn output,

00:0e.0 Multimedia controller [0480]: Philips Semiconductors SAA7130 Video Broadcast Decoder [1131:7130] (rev 01)
	Subsystem: LeadTek Research Inc. Device [107d:6655]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (21000ns min, 8000ns max)
	Interrupt: pin A routed to IRQ 12
	Region 0: Memory at eb001000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>

For anyone else reading this card is a DVB-T and FM receiver using the SAA7130, TDA10048 and TDA18271. 

Please let me know if theres anything I can do to be of further assistance.

Thanks,

Brad Allen
