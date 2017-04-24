Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38538 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1172870AbdDXOrz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Apr 2017 10:47:55 -0400
Date: Mon, 24 Apr 2017 17:47:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] Order the Makefile alphabetically
Message-ID: <20170424144721.GT7456@valkosipuli.retiisi.org.uk>
References: <20170406144051.13008-1-maxime.ripard@free-electrons.com>
 <20170419081538.38272ae6@vento.lan>
 <20170421144125.dnahmsnsjj2h6drv@lukather>
 <20170421121055.3c2b3f70@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170421121055.3c2b3f70@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro and Maxime,

On Fri, Apr 21, 2017 at 12:11:05PM -0300, Mauro Carvalho Chehab wrote:
> Em Fri, 21 Apr 2017 16:41:25 +0200
> Maxime Ripard <maxime.ripard@free-electrons.com> escreveu:
> 
> > On Wed, Apr 19, 2017 at 08:15:45AM -0300, Mauro Carvalho Chehab wrote:
> > > Em Thu,  6 Apr 2017 16:40:51 +0200
> > > Maxime Ripard <maxime.ripard@free-electrons.com> escreveu:
> > >   
> > > > The Makefiles were a free for all without a clear order defined. Sort all the
> > > > options based on the Kconfig symbol.
> > > > 
> > > > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > > 
> > > > ---
> > > > 
> > > > Hi Mauro,
> > > > 
> > > > Here is my makefile ordering patch again, this time with all the Makefiles
> > > > in drivers/media that needed ordering.
> > > > 
> > > > Since we're already pretty late in the release period, I guess there won't
> > > > be any major conflicts between now and the merge window.
> > > >   
> > > 
> > > The thing with patches like that is that they almost never apply fine.
> > > By the time I review such patches, it was already broken. Also,
> > > once applied, it breaks for everybody that have pending work to merge.
> > > 
> > > This patch is broken (see attached).
> > > 
> > > So, I prefer not applying stuff like that.  
> > 
> > I had the feeling that now would have been a good time to merge it,
> > since all the PR should be merged I guess. But ok.
> 
> No, there are drivers that were late-submitted, and whose commit
> (if driver gets accepted) will be after -rc1. If this patch gets 
> applied, those drivers will have merge conflicts. There are also
> the cases where people have drivers under development. If they pull
> from my tree after a change like that, the developer will get
> conflicts.

Resolving a single conflict in a Makefile is certainly not unfeasible.
Generally it'd be good to prioritise cleanups.

When would it be a good time to get such changes in? Right in the beginning
of the next merge window in media tree?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
