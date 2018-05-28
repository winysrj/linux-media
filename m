Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40140 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030629AbeE1KRo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 06:17:44 -0400
Date: Mon, 28 May 2018 13:17:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [GIT PULL FOR v4.18] R-Car VSP1 TLB optimisation
Message-ID: <20180528101724.fzyo7eh5fyf25y7y@mwanda>
References: <10831984.07PNLvckhh@avalon>
 <20180525201027.1d5c82eb@vento.lan>
 <4867226.Y05TeWaCcJ@avalon>
 <1657947.LKPPaiEoOV@avalon>
 <20180526082818.70a369b5@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180526082818.70a369b5@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 26, 2018 at 08:28:18AM -0300, Mauro Carvalho Chehab wrote:
> Em Sat, 26 May 2018 03:24:00 +0300
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> 
> > Hi Mauro,
> > 
> > On Saturday, 26 May 2018 02:39:16 EEST Laurent Pinchart wrote:
> > > On Saturday, 26 May 2018 02:10:27 EEST Mauro Carvalho Chehab wrote:  
> > > > Em Sun, 20 May 2018 15:10:50 +0300 Laurent Pinchart escreveu:  
> > > >> Hi Mauro,
> > > >> 
> > > >> The following changes since commit
> > > >> 
> > > >> 8ed8bba70b4355b1ba029b151ade84475dd12991:
> > > >>   media: imx274: remove non-indexed pointers from mode_table (2018-05-17
> > > >> 
> > > >> 06:22:08 -0400)
> > > >> 
> > > >> are available in the Git repository at:
> > > >>   git://linuxtv.org/pinchartl/media.git v4l2/vsp1/next
> > > >> 
> > > >> for you to fetch changes up to 429f256501652c90a4ed82f2416618f82a77d37c:
> > > >>   media: vsp1: Move video configuration to a cached dlb (2018-05-20
> > > >>   09:46:51 +0300)
> > > >> 
> > > >> The branch passes the VSP and DU test suites, both on its own and when
> > > >> merged with the drm-next branch.  
> > > > 
> > > > This series added a new warning:
> > > > 
> > > > drivers/media/platform/vsp1/vsp1_dl.c:69: warning: Function parameter or
> > > > member 'refcnt' not described in 'vsp1_dl_body'  
> > > 
> > > We'll fix that. Kieran, as you authored the code, would you like to give it
> > > a go ?
> > >   
> > > > To the already existing one:
> > > > 
> > > > drivers/media/platform/vsp1/vsp1_drm.c:336 vsp1_du_pipeline_setup_brx()
> > > > error: we previously assumed 'pipe->brx' could be null (see line 244)  
> > > 
> > > That's still on my todo list. I tried to give it a go but received plenty of
> > > SQL errors. How do you run smatch ?  
> > 
> > Nevermind, I found out what was wrong (had to specify the data directory 
> > manually).
> > 
> > I've reproduced the issue and created a minimal test case.
> > 
> >  1. struct vsp1_pipeline;
> >  2.   
> >  3. struct vsp1_entity {
> >  4.         struct vsp1_pipeline *pipe;
> >  5.         struct vsp1_entity *sink;
> >  6.         unsigned int source_pad;
> >  7. };
> >  8. 
> >  9. struct vsp1_pipeline {
> > 10.         struct vsp1_entity *brx;
> > 11. };
> > 12. 
> > 13. struct vsp1_brx {
> > 14.         struct vsp1_entity entity;
> > 15. };
> > 16. 
> > 17. struct vsp1_device {
> > 18.         struct vsp1_brx *bru;
> > 19.         struct vsp1_brx *brs;
> > 20. };
> > 21. 
> > 22. unsigned int frob(struct vsp1_device *vsp1, struct vsp1_pipeline *pipe)
> > 23. {
> > 24.         struct vsp1_entity *brx;
> > 25. 
> > 26.         if (pipe->brx)
> > 27.                 brx = pipe->brx;
> > 28.         else if (!vsp1->bru->entity.pipe)
> > 29.                 brx = &vsp1->bru->entity;
> > 30.         else
> > 31.                 brx = &vsp1->brs->entity;
> > 32. 
> > 33.         if (brx != pipe->brx)
> > 34.                 pipe->brx = brx;
> > 35. 
> > 36.         return pipe->brx->source_pad;
> > 37. }
> > 
> > The reason why smatch complains is that it has no guarantee that vsp1->brs is 
> > not NULL. It's quite tricky:
> > 
> > - On line 26, smatch assumes that pipe->brx can be NULL
> > - On line 27, brx is assigned a non-NULL value (as pipe->brx is not NULL due 
> > to line 26)
> > - On line 28, smatch assumes that vsp1->bru is not NULL
> > - On line 29, brx is assigned a non-NULL value (as vsp1->bru is not NULL due 
> > to line 28)
> > - On line 31, brx is assigned a possibly NULL value (as there's no information 
> > regarding vsp1->brs)
> > - On line 34, pipe->brx is not assigned a non-NULL value if brx is NULL
> > - On line 36 pipe->brx is dereferenced
> > 
> > The problem comes from the fact that smatch assumes that vsp1->brs isn't NULL. 
> > Adding a "(void)vsp1->brs->entity;" statement on line 25 makes the warning 
> > disappear.
> > 

I will respond to the other emails in this thread.  You guys are
basically spot on.  All this analysis is 100% correct.  Btw, if you want
to see Smatch's internal state you can do:

#include "/home/whatever/smatch/check_debug.h"

	else if (!vsp1->bru->entity.pipe) {
		__smatch_implied(&vsp1->bru->entity);

And it tells you what Smatch thinks it is at that point.  The
__smatch_about() output can also be useful.

regards,
dan carpenter
