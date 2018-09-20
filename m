Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:33306 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbeITXEj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 19:04:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 5/6] media: isp: fix a warning about a wrong struct initializer
Date: Thu, 20 Sep 2018 20:20:20 +0300
Message-ID: <1663744.uWdDvEofyc@avalon>
In-Reply-To: <20180920114453.54424b60@coco.lan>
References: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org> <1547255.gQsGpOKB2G@avalon> <20180920114453.54424b60@coco.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday, 20 September 2018 17:44:53 EEST Mauro Carvalho Chehab wrote:
> Em Fri, 07 Sep 2018 14:46:34 +0300 Laurent Pinchart escreveu:
> > Hi Mauro,
> > 
> > As maintainers should be held to the same level of obligations as
> > developers, and to avoid demotivating reviewers, could you handle
> > comments you receive before pushing your own patches to your tree ? There
> > should be no maintainer privilege here.
> 
> Sorry, yeah, this was improperly handled. Not sure what happened.
> 
> From whatever reason, I ended by mishandling this and lost the
> related emails. I had to do several e-mail changes at the beginning
> of August, as I'm not using s-opensource.com anymore, and had to
> reconfigure my inbox handling logic.

Thank you for the explanation.

> Do you want me to revert the patch?

I appreciate the proposal, but there's no need to :-) It's not a big issue, I 
could easily submit a follow-up patch, but even that isn't really needed. My 
main concern was the lack of reaction to the review, and now that this has be 
cleared, the issue is closed for me.

> > On Wednesday, 8 August 2018 18:45:49 EEST Laurent Pinchart wrote:
> > > Hi Mauro,
> > > 
> > > Thank you for the patch.
> > > 
> > > The subject line should be "media: omap3isp: ...".
> > > 
> > > On Wednesday, 8 August 2018 17:52:55 EEST Mauro Carvalho Chehab wrote:
> > > > As sparse complains:
> > > > 	drivers/media/platform/omap3isp/isp.c:303:39: warning: Using plain
> > > > 	integer
> > > > 
> > > > as NULL pointer
> > > > 
> > > > when a struct is initialized with { 0 }, actually the first
> > > > element of the struct is initialized with zeros, initializing the
> > > > other elements recursively. That can even generate gcc warnings
> > > > on nested structs.
> > > > 
> > > > So, instead, use the gcc-specific syntax for that (with is used
> > > > broadly inside the Kernel), initializing it with {};
> > > > 
> > > > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > > > ---
> > > > 
> > > >  drivers/media/platform/omap3isp/isp.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/media/platform/omap3isp/isp.c
> > > > b/drivers/media/platform/omap3isp/isp.c index
> > > > 03354d513311..842e2235047d
> > > > 100644
> > > > --- a/drivers/media/platform/omap3isp/isp.c
> > > > +++ b/drivers/media/platform/omap3isp/isp.c
> > > > @@ -300,7 +300,7 @@ static struct clk *isp_xclk_src_get(struct
> > > > of_phandle_args *clkspec, void *data) static int isp_xclk_init(struct
> > > > isp_device *isp)
> > > > 
> > > >  {
> > > >  
> > > >  	struct device_node *np = isp->dev->of_node;
> > > > 
> > > > -	struct clk_init_data init = { 0 };
> > > > +	struct clk_init_data init = {};
> > > 
> > > How about = { NULL }; to avoid a gcc-specific syntax ?
> > > 
> > > >  	unsigned int i;
> > > >  	
> > > >  	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i)
> 
> Thanks,
> Mauro


-- 
Regards,

Laurent Pinchart
