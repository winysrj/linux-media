Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34028 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab2GIITV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2012 04:19:21 -0400
Subject: Re: [PATCH 2/3] media: coda: Add driver for Coda video codec.
From: Philipp Zabel <p.zabel@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	shawn.guo@linaro.org, fabio.estevam@freescale.com,
	richard.zhu@linaro.org, arnaud.patard@rtp-net.org,
	kernel@pengutronix.de, mchehab@infradead.org
In-Reply-To: <CACKLOr10RzcTQMJHrtd2K+imvhOcrvq3-vNFwqnKkyr1NSVqEQ@mail.gmail.com>
References: <1341579471-25208-1-git-send-email-javier.martin@vista-silicon.com>
	 <1341579471-25208-3-git-send-email-javier.martin@vista-silicon.com>
	 <1341816350.2489.1.camel@pizza.hi.pengutronix.de>
	 <CACKLOr10RzcTQMJHrtd2K+imvhOcrvq3-vNFwqnKkyr1NSVqEQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Jul 2012 10:19:04 +0200
Message-ID: <1341821944.2489.16.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 09.07.2012, 10:07 +0200 schrieb javier Martin:
[...]
> >> +static int vidioc_s_parm(struct file *file, void *priv, struct v4l2_streamparm *a)
> >> +{
> >> +     struct coda_ctx *ctx = fh_to_ctx(priv);
> >> +
> >> +     if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> >> +             if (a->parm.output.timeperframe.numerator != 1) {
> >> +                     v4l2_err(&ctx->dev->v4l2_dev,
> >> +                              "FPS numerator must be 1\n");
> >> +                     return -EINVAL;
> >> +             }
> >> +             ctx->params.framerate =
> >> +                                     a->parm.output.timeperframe.denominator;
> >> +     } else {
> >> +             v4l2_err(&ctx->dev->v4l2_dev,
> >> +                      "Setting FPS is only possible for the output queue\n");
> >> +             return -EINVAL;
> >
> > Why disallow setting timeperframe on the capture side? Shouldn't it
> > rather succeed without setting anything and return the current context's
> > frame rate instead?
> >
> >> +     }
> >> +     return 0;
> >> +}
> >> +
> >> +static int vidioc_g_parm(struct file *file, void *priv, struct v4l2_streamparm *a)
> >> +{
> >> +     struct coda_ctx *ctx = fh_to_ctx(priv);
> >> +
> >> +     if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> >> +             a->parm.output.timeperframe.denominator =
> >> +                                     ctx->params.framerate;
> >> +             a->parm.output.timeperframe.numerator = 1;
> >> +     } else {
> >> +             v4l2_err(&ctx->dev->v4l2_dev,
> >> +                      "Getting FPS is only possible for the output queue\n");
> >
> > The nominal capture side timeperframe should match that of the output
> > side.
> >
> > Actually, I'm not sure if this needs to be implemented at all, since
> > V4L2_CAP_TIMEPERFRAME is not set and capture frame dropping / output
> > frame duplication is not supported.
> 
> I am just following the steps of Samsung here:
> 
> http://lxr.linux.no/#linux+v3.4.4/drivers/media/video/s5p-mfc/s5p_mfc_enc.c#L1439
> http://lxr.linux.no/#linux+v3.4.4/drivers/media/video/s5p-mfc/s5p_mfc_opr.c#L775
> 

I don't think this is completely correct either. According to the V4L2
spec, setting timeperframe from an application is meant to make the
driver skip or duplicate frames to save bandwidth:

http://v4l2spec.bytesex.org/spec-single/v4l2.html#VIDIOC-G-PARM

So returning -EINVAL is not necessarily incorrect, as we can choose not
to support this ioctl - but claiming support for the output side (and
then doing nothing) but returning an error on the capture side seems a
bit inconsistent to me.

regards
Philipp

