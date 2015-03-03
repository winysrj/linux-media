Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37562 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335AbbCCXVf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2015 18:21:35 -0500
Date: Tue, 3 Mar 2015 20:21:29 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, josh.wu@atmel.com,
	g.liakhovetski@gmx.de
Subject: Re: [PATCH v4 2/2] V4L: add CCF support to the v4l2_clk API
Message-ID: <20150303202129.6c88a8e6@recife.lan>
In-Reply-To: <1930989.nfYKYx2vJh@avalon>
References: <Pine.LNX.4.64.1502010007180.26661@axis700.grange>
	<qcg754.nklrbz.ru1ns5-qmf@galahad.ideasonboard.com>
	<20150303134050.17bb1f4c@recife.lan>
	<1930989.nfYKYx2vJh@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 04 Mar 2015 00:56:18 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Tuesday 03 March 2015 13:40:50 Mauro Carvalho Chehab wrote:
> > Em Mon, 02 Mar 2015 20:52:41 +0000 Laurent Pinchart escreveu:
> > > On Mon Mar 02 2015 18:55:23 GMT+0200 (EET), Mauro Carvalho Chehab wrote:
> > >> Em Sun, 1 Feb 2015 12:12:33 +0100 (CET) Guennadi Liakhovetski escreveu:
> > >>> V4L2 clocks, e.g. used by camera sensors for their master clock, do
> > >>> not have to be supplied by a different V4L2 driver, they can also be
> > >>> supplied by an independent source. In this case the standart kernel
> > >>> clock API should be used to handle such clocks. This patch adds
> > >>> support for such cases.
> > >>> 
> > >>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > >>> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > >>> ---
> > >>> 
> > >>> v4: sizeof(*clk) :)
> > >>> 
> > >>>  drivers/media/v4l2-core/v4l2-clk.c | 48 ++++++++++++++++++++++++++---
> > >>>  include/media/v4l2-clk.h           |  2 ++
> > >>>  2 files changed, 47 insertions(+), 3 deletions(-)
> > >>> 
> > >>> diff --git a/drivers/media/v4l2-core/v4l2-clk.c
> > >>> b/drivers/media/v4l2-core/v4l2-clk.c index 3ff0b00..9f8cb20 100644
> > >>> --- a/drivers/media/v4l2-core/v4l2-clk.c
> > >>> +++ b/drivers/media/v4l2-core/v4l2-clk.c
> 
> [snip]
> 
> > >>> @@ -37,6 +38,21 @@ static struct v4l2_clk *v4l2_clk_find(const char
> > >>> *dev_id)
> > >>> struct v4l2_clk *v4l2_clk_get(struct device *dev, const char *id)
> > >>> {
> > >>>  	struct v4l2_clk *clk;
> > >>> 
> > >>> +	struct clk *ccf_clk = clk_get(dev, id);
> > >>> +
> > >>> +	if (PTR_ERR(ccf_clk) == -EPROBE_DEFER)
> > >>> +		return ERR_PTR(-EPROBE_DEFER);
> > >> 
> > >> Why not do just:
> > >> 		return ccf_clk;
> > > 
> > > I find the explicit error slightly more readable, but that's a matter of
> > > taste.
> >
> > Well, return(ccf_clk) will likely produce a smaller instruction code
> > than return (long).
> 
> Not if the compiler is smart :-)
> 
> > >>> +
> > >>> +	if (!IS_ERR_OR_NULL(ccf_clk)) {
> > >>> +		clk = kzalloc(sizeof(*clk), GFP_KERNEL);
> > >>> +		if (!clk) {
> > >>> +			clk_put(ccf_clk);
> > >>> +			return ERR_PTR(-ENOMEM);
> > >>> +		}
> > >>> +		clk->clk = ccf_clk;
> > >>> +
> > >>> +		return clk;
> > >>> +	}
> > >> 
> > >> The error condition here looks a little weird to me. I mean, if the
> > >> CCF clock returns an error, shouldn't it fail instead of silently
> > >> run some logic to find another clock source? Isn't it risky on getting
> > >> a wrong value?
> > > 
> > > The idea is that, in the long term, everything should use CCF directly.
> > > However, we have clock providers on platforms where CCF isn't avalaible.
> > > V4L2 clock has been introduced  as a  single API usable by V4L2 clock
> > > users allowing them to retrieve and use clocks regardless of whether the
> > > provider uses CCF or not. Internally it first tries CCF, and then falls
> > > back to the non-CCF implementation in case of failure.
> >
> > Yeah, I got that the non-CCF is a fallback code, to be used on
> > platforms that CCF isn't available.
> > 
> > However, the above code doesn't seem to look if CCF is available
> > or not. Instead, it assumes that *all* error codes, or even NULL,
> > means that CCF isn't available.
> > 
> > Shouldn't it be, instead, either waiting for NULL or for some
> > specific error code, in order to:
> > - return the error code, if CCF is available but getting
> >   the clock failed;
> > - run the backward-compat code when CCF is not available.
> 
> Isn't that pretty much what the code is doing ? If we get a -EPROBE_DEFER 
> error from CCF meaning that the clock is known but not registered yet we 
> return it. Otherwise, if the clock is unknown to CCF, or if CCF is disabled, 
> we fall back.

I didn't check the CCF code, but couldn't it return error codes like
ENOMEM? What are all the error codes it can return ATM? What, among
them, can happen when CCF is available?

Also, as the CCF code can be changed, if the intent behavior is to only
allow EPROBE_DEFER or NULL, if the there is support for CCF, then you
need to have an explicit comment there to avoid that any newer patches
to add different error codes.

IMHO, it seems a way better to define a single error code to be
returned when the platform doesn't support CCF (like -ENOTSUPP),
and calling the fallback code only in this case. Something like:

	if (PTR_ERR(ccf_clk) != -ENOTSUPP)
		return ccf_clk;

	/* CCF is not supported. Fall back to the old way */	
	k = kzalloc(sizeof(*clk), GFP_KERNEL);
	if (!clk) {
		clk_put(ccf_clk);
		return ERR_PTR(-ENOMEM);
	}
	clk->clk = ccf_clk;
	return clk;

Regards,
Mauro
