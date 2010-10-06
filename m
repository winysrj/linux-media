Return-path: <mchehab@pedra>
Received: from pqueueb.post.tele.dk ([193.162.153.10]:37391 "EHLO
	pqueueb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab0JFFOx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 01:14:53 -0400
Date: Wed, 6 Oct 2010 06:52:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michal Marek <mmarek@suse.cz>, linux-media@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [RFC PATCH] media: consolidation of -I flags
Message-ID: <20101006045255.GA24870@merkur.ravnborg.org>
References: <1285534847-31463-1-git-send-email-mfm@muteddisk.com> <20101005142906.GA20059@merkur.ravnborg.org> <20101005192435.GA17798@haskell.muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101005192435.GA17798@haskell.muteddisk.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> 
> Ah, I was not aware of that, and I forgot to test for that case.
> 
> > > 
> > > If neither idea is considered beneficial, I will go ahead and replace
> > > the older variables with the newer ones as is.
> > 
> > This is the right approach.
> > 
> > You could consider to do a more general cleanup:
> > 1) replace EXTRA_CFLAGS with ccflags-y (the one you suggest)
> > 2) replace use of <module>-objs with <module>-y
> > 3) break continued lines into several assignments
> >    People very often uses '\' to break long lines, where a
> >    simple += would be much more readable.
> >    But this topic may be personal - I never uses "\" in my .c code unless in macros,
> >    and I have applied the same rule for Makefiles.
> >    An ugly example is drivers/media/Makefile
> > 4) In general use ":=" instead of "=".
> >    Add using "+=" as first assignment is OK - but it just looks plain wrong
> > 5) some files has a mixture of spaces/tabs (are red in my vim)
> >    dvb-core/Makefile is one such example
> > 6) remove useless stuff
> >    siano/Makefile has some strange assignments to EXTRA_CFLAGS
> > 7) Likely a few more items to look after...
> > 
> > This is more work - but then you finish a Makefile rather than doing a simple
> > conversion.
> 
> I agree with all your points above; however, I was unsure of whether a wholesale
> cleanup would be welcomed because I would then end up touching numerous lines
> (and in some cases, possibly all lines).
The Makefiles are all very simple - so touching all lines in a files
is not a big deal here. But then you would have to batch your changes
in smaller parts touching only a few Makefiles/one Makefile per patch.

> Is the use of <module>-objs deprecated? Some people might wonder why I am
> changing that when they are not building a multisource object.
I always recommends the <module>-y notation.
Because this version has the flexibility to use the kbuild way
of dealing with conditional modules.

I see no reason to do such change alaone - but as part of other minor
cleanups it would be natural to change to the <module>-y idiom.


All the comments above is valid for staging too. There we should
try to do general cleanup on the Makefile rather than a lot of small
edits.
But sometimes the MAkefiles contains so much legacy that this will be more
than one patch..

	Sam
