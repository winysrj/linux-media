Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36083 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235AbbCCQk5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2015 11:40:57 -0500
Date: Tue, 3 Mar 2015 13:40:50 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-media@vger.kernel.org, josh.wu@atmel.com,
	g.liakhovetski@gmx.de
Subject: Re: [PATCH v4 2/2] V4L: add CCF support to the v4l2_clk API
Message-ID: <20150303134050.17bb1f4c@recife.lan>
In-Reply-To: <qcg754.nklrbz.ru1ns5-qmf@galahad.ideasonboard.com>
References: <Pine.LNX.4.64.1502010007180.26661@axis700.grange>
	<Pine.LNX.4.64.1502010019380.26661@axis700.grange>
	<8420980.1Z1tGTCX4O@avalon>
	<Pine.LNX.4.64.1502011211160.9534@axis700.grange>
	<20150302135523.1f34dc84@recife.lan>
	<qcg754.nklrbz.ru1ns5-qmf@galahad.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 02 Mar 2015 20:52:41 +0000
laurent.pinchart@ideasonboard.com escreveu:

> Hi Mauro,
> 
> On Mon Mar 02 2015 18:55:23 GMT+0200 (EET), Mauro Carvalho Chehab wrote:
> > Em Sun, 1 Feb 2015 12:12:33 +0100 (CET)
> > Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:
> > 
> > > V4L2 clocks, e.g. used by camera sensors for their master clock, do not
> > > have to be supplied by a different V4L2 driver, they can also be
> > > supplied by an independent source. In this case the standart kernel
> > > clock API should be used to handle such clocks. This patch adds support
> > > for such cases.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > ---
> > > 
> > > v4: sizeof(*clk) :)
> > > 
> > >  drivers/media/v4l2-core/v4l2-clk.c | 48 +++++++++++++++++++++++++++++++++++---
> > >  include/media/v4l2-clk.h           |  2 ++
> > >  2 files changed, 47 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/media/v4l2-core/v4l2-clk.c b/drivers/media/v4l2-core/v4l2-clk.c
> > > index 3ff0b00..9f8cb20 100644
> > > --- a/drivers/media/v4l2-core/v4l2-clk.c
> > > +++ b/drivers/media/v4l2-core/v4l2-clk.c
> > > @@ -9,6 +9,7 @@
> > >   */
> > >  
> > >  #include <linux/atomic.h>
> > > +#include <linux/clk.h>
> > >  #include <linux/device.h>
> > >  #include <linux/errno.h>
> > >  #include <linux/list.h>
> > > @@ -37,6 +38,21 @@ static struct v4l2_clk *v4l2_clk_find(const char *dev_id)
> > >  struct v4l2_clk *v4l2_clk_get(struct device *dev, const char *id)
> > >  {
> > >  	struct v4l2_clk *clk;
> > > +	struct clk *ccf_clk = clk_get(dev, id);
> > > +
> > > +	if (PTR_ERR(ccf_clk) == -EPROBE_DEFER)
> > > +		return ERR_PTR(-EPROBE_DEFER);
> > 
> > Why not do just:
> > 		return ccf_clk;
> 
> I find the explicit error slightly more readable, but that's a matter of taste.

Well, return(ccf_clk) will likely produce a smaller instruction code
than return (long).

>  
> > > +
> > > +	if (!IS_ERR_OR_NULL(ccf_clk)) {
> > > +		clk = kzalloc(sizeof(*clk), GFP_KERNEL);
> > > +		if (!clk) {
> > > +			clk_put(ccf_clk);
> > > +			return ERR_PTR(-ENOMEM);
> > > +		}
> > > +		clk->clk = ccf_clk;
> > > +
> > > +		return clk;
> > > +	}
> > 
> > The error condition here looks a little weird to me. I mean, if the
> > CCF clock returns an error, shouldn't it fail instead of silently
> > run some logic to find another clock source? Isn't it risky on getting
> > a wrong value?
> 
> The idea is that, in the long term, everything should use CCF directly. However, we have clock providers on platforms where CCF isn't avalaible. V4L2 clock has been introduced  as a  single API usable by V4L2 clock users allowing them to retrieve and use clocks regardless of whether the provider uses CCF or not. Internally it first tries CCF, and then falls back to the non-CCF implementation in case of failure. 

Yeah, I got that the non-CCF is a fallback code, to be used on
platforms that CCF isn't available.

However, the above code doesn't seem to look if CCF is available
or not. Instead, it assumes that *all* error codes, or even NULL,
means that CCF isn't available.

Shouldn't it be, instead, either waiting for NULL or for some
specific error code, in order to:
- return the error code, if CCF is available but getting
  the clock failed;
- run the backward-compat code when CCF is not available.

Regards,
Mauro
