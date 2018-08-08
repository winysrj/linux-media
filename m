Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56102 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbeHHQSM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 12:18:12 -0400
Date: Wed, 8 Aug 2018 10:58:20 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: vsp1: cleanup a false positive warning
Message-ID: <20180808105820.67469806@coco.lan>
In-Reply-To: <20180507122103.40048014@vento.lan>
References: <a1bedd480c31bcc2f48cd6d965a9bb853e8786ee.1525436031.git.mchehab+samsung@kernel.org>
        <3223850.s1aV98ALtZ@avalon>
        <20180507122103.40048014@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 7 May 2018 12:21:03 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:

> Em Mon, 07 May 2018 17:05:24 +0300
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
> 
> > Hi Mauro,
> > 
> > Thank you for the patch.
> > 
> > On Friday, 4 May 2018 15:13:58 EEST Mauro Carvalho Chehab wrote:  
> > > With the new vsp1 code changes introduced by changeset
> > > f81f9adc4ee1 ("media: v4l: vsp1: Assign BRU and BRS to pipelines
> > > dynamically"), smatch complains with:
> > > 	drivers/media/platform/vsp1/vsp1_drm.c:262 vsp1_du_pipeline_setup_bru()
> > > error: we previously assumed 'pipe->bru' could be null (see line 180)
> > > 
> > > This is a false positive, as, if pipe->bru is NULL, the brx
> > > var will be different, with ends by calling a code that will
> > > set pipe->bru to another value.
> > > 
> > > Yet, cleaning this false positive is as easy as adding an explicit
> > > check if pipe->bru is NULL.    
> > 
> > It's not very difficult indeed, but it really is a false positive. I think the 
> > proposed change decreases readability, the condition currently reads as "if 
> > (new brx != old brx)", why does smatch even flag that as an error ?  
> 
> I've no idea. Never studied smatch code. If you don't think that
> this is a fix for it, do you have an alternative patch (either to
> smatch or to vsp1)?

Ping.

We're carrying this warning since the latest Kernel release. If you
don't have a better fix, let's apply it for 4.19. You may work on
a different solution if you think you'll be able to either patch
smatch in order to identify such complex logic or do something else
at the vsp1 code to simplify the logic on future Kernel revisions.

> 
> Regards,
> Mauro
> 
> >   
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > > ---
> > >  drivers/media/platform/vsp1/vsp1_drm.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> > > b/drivers/media/platform/vsp1/vsp1_drm.c index 095dc48aa25a..cb6b60843400
> > > 100644
> > > --- a/drivers/media/platform/vsp1/vsp1_drm.c
> > > +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> > > @@ -185,7 +185,7 @@ static int vsp1_du_pipeline_setup_brx(struct vsp1_device
> > > *vsp1, brx = &vsp1->brs->entity;
> > > 
> > >  	/* Switch BRx if needed. */
> > > -	if (brx != pipe->brx) {
> > > +	if (brx != pipe->brx || !pipe->brx) {
> > >  		struct vsp1_entity *released_brx = NULL;
> > > 
> > >  		/* Release our BRx if we have one. */    
> >   
> 
> 
> 
> Thanks,
> Mauro



Thanks,
Mauro
