Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:33694 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbcIGKF3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 06:05:29 -0400
Received: by mail-lf0-f46.google.com with SMTP id h127so7142391lfh.0
        for <linux-media@vger.kernel.org>; Wed, 07 Sep 2016 03:05:28 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Wed, 7 Sep 2016 12:05:26 +0200
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        corbet@lwn.net, mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com
Subject: Re: [PATCHv2 2/2] v4l: vsp1: Add HGT support
Message-ID: <20160907100525.GL27014@bigcity.dyn.berto.se>
References: <20160906143856.27564-1-niklas.soderlund+renesas@ragnatech.se>
 <20160906143856.27564-3-niklas.soderlund+renesas@ragnatech.se>
 <11815359.8Rr4pPQQOL@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <11815359.8Rr4pPQQOL@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your review.

On 2016-09-06 22:59:22 +0300, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Tuesday 06 Sep 2016 16:38:56 Niklas Söderlund wrote:
> > The HGT is a Histogram Generator Two-Dimensions. It computes a weighted
> > frequency histograms for hue and saturation areas over a configurable
> > region of the image with optional subsampling.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/vsp1/Makefile      |   2 +-
> >  drivers/media/platform/vsp1/vsp1.h        |   3 +
> >  drivers/media/platform/vsp1/vsp1_drv.c    |  33 ++++-
> >  drivers/media/platform/vsp1/vsp1_entity.c |  33 +++--
> >  drivers/media/platform/vsp1/vsp1_entity.h |   1 +
> >  drivers/media/platform/vsp1/vsp1_hgt.c    | 217 +++++++++++++++++++++++++++
> >  drivers/media/platform/vsp1/vsp1_hgt.h    |  42 ++++++
> >  drivers/media/platform/vsp1/vsp1_pipe.c   |  16 +++
> >  drivers/media/platform/vsp1/vsp1_pipe.h   |   2 +
> >  drivers/media/platform/vsp1/vsp1_regs.h   |   9 ++
> >  drivers/media/platform/vsp1/vsp1_video.c  |  10 +-
> >  11 files changed, 352 insertions(+), 16 deletions(-)
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.c
> >  create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.h
> 
> [snip]
> 
> > diff --git a/drivers/media/platform/vsp1/vsp1_hgt.c
> > b/drivers/media/platform/vsp1/vsp1_hgt.c new file mode 100644
> > index 0000000..4e3f762
> > --- /dev/null
> > +++ b/drivers/media/platform/vsp1/vsp1_hgt.c
> 
> [snip]
> 
> > +/* ------------------------------------------------------------------------
> > + * Controls
> > + */
> > +
> > +#define V4L2_CID_VSP1_HGT_HUE_AREAS	(V4L2_CID_USER_BASE | 0x1001)
> > +
> > +static int hgt_hue_areas_s_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +	struct vsp1_hgt *hgt = container_of(ctrl->handler, struct vsp1_hgt,
> > +					    ctrls);
> > +	u8 *value = ctrl->p_new.p_u8;
> 
> Nitpicking, I'd call the variable values.
> 
> > +	unsigned int i;
> > +	bool ok = true;
> > +
> > +	/*
> > +	 * Make sure values meet one of two possible hardware constrains
> 
> s/constrains/constraints./
> 
> > +	 * 0L <= 0U <= 1L <= 1U <= 2L <= 2U <= 3L <= 3U <= 4L <= 4U <= 5L <= 
> 5U
> > +	 * 0U <= 1L <= 1U <= 2L <= 2U <= 3L <= 3U <= 4L <= 4U <= 5L <= 5U <= 
> 0L
> > +	 */
> > +
> > +	if ((value[0] > value[1]) && (value[11] > value[0]))
> > +		ok = false;
> > +	for (i = 1; i < (HGT_NUM_HUE_AREAS * 2) - 1; ++i)
> > +		if (value[i] > value[i+1])
> > +			ok = false;
> > +
> > +	/* Values do not match hardware, adjust to valid settings. */
> > +	if (!ok) {
> > +		for (i = 0; i < (HGT_NUM_HUE_AREAS * 2) - 1; ++i) {
> > +			if (value[i] > value[i+1])
> > +				value[i] = value[i+1];
> > +		}
> > +	}
> 
> I'm afraid this won't work. Let's assume value[0] = 100, value[1] = 50, 
> value[2] = 25. The loop will unroll to
> 
> 	if (value[0] /* 100 */ > value[1] /* 50 */)
> 		value[0] = value[1] /* 50 */;
> 	if (value[1] /* 50 */ > value[2] /* 25 */)
> 		value[1] = value[2] /* 25 */;
> 
> You will end up with value[0] = 50, value[1] = 25, value[2] = 25, which 
> doesn't match the hardware constraints.
> 
> How about the following, which tests and fixes the values in a single 
> operation ?
> 
> static int hgt_hue_areas_s_ctrl(struct v4l2_ctrl *ctrl)
> {
> 	struct vsp1_hgt *hgt = container_of(ctrl->handler, struct vsp1_hgt,
> 					    ctrls);
> 	u8 *values = ctrl->p_new.p_u8;
> 	unsigned int i;
>         
> 	/*
> 	 * Adjust the values if they don't meet the hardware constraints:
> 	 *
> 	 * 0U <= 1L <= 1U <= 2L <= 2U <= 3L <= 3U <= 4L <= 4U <= 5L <= 5U
> 	 */ 
> 	for (i = 1; i < (HGT_NUM_HUE_AREAS * 2) - 1; ++i) {
> 		if (values[i] > values[i+1])
> 			values[i+1] = values[i];
> 	}
>         
> 	/* 0L <= 0U or 5U <= 0L */
> 	if (values[0] > values[1] && values[11] > values[0])
> 		values[0] = values[1];
>         
> 	memcpy(hgt->hue_areas, ctrl->p_new.p_u8, sizeof(hgt->hue_areas));
> 
> 	return 0;
> }
> 
> I'm also beginning to wonder whether it wouldn't make sense to return -EINVAL 
> when the values don't match the constraints instead of trying to fix them.

I'm fine with either solution. I looked at a few other drivers and it 
seems the most common way is to correct the control value. But maybe in 
this case it's better to just return -EINVAL.

Let me know what you think and I will make it so and send a v3.

> 
> > +	memcpy(hgt->hue_areas, ctrl->p_new.p_u8, sizeof(hgt->hue_areas));
> > +
> > +	return 0;
> > +}
> 
> [snip]
> 

-- 
Regards,
Niklas Söderlund
