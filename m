Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:41688 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726800AbeIKUaN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 16:30:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 5/6] media: isp: fix a warning about a wrong struct initializer
Date: Tue, 11 Sep 2018 18:30:35 +0300
Message-ID: <1783382.4JyS2BFIxL@avalon>
In-Reply-To: <1547255.gQsGpOKB2G@avalon>
References: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org> <1638882.BEPym44MaE@avalon> <1547255.gQsGpOKB2G@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Friday, 7 September 2018 14:46:34 EEST Laurent Pinchart wrote:
> Hi Mauro,
> 
> As maintainers should be held to the same level of obligations as
> developers, and to avoid demotivating reviewers, could you handle comments
> you receive before pushing your own patches to your tree ? There should be
> no maintainer privilege here.

Ping ?

> On Wednesday, 8 August 2018 18:45:49 EEST Laurent Pinchart wrote:
> > Hi Mauro,
> > 
> > Thank you for the patch.
> > 
> > The subject line should be "media: omap3isp: ...".
> > 
> > On Wednesday, 8 August 2018 17:52:55 EEST Mauro Carvalho Chehab wrote:
> >> As sparse complains:
> >> 	drivers/media/platform/omap3isp/isp.c:303:39: warning: Using plain
> >> 	integer as NULL pointer
> >> 
> >> when a struct is initialized with { 0 }, actually the first
> >> element of the struct is initialized with zeros, initializing the
> >> other elements recursively. That can even generate gcc warnings
> >> on nested structs.
> >> 
> > > So, instead, use the gcc-specific syntax for that (with is used
> >> broadly inside the Kernel), initializing it with {};
> >> 
> >> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> >> ---
> >> 
> >>  drivers/media/platform/omap3isp/isp.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> diff --git a/drivers/media/platform/omap3isp/isp.c
> >> b/drivers/media/platform/omap3isp/isp.c index 03354d513311..842e2235047d
> >> 100644
> >> --- a/drivers/media/platform/omap3isp/isp.c
> >> +++ b/drivers/media/platform/omap3isp/isp.c
> >> @@ -300,7 +300,7 @@ static struct clk *isp_xclk_src_get(struct
> >> of_phandle_args *clkspec, void *data)
> >>  static int isp_xclk_init(struct isp_device *isp)
> >>  {
> >>  	struct device_node *np = isp->dev->of_node;
> >> -	struct clk_init_data init = { 0 };
> >> +	struct clk_init_data init = {};
> > 
> > How about = { NULL }; to avoid a gcc-specific syntax ?
> > 
> >>  	unsigned int i;
> >>  	
> >>  	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i)

-- 
Regards,

Laurent Pinchart
