Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36155 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933301AbaH0JaX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 05:30:23 -0400
Message-ID: <1409131814.3623.40.camel@paszta.hi.pengutronix.de>
Subject: Re: [RFC v2] [media] v4l2: add V4L2 pixel format array and helper
 functions
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Date: Wed, 27 Aug 2014 11:30:14 +0200
In-Reply-To: <1684313.SfePcxMsjg@avalon>
References: <1409043654-12252-1-git-send-email-p.zabel@pengutronix.de>
	 <1684313.SfePcxMsjg@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

thank you for the comments.

Am Dienstag, den 26.08.2014, 12:01 +0200 schrieb Laurent Pinchart:
[...]
> > +};
> > +
> > +const struct v4l2_pixfmt *v4l2_pixfmt_by_fourcc(u32 fourcc)
> > +{
> > +	int i;
> 
> The loop counter is always positive, it can be an unsigned int.

I'll change that.

> > +	for (i = 0; i < ARRAY_SIZE(v4l2_pixfmts); i++) {
> > +		if (v4l2_pixfmts[i].pixelformat == fourcc)
> > +			return v4l2_pixfmts + i;
> > +	}
> 
> We currently have 123 pixel formats defined, and that number will keep 
> increasing. I wonder if something more efficient than an O(n) array lookup 
> would be worth it.

How about a function similar to soc_mbus_find_fmtdesc that uses an array
provided by the driver:

const struct v4l2_pixfmt_info *v4l2_find_pixfmt(u32 pixelformat,
		const struct v4l2_pixfmt_info *array, unsigned int len)
{
	unsigned int i;

	for (i = 0; i < len; i++) {
		if (pixelformat == array[i].pixelformat)
			return array + i;
	}

	return NULL;
}

And a function to fill this driver specific array from the global array
once:

void v4l2_init_pixfmt_array(struct v4l2_pixfmt_info *array, int len)
{
	unsigned int i;

	for (i = 0; i < len; i++)
		array[i] = *v4l2_pixfmt_by_fourcc(array[i].pixelformat);
}

A driver could then do the following:

static struct v4l2_pixfmt_info driver_formats[] = {
	{ .pixelformat = V4L2_PIX_FMT_YUYV },
	{ .pixelformat = V4L2_PIX_FMT_YUV420 },
};

int driver_probe(...)
{
	...
	v4l2_init_pixfmt_array(driver_formats,
			ARRAY_SIZE(driver_formats));
	...
}

[...]
> > +unsigned int v4l2_sizeimage(const struct v4l2_pixfmt *fmt, unsigned int
> > width,
> > +			    unsigned int height)
> > +{
> 
> A small comment would be useful here to explain why we don't round up in the 
> second case.

Agreed, I think the YUV410 case is a good example for this.

[...]
> > +/**
> > + * struct v4l2_pixfmt - internal V4L2 pixel format description
> 
> Maybe struct v4l2_pixfmt_info ?

That's fine with me.

regards
Philipp

