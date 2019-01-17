Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE63C43444
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 12:46:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C35B20855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 12:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfAQMqu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 07:46:50 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:42955 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfAQMqt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 07:46:49 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gk74J-0004se-8f; Thu, 17 Jan 2019 13:46:47 +0100
Message-ID: <1547729205.4009.3.camel@pengutronix.de>
Subject: Re: [PATCH v3 1/3] media: imx: add capture compose rectangle
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
        Steve Longerbeam <slongerbeam@gmail.com>
Date:   Thu, 17 Jan 2019 13:46:45 +0100
In-Reply-To: <f23fae30-d1ed-7817-e531-d47a47ea94a5@xs4all.nl>
References: <20190111111053.12551-1-p.zabel@pengutronix.de>
         <f23fae30-d1ed-7817-e531-d47a47ea94a5@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

thank you for the review.

On Wed, 2019-01-16 at 16:29 +0100, Hans Verkuil wrote:
[...]
> @@ -290,6 +294,34 @@ static int capture_s_std(struct file *file, void *fh, v4l2_std_id std)
> >  	return v4l2_subdev_call(priv->src_sd, video, s_std, std);
> >  }
> >  
> > +static int capture_g_selection(struct file *file, void *fh,
> > +			       struct v4l2_selection *s)
> > +{
> > +	struct capture_priv *priv = video_drvdata(file);
> > +
> > +	switch (s->target) {
> > +	case V4L2_SEL_TGT_CROP:
> > +	case V4L2_SEL_TGT_CROP_DEFAULT:
> > +	case V4L2_SEL_TGT_CROP_BOUNDS:
> 
> The crop rectangle is equal to the compose rectangle? That can't be right.
> Does the hardware support cropping at all? Probably not, and in that case
> you shouldn't support the crop target at all.

Indeed the hardware does not support cropping at the DMA controller,
that has to be done in the CSI subdev already. I'll drop the CROP
targets.

> > +	case V4L2_SEL_TGT_COMPOSE:
> > +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> > +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> > +	case V4L2_SEL_TGT_COMPOSE_PADDED:
> > +		s->r = priv->vdev.compose;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int capture_s_selection(struct file *file, void *fh,
> > +			       struct v4l2_selection *s)
> > +{
> > +	return capture_g_selection(file, fh, s);
> > +}
> 
> Don't implement s_selection unless you can actually change the selection
> rectangle(s).

Ok, I'll only support g_selection for now. The main purpose of this
series is to allow capturing non-burstsize aligned widths at the CSI,
which are written padded to burst size alignement, and to report the
valid pixels to userspace via COMPOSE_DEFAULT rectangle.

regards
Philipp
