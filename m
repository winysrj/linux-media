Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab0GFB0Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jul 2010 21:26:25 -0400
Message-ID: <4C328641.1000106@redhat.com>
Date: Mon, 05 Jul 2010 22:26:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ramiro Morales <ramiro@rmorales.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] saa7134: Add support for Compro VideoMate Vista M1F
References: <20100612215757.GA4796@fao>
In-Reply-To: <20100612215757.GA4796@fao>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 12-06-2010 18:57, Ramiro Morales escreveu:
> Hi all,
> 
> (I've just subscribed myself to the list so I can't easily reply to the
> original "[PATCH for 2.6.34] saa7134: add support for Compro VideoMate
> M1F" thread from May 25 started by Pavel Osnova.)
> 
> I've just bought this card. I'm in Argentina so if there are several
> models it should be the appropriate one for this market (PAL-NC?).
> 
> Find below Pavel's latest patch adapted/updated to v4l-dvb Mercurial
> repository status as of today (Hg revision 023a0048e6a8).
> 
> For a start, the PCI ID is different from the Pavel's one (185b:c900):
> 
>   $ lspci |grep -i philips
>   01:07.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
>   $ lspci -n |grep 01\:07\.0
>   01:07.0 0480: 1131:7133 (rev d1)
> 
> (btw, it's the same PCI ID as card #17: AOPEN VA1000 POWER)
> 
> I've decided to maintain Pavel's name, email address and
> "Signed-off-by:" header, hopefully he will be able to review the patch
> and give his opinion.
> 
> Will reply to this message with another one containing a full
> description of the card components hermann-pitton had asked for.

I need the patch author Signed-off-by, in order to be able to apply it.
As you're sending me the patches, I need your SOB also. Please c/c the
author's email on the email you send me submitting his patches.

Cheers,
Mauro
