Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55978 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbbCIVrk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 17:47:40 -0400
Date: Mon, 9 Mar 2015 22:46:58 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Josh Wu <josh.wu@atmel.com>
Subject: Re: [PATCH v4 2/2] V4L: add CCF support to the v4l2_clk API
In-Reply-To: <20150302135523.1f34dc84@recife.lan>
Message-ID: <Pine.LNX.4.64.1503092244280.15137@axis700.grange>
References: <Pine.LNX.4.64.1502010007180.26661@axis700.grange>
 <Pine.LNX.4.64.1502010019380.26661@axis700.grange> <8420980.1Z1tGTCX4O@avalon>
 <Pine.LNX.4.64.1502011211160.9534@axis700.grange> <20150302135523.1f34dc84@recife.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, 2 Mar 2015, Mauro Carvalho Chehab wrote:

> Em Sun, 1 Feb 2015 12:12:33 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:
> 
> > V4L2 clocks, e.g. used by camera sensors for their master clock, do not
> > have to be supplied by a different V4L2 driver, they can also be
> > supplied by an independent source. In this case the standart kernel
> > clock API should be used to handle such clocks. This patch adds support
> > for such cases.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> > v4: sizeof(*clk) :)
> > 
> >  drivers/media/v4l2-core/v4l2-clk.c | 48 +++++++++++++++++++++++++++++++++++---
> >  include/media/v4l2-clk.h           |  2 ++
> >  2 files changed, 47 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-clk.c b/drivers/media/v4l2-core/v4l2-clk.c
> > index 3ff0b00..9f8cb20 100644
> > --- a/drivers/media/v4l2-core/v4l2-clk.c
> > +++ b/drivers/media/v4l2-core/v4l2-clk.c
> > @@ -9,6 +9,7 @@
> >   */
> >  
> >  #include <linux/atomic.h>
> > +#include <linux/clk.h>
> >  #include <linux/device.h>
> >  #include <linux/errno.h>
> >  #include <linux/list.h>
> > @@ -37,6 +38,21 @@ static struct v4l2_clk *v4l2_clk_find(const char *dev_id)
> >  struct v4l2_clk *v4l2_clk_get(struct device *dev, const char *id)
> >  {
> >  	struct v4l2_clk *clk;
> > +	struct clk *ccf_clk = clk_get(dev, id);
> > +
> > +	if (PTR_ERR(ccf_clk) == -EPROBE_DEFER)
> > +		return ERR_PTR(-EPROBE_DEFER);
> 
> Why not do just:
> 		return ccf_clk;

I would prefer that shorter form too, but the function returns "struct 
v4l2_clk *" and ccf_clk is "struct clk *"

Thanks
Guennadi
