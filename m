Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37341 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727662AbeKIWuT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 17:50:19 -0500
Message-ID: <1541768983.4112.38.camel@pengutronix.de>
Subject: Re: [PATCH 2/3] media: imx: set compose rectangle to mbus format
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Date: Fri, 09 Nov 2018 14:09:43 +0100
In-Reply-To: <3614b93e-feeb-a118-efda-e5265af24499@gmail.com>
References: <20181105152055.31254-1-p.zabel@pengutronix.de>
         <20181105152055.31254-2-p.zabel@pengutronix.de>
         <3614b93e-feeb-a118-efda-e5265af24499@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-11-08 at 21:33 -0800, Steve Longerbeam wrote:
> Hi Philipp,
> 
> On 11/5/18 7:20 AM, Philipp Zabel wrote:
> > Prepare for mbus format being smaller than the written rectangle
> > due to burst size.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >   drivers/staging/media/imx/imx-media-capture.c | 55 +++++++++++++------
> >   1 file changed, 38 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
> > index cace8a51aca8..2d49d9573056 100644
> > --- a/drivers/staging/media/imx/imx-media-capture.c
> > +++ b/drivers/staging/media/imx/imx-media-capture.c
> > @@ -203,21 +203,14 @@ static int capture_g_fmt_vid_cap(struct file *file, void *fh,
> >   	return 0;
> >   }
> >   
> > -static int capture_try_fmt_vid_cap(struct file *file, void *fh,
> > -				   struct v4l2_format *f)
> > +static int __capture_try_fmt_vid_cap(struct capture_priv *priv,
> > +				     struct v4l2_subev_format *fmt_src,
> 
> 
> typo: struct v4l2_subdev_format *fmt_src,

Fixed, thanks.

[...]
> > 
> > +	return __capture_try_fmt(priv, &fmt_src, f);
> 
> 
> typo: return __capture_try_fmt_vid_cap(priv, &fmt_src, f);

And thanks. Looks like I've misplaced a fixup! patch.

regards
Philipp
