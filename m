Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:45183 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbZBAV3d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Feb 2009 16:29:33 -0500
Subject: Re: [PATCH] Leadtek WinFast DTV-1800H and DTV-2000H
From: hermann pitton <hermann-pitton@arcor.de>
To: Miroslav =?UTF-8?Q?=C5=A0ustek?= <sustmidown@centrum.cz>,
	Mirek =?UTF-8?Q?Sluge=C5=88?= <thunder.m@email.cz>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <200902011737.4646@centrum.cz>
References: <200902011729.11885@centrum.cz> <200902011730.15853@centrum.cz>
	 <200902011731.21563@centrum.cz> <200902011732.21401@centrum.cz>
	 <200902011733.12125@centrum.cz> <200902011734.8961@centrum.cz>
	 <200902011735.14944@centrum.cz> <200902011736.23401@centrum.cz>
	 <200902011737.4646@centrum.cz>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 01 Feb 2009 22:29:47 +0100
Message-Id: <1233523787.11484.30.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Sonntag, den 01.02.2009, 17:37 +0100 schrieb Miroslav Šustek:
> Hi, few months ago I sent the patch for Leadtek WinFast DTV-1800H card, but it wasn't merged to repository yet.
> Maybe it's because of the merging of mailing lists. I'm sending it again.
> 
> These are the original messages:
> http://linuxtv.org/pipermail/linux-dvb/2008-October/029859.html
> http://linuxtv.org/pipermail/linux-dvb/2008-November/030362.html
> 
> Briefly, patch adds support for analog tv, radio, dvb-t and remote control.
> About three people already confirmed the functionality.
> ----
> 
> The second patch I attached (leadtek_winfast_dtv2000h.patch) is from Mirek Slugeň and it adds support for some revisions of Leadtek WinFast DTV-2000H.
> I don't have any of DTV-2000H cards, so I cannot confirm its correctness.
> 
> Here is the original message from Mirek Slugeň:
> http://linuxtv.org/pipermail/linux-dvb/2008-November/030644.html
> 
> (The patch is dependent on 1800H patch.)
> ----
> 
> I hope this is the last time I'm bothering you with this thing. ;)
> 
> - Miroslav Šustek
> 

Miroslav, Mirek, looks OK so far,

but biggest problem is that all patches have no Signed-off-by line.
Try README.patches in v4l-dvb and related.

The not at all working radio on the DTV2000H_J could indicate that it is
a FMD1216MEX with different radio IF, which was recently added by Darron
Broad. Good idea how they did expand the antenna input connectors.

Also, for the unsupported XCeive4000 on the DTV2000H_PLUS I guess
TUNER_ABSENT should be used until support for it is ready and all
related ?

There is another patch from Mirek for saa7134 with multiple multi
frontend boards from Nov. 28 2008 where I asked for his SOB, but no
response. It has at least a tested-by from me and an updated version
against recent v4l-dvb can be provided.
http://www.linuxtv.org/pipermail/linux-dvb/2009-January/031217.html

Mauro seems to prefer to have v4l-dvb related e-mails at infradead.org.
Changed to it.

Cheers,
Hermann


