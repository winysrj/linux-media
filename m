Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09A9C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 15:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A99D620663
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 15:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbfAHP7G (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 10:59:06 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:42515 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbfAHP7F (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 10:59:05 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1ggtmS-0003OL-Ef; Tue, 08 Jan 2019 16:59:04 +0100
Message-ID: <1546963144.5406.7.camel@pengutronix.de>
Subject: Re: [PATCH v5] media: imx: add mem2mem device
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Steve Longerbeam <slongerbeam@gmail.com>, kernel@pengutronix.de
Date:   Tue, 08 Jan 2019 16:59:04 +0100
In-Reply-To: <a8d3a554-aef8-b8e0-b8ad-f9116bcc3f39@xs4all.nl>
References: <20181203114804.17078-1-p.zabel@pengutronix.de>
         <a8d3a554-aef8-b8e0-b8ad-f9116bcc3f39@xs4all.nl>
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

Hi Hans,

thank you for your comments!

On Mon, 2018-12-03 at 16:21 +0100, Hans Verkuil wrote:
> On 12/03/2018 12:48 PM, Philipp Zabel wrote:
> > Add a single imx-media mem2mem video device that uses the IPU IC PP
> > (image converter post processing) task for scaling and colorspace
> > conversion.
> > On i.MX6Q/DL SoCs with two IPUs currently only the first IPU is used.
> > 
> > The hardware only supports writing to destination buffers up to
> > 1024x1024 pixels in a single pass, arbitrary sizes can be achieved
> > by rendering multiple tiles per frame.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > [slongerbeam@gmail.com: use ipu_image_convert_adjust(), fix
> >  device_run() error handling]
> > Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> > ---
> > Changes since v4:
> >  - No functional changes.
> >  - Dropped deprecated TODO comment. This driver has no interaction with
> >    the IC task v4l2 subdevices.
> >  - Dropped ipu-v3 patches, those are merged independently via imx-drm.
> 
> These land in kernel 4.21? Or are they already in 4.20?

These landed in v5.0-rc1.
I've sent a v6 that should already address most of the issues you
mentioned, except those I answer to below:

[...]
> > +static int mem2mem_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
> > +			       unsigned int *nplanes, unsigned int sizes[],
> > +			       struct device *alloc_devs[])
> > +{
> > +	struct mem2mem_ctx *ctx = vb2_get_drv_priv(vq);
> > +	struct mem2mem_q_data *q_data;
> > +	unsigned int count = *nbuffers;
> > +	struct v4l2_pix_format *pix;
> > +
> > +	q_data = get_q_data(ctx, vq->type);
> > +	pix = &q_data->cur_fmt;
> > +
> > +	*nplanes = 1;
> > +	*nbuffers = count;
> > +	sizes[0] = pix->sizeimage;
> 
> This needs to be modified slightly to support PREPARE_BUF.

Do you mean CREATE_BUFS? I have fixed queue_setup to do check the size
when called from CREATE_BUFS, but I don't understand what needs to be
changed for PREPARE_BUF.

[...]
> > +	ret = ipu_degrees_to_rot_mode(&rot_mode, rotate, hflip, vflip);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (rot_mode != ctx->rot_mode) {
> > +		struct vb2_queue *cap_q;
> > +
> > +		cap_q = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
> > +					V4L2_BUF_TYPE_VIDEO_CAPTURE);
> > +		if (vb2_is_streaming(cap_q))
> > +			return -EBUSY;
> > +
> > +		ctx->rot_mode = rot_mode;
> > +		ctx->rotate = rotate;
> > +		ctx->hflip = hflip;
> > +		ctx->vflip = vflip;
> 
> Changing the orientation should also change the format (swaps width and
> height), but I see no sign of that in the code.

A +/-90° orientation change (in addition to changing rot_mode) should
have the same effect as a S_FMT with swapped width/height?

I was unsure about what the "display window" meant in the
V4L2_CID_ROTATE description [1], but the wording sounded like the user
was expected to call S_FMT manually anyway:

  V4L2_CID_ROTATE (integer)
    Rotates the image by specified angle.
Common angles are 90, 270 and
    180. Rotating the image to 90 and 270
will reverse the height and
    width of the display window. It is
necessary to set the new height
    and width of the picture using the
VIDIOC_S_FMT ioctl according to
    the rotation angle selected.

[1] https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/control.html

> Rotating also changes the buffer size for YUV 4:2:0, so you probably should
> use vb2_is_busy() in the test above.
> 
> There is another issue involved. See this old patch (never got merged):
> 
> https://patchwork.linuxtv.org/patch/44424/
> 
> I think this was discussed as well on irc not too long ago, along there I
> suggested calling the ops queue_prepare and queue_finish.

Do you mean the V4L2_CID_ROTATE should be grabbed while the queue is
busy?

regards
Philipp
