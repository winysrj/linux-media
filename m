Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51988 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752020AbcIORdz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 13:33:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        magnus.damm@gmail.com, william.towle@codethink.co.uk
Subject: Re: [PATCH v8 2/2] rcar-vin: implement EDID control ioctls
Date: Thu, 15 Sep 2016 20:34:38 +0300
Message-ID: <35114943.rtxvasOV6f@avalon>
In-Reply-To: <19a27c03-d93e-9e67-7165-0e43631b66ee@xs4all.nl>
References: <20160915132408.20776-1-ulrich.hecht+renesas@gmail.com> <2433006.7RBxv9f6xW@avalon> <19a27c03-d93e-9e67-7165-0e43631b66ee@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 15 Sep 2016 19:01:06 Hans Verkuil wrote:
> On 09/15/2016 06:47 PM, Laurent Pinchart wrote:
> > On Thursday 15 Sep 2016 15:24:08 Ulrich Hecht wrote:
> >> Adds G_EDID and S_EDID.
> >> 
> >> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> >> ---
> >> 
> >>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 42 +++++++++++++++++++++++
> >>  drivers/media/platform/rcar-vin/rcar-vin.h  |  1 +
> >>  2 files changed, 43 insertions(+)
> >> 
> >> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> >> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index 62ca7e3..f679182
> >> 100644
> >> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> >> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> >> @@ -557,6 +557,38 @@ static int rvin_dv_timings_cap(struct file *file,
> >> void *priv_fh, return ret;
> >>  }
> >> 
> >> +static int rvin_g_edid(struct file *file, void *fh, struct v4l2_edid
> >> *edid) +{
> >> +	struct rvin_dev *vin = video_drvdata(file);
> >> +	struct v4l2_subdev *sd = vin_to_source(vin);
> >> +	int input, ret;
> >> +
> >> +	input = edid->pad;
> >> +	edid->pad = vin->sink_pad_idx;
> >> +
> >> +	ret = v4l2_subdev_call(sd, pad, get_edid, edid);
> >> +
> >> +	edid->pad = input;
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static int rvin_s_edid(struct file *file, void *fh, struct v4l2_edid
> >> *edid) +{
> >> +	struct rvin_dev *vin = video_drvdata(file);
> >> +	struct v4l2_subdev *sd = vin_to_source(vin);
> >> +	int input, ret;
> >> +
> >> +	input = edid->pad;
> >> +	edid->pad = vin->sink_pad_idx;
> >> +
> >> +	ret = v4l2_subdev_call(sd, pad, set_edid, edid);
> >> +
> >> +	edid->pad = input;
> >> +
> >> +	return ret;
> >> +}
> >> +
> >>  static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
> >>  	.vidioc_querycap		= rvin_querycap,
> >>  	.vidioc_try_fmt_vid_cap		= rvin_try_fmt_vid_cap,
> >> @@ -579,6 +611,9 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
> >>  	.vidioc_s_dv_timings		= rvin_s_dv_timings,
> >>  	.vidioc_query_dv_timings	= rvin_query_dv_timings,
> >> 
> >> +	.vidioc_g_edid			= rvin_g_edid,
> >> +	.vidioc_s_edid			= rvin_s_edid,
> >> +
> >>  	.vidioc_querystd		= rvin_querystd,
> >>  	.vidioc_g_std			= rvin_g_std,
> >>  	.vidioc_s_std			= rvin_s_std,
> >> @@ -832,6 +867,13 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
> >>  	vin->src_pad_idx = pad_idx;
> >>  	fmt.pad = vin->src_pad_idx;
> >> 
> >> +	vin->sink_pad_idx = 0;
> >> +	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
> >> +		if (sd->entity.pads[pad_idx].flags == MEDIA_PAD_FL_SINK) {
> >> +			vin->sink_pad_idx = pad_idx;
> >> +			break;
> >> +		}
> >> +
> > 
> > What if the subdev has multiple sink pads ? Shouldn't the pad number be
> > instead computed in the get and set EDID handlers based on the input
> > number passed in the struct v4l2_edid::pad field ?
> 
> But there is only one input (VIDIOC_ENUM_INPUT), so this would not make
> sense.

Indeed, my bad. We'll address that when implementing input selection support 
then.

> What is wrong is that g/s_edid should check the pad and return -EINVAL if it
> is non-zero. Odd that I missed that in the earlier reviews...

-- 
Regards,

Laurent Pinchart

