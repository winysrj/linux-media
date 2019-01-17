Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6E58C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 13:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEFFA20855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 13:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfAQNdo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:33:44 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58989 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbfAQNdn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 08:33:43 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gk7nh-0001Jf-LV; Thu, 17 Jan 2019 14:33:41 +0100
Message-ID: <1547732020.4009.7.camel@pengutronix.de>
Subject: Re: [PATCH v6] media: imx: add mem2mem device
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
        Steve Longerbeam <slongerbeam@gmail.com>
Date:   Thu, 17 Jan 2019 14:33:40 +0100
In-Reply-To: <7b0dd313-5f38-5567-8f11-e07e8160de5d@xs4all.nl>
References: <20190108153816.13014-1-p.zabel@pengutronix.de>
         <7b0dd313-5f38-5567-8f11-e07e8160de5d@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, 2019-01-16 at 17:19 +0100, Hans Verkuil wrote:
> Hi Philipp,
> 
> A quick review (just a few small points):
> 
> On 1/8/19 4:38 PM, Philipp Zabel wrote:
[...]
> > +/*
> > + * Video ioctls
> > + */
> > +static int ipu_csc_scaler_querycap(struct file *file, void *priv,
> > +				   struct v4l2_capability *cap)
> > +{
> > +	strscpy(cap->driver, "imx-media-mem2mem", sizeof(cap->driver));
> > +	strscpy(cap->card, "imx-media-mem2mem", sizeof(cap->card));
> > +	strscpy(cap->bus_info, "platform:imx-media-mem2mem",
> 
> Please update the names to imx-media-csc-scaler.

Ok, will do.

> > +static int ipu_csc_scaler_g_selection(struct file *file, void *priv,
> > +				      struct v4l2_selection *s)
> > +{
> > +	struct ipu_csc_scaler_ctx *ctx = fh_to_ctx(priv);
> > +	struct ipu_csc_scaler_q_data *q_data;
> > +
> > +	switch (s->target) {
> > +	case V4L2_SEL_TGT_CROP:
> > +	case V4L2_SEL_TGT_CROP_DEFAULT:
> > +	case V4L2_SEL_TGT_CROP_BOUNDS:
> > +		if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> > +			return -EINVAL;
> > +		q_data = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> > +		break;
> > +	case V4L2_SEL_TGT_COMPOSE:
> > +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> > +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> > +	case V4L2_SEL_TGT_COMPOSE_PADDED:
> 
> I don't think you need to implement COMPOSE_PADDED, unless there
> is actual padding going on.

I'll remove the COMPOSE_PADDED target for now.

Support could be added to scale to non-burstsize-aligned width for some
orientations, but that would have rather complicated interactions with
the tiling and flip/rotation support.

[...]
> > +static int ipu_csc_scaler_init_controls(struct ipu_csc_scaler_ctx *ctx)
> > +{
> > +	struct v4l2_ctrl_handler *hdlr = &ctx->ctrl_hdlr;
> > +	int ret;
> > +
> > +	v4l2_ctrl_handler_init(hdlr, 3);
> > +
> > +	v4l2_ctrl_new_std(hdlr, &ipu_csc_scaler_ctrl_ops, V4L2_CID_HFLIP,
> > +			  0, 1, 1, 0);
> > +	v4l2_ctrl_new_std(hdlr, &ipu_csc_scaler_ctrl_ops, V4L2_CID_VFLIP,
> > +			  0, 1, 1, 0);
> > +	v4l2_ctrl_new_std(hdlr, &ipu_csc_scaler_ctrl_ops, V4L2_CID_ROTATE,
> > +			  0, 270, 90, 0);
> > +
> > +	if (hdlr->error) {
> > +		ret = hdlr->error;
> > +		goto out_free;
> > +	}
> > +
> > +	v4l2_ctrl_handler_setup(hdlr);
> > +	return 0;
> > +
> > +out_free:
> > +	v4l2_ctrl_handler_free(hdlr);
> > +	return ret;
> 
> You don't really need a goto here, just replace the 'goto' with these last two lines.

Ok.

thanks
Philipp
