Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37490 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbZD1S7B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2009 14:59:01 -0400
Date: Tue, 28 Apr 2009 15:58:53 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Pieter Van Schaik <vansterpc@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2] Enabling of the Winfast TV2000 XP Global TV capture
 card  remote control
Message-ID: <20090428155853.03a9c6e8@pedra.chehab.org>
In-Reply-To: <1240712951.3714.13.camel@pc07.localdom.local>
References: <faf98b150904232135l7593612dr68b7ed9cac9af385@mail.gmail.com>
	<1240712951.3714.13.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 26 Apr 2009 04:29:11 +0200
hermann pitton <hermann-pitton@arcor.de> wrote:

> 
> Am Freitag, den 24.04.2009, 06:35 +0200 schrieb Pieter Van Schaik:
> > This patch is for supporting the remote control of the Winfast TV2000
> > XP Global TV capture card. A case statement was added in order to
> > initialize the GPIO data structures as well as a case statement for
> > handling the keys correctly when pressed.
> > 
> > Thanks to Hermann for all his help
> > 
> > Regards
> > Pieter van Schaik


Pieter,

You forgot your SOB on your v2 patch. Could you please send a v3 with it enclosed?

> Mauro,
> 
> please give some further comments, how to proceed within this
> "patchwork" stuff.
> 
> For what I can see, you get some of out of sync patches so far?
> 
> Do you do the sync and can I ignore such remaining efforts, or do you
> prefer people are waiting until this is somehow properly lined up again?

Hermann,

Sorry, but I didn't understand what you're meaning. 

I generally run some scripts that read the patchwork patches based on the
internal patchwork numbering representation (in general, it is from the oldest
to the newest one).

However, sometimes I skip patches or I update they manually at web interface,
due to a countless number of reasons (duplicated patches, obsoleted patches,
patches that generate more discusions, etc...).

So, don't expect that I'll apply the patches on any particular order. If you
really need patches to be applied sequentially, please number they with [PATCH x/y].

In this specific case, should I need to apply a patch before this one for it to work?

> 
> I have nothing important and nobody cared about the oops on the Compro
> T750F stuff, on which I was not involved, but I would like to have a
> warning in for the Asus 3in1 not to use a rotor with it.

I dunno what patches are you referring. Could you please point their patchwork
numbers?

Cheers,
Mauro
