Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 067D0C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 09:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2E332229F
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 09:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394991AbfBNJSm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 04:18:42 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:35003 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388784AbfBNJSl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 04:18:41 -0500
Received: from aptenodytes (aaubervilliers-681-1-89-68.w90-88.abo.wanadoo.fr [90.88.30.68])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 7751024000F;
        Thu, 14 Feb 2019 09:18:38 +0000 (UTC)
Message-ID: <0b6bd0f8f1ad67e85e00127dbf1b2c7e78efbfd0.camel@bootlin.com>
Subject: Re: [PATCH] media: cedrus: Forbid setting new formats on busy queues
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Date:   Thu, 14 Feb 2019 10:18:38 +0100
In-Reply-To: <3b24ac73-f891-533f-8563-fe38ba4a83ca@xs4all.nl>
References: <20190214083731.16230-1-paul.kocialkowski@bootlin.com>
         <3b24ac73-f891-533f-8563-fe38ba4a83ca@xs4all.nl>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Thu, 2019-02-14 at 09:59 +0100, Hans Verkuil wrote:
> On 2/14/19 9:37 AM, Paul Kocialkowski wrote:
> > Check that our queues are not busy before setting the format or return
> > EBUSY if that's the case. This ensures that our format can't change
> > once buffers are allocated for the queue.
> > 
> > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > ---
> >  drivers/staging/media/sunxi/cedrus/cedrus_video.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> > index b5cc79389d67..3420a938a613 100644
> > --- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> > +++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> > @@ -282,8 +282,15 @@ static int cedrus_s_fmt_vid_cap(struct file *file, void *priv,
> >  {
> >  	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
> >  	struct cedrus_dev *dev = ctx->dev;
> > +	struct vb2_queue *vq;
> >  	int ret;
> >  
> > +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> > +	if (!vq)
> > +		return -EINVAL;
> 
> Can this ever happen?

I guess not, or something would be very wrong.
I have seen this check around when looking at how other drivers
implement this, but it does seem overkill.

Should I get rid of it in v2?

Cheers,

Paul

> Regards,
> 
> 	Hans
> 
> > +	else if (vb2_is_busy(vq))
> > +		return -EBUSY;
> > +
> >  	ret = cedrus_try_fmt_vid_cap(file, priv, f);
> >  	if (ret)
> >  		return ret;
> > @@ -299,8 +306,15 @@ static int cedrus_s_fmt_vid_out(struct file *file, void *priv,
> >  				struct v4l2_format *f)
> >  {
> >  	struct cedrus_ctx *ctx = cedrus_file2ctx(file);
> > +	struct vb2_queue *vq;
> >  	int ret;
> >  
> > +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> > +	if (!vq)
> > +		return -EINVAL;
> > +	else if (vb2_is_busy(vq))
> > +		return -EBUSY;
> > +
> >  	ret = cedrus_try_fmt_vid_out(file, priv, f);
> >  	if (ret)
> >  		return ret;
> > 
-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

