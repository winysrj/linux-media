Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41225
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1422796AbdDURIk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Apr 2017 13:08:40 -0400
Date: Fri, 21 Apr 2017 12:11:05 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] Order the Makefile alphabetically
Message-ID: <20170421121055.3c2b3f70@vento.lan>
In-Reply-To: <20170421144125.dnahmsnsjj2h6drv@lukather>
References: <20170406144051.13008-1-maxime.ripard@free-electrons.com>
        <20170419081538.38272ae6@vento.lan>
        <20170421144125.dnahmsnsjj2h6drv@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 21 Apr 2017 16:41:25 +0200
Maxime Ripard <maxime.ripard@free-electrons.com> escreveu:

> On Wed, Apr 19, 2017 at 08:15:45AM -0300, Mauro Carvalho Chehab wrote:
> > Em Thu,  6 Apr 2017 16:40:51 +0200
> > Maxime Ripard <maxime.ripard@free-electrons.com> escreveu:
> >   
> > > The Makefiles were a free for all without a clear order defined. Sort all the
> > > options based on the Kconfig symbol.
> > > 
> > > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > 
> > > ---
> > > 
> > > Hi Mauro,
> > > 
> > > Here is my makefile ordering patch again, this time with all the Makefiles
> > > in drivers/media that needed ordering.
> > > 
> > > Since we're already pretty late in the release period, I guess there won't
> > > be any major conflicts between now and the merge window.
> > >   
> > 
> > The thing with patches like that is that they almost never apply fine.
> > By the time I review such patches, it was already broken. Also,
> > once applied, it breaks for everybody that have pending work to merge.
> > 
> > This patch is broken (see attached).
> > 
> > So, I prefer not applying stuff like that.  
> 
> I had the feeling that now would have been a good time to merge it,
> since all the PR should be merged I guess. But ok.

No, there are drivers that were late-submitted, and whose commit
(if driver gets accepted) will be after -rc1. If this patch gets 
applied, those drivers will have merge conflicts. There are also
the cases where people have drivers under development. If they pull
from my tree after a change like that, the developer will get
conflicts.


Thanks,
Mauro
