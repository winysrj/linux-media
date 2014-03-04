Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17338 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133AbaCDN2O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Mar 2014 08:28:14 -0500
From: Kamil Debski <k.debski@samsung.com>
To: 'Archit Taneja' <archit@ti.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
References: <1393832008-22174-1-git-send-email-archit@ti.com>
 <1393922965-15967-1-git-send-email-archit@ti.com>
 <1393922965-15967-8-git-send-email-archit@ti.com> <53159F7D.8020707@xs4all.nl>
 <5315B822.7010005@ti.com>
In-reply-to: <5315B822.7010005@ti.com>
Subject: RE: [PATCH v2 7/7] v4l: ti-vpe: Add selection API in VPE driver
Date: Tue, 04 Mar 2014 14:28:10 +0100
Message-id: <17f101cf37ad$96e23230$c4a69690$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Archit,

> From: Archit Taneja [mailto:archit@ti.com]
> Sent: Tuesday, March 04, 2014 12:25 PM
> 
> Hi,
> 
> On Tuesday 04 March 2014 03:10 PM, Hans Verkuil wrote:
> > Hi Archit,
> >
> > On 03/04/14 09:49, Archit Taneja wrote:
> >> Add selection ioctl ops. For VPE, cropping makes sense only for the
> >> input to VPE(or V4L2_BUF_TYPE_VIDEO_OUTPUT/MPLANE buffers) and
> >> composing makes sense only for the output of VPE(or
> V4L2_BUF_TYPE_VIDEO_CAPTURE/MPLANE buffers).
> >>
> >> For the CAPTURE type, V4L2_SEL_TGT_COMPOSE results in VPE writing
> the
> >> output in a rectangle within the capture buffer. For the OUTPUT
> type,
> >> V4L2_SEL_TGT_CROP results in selecting a rectangle region within the
> source buffer.
> >>
> >> Setting the crop/compose rectangles should successfully result in
> >> re-configuration of registers which are affected when either source
> >> or destination dimensions change, set_srcdst_params() is called for
> this purpose.
> >>
> >> Signed-off-by: Archit Taneja <archit@ti.com>
> >> ---
> >>   drivers/media/platform/ti-vpe/vpe.c | 142
> ++++++++++++++++++++++++++++++++++++
> >>   1 file changed, 142 insertions(+)
> >>
> >> diff --git a/drivers/media/platform/ti-vpe/vpe.c
> >> b/drivers/media/platform/ti-vpe/vpe.c
> >> index 03a6846..b938590 100644
> >> --- a/drivers/media/platform/ti-vpe/vpe.c
> >> +++ b/drivers/media/platform/ti-vpe/vpe.c
> >> @@ -410,8 +410,10 @@ static struct vpe_q_data *get_q_data(struct
> vpe_ctx *ctx,
> >>   {
> >>   	switch (type) {
> >>   	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> >> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> >>   		return &ctx->q_data[Q_DATA_SRC];
> >>   	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> >> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> >
> > I noticed that the querycap implementation is wrong. It reports
> > V4L2_CAP_VIDEO_M2M instead of V4L2_CAP_VIDEO_M2M_MPLANE.
> >
> > This driver is using the multiplanar formats, so the M2M_MPLANE cap
> > should be set.
> >
> > This should be a separate patch.
> 
> Thanks for pointing this out, I'll make a patch for that.
> 
> >
> > BTW, did you test the driver with the v4l2-compliance tool? The
> latest
> > version
> > (http://git.linuxtv.org/v4l-utils.git) has m2m support.
> >
> 
> I haven't tested it with this yet.
> 
> > However, if you want to test streaming (the -s option), then you will
> > probably need to base your kernel on this tree:
> >
> >
> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/vb2
> > -part1
> 
> I can give it a try. It'll probably take a bit more time to try this
> out. I'll need to port some minor DRA7x stuff.
> 
> Kamil,
> 
> Do you think you have some more time for the m2m pull request?

Yes, I would like to send the final pull request at the beginning of
the coming week.

> >
> > That branch contains a pile of fixes for vb2 and without that
> > v4l2-compliance -s will fail a number of tests.
> >
> >>   		return &ctx->q_data[Q_DATA_DST];
> >>   	default:
> >>   		BUG();
> >> @@ -1585,6 +1587,143 @@ static int vpe_s_fmt(struct file *file, void
> *priv, struct v4l2_format *f)
> >>   	return set_srcdst_params(ctx);
> >>   }
> >>
> >> +static int __vpe_try_selection(struct vpe_ctx *ctx, struct
> >> +v4l2_selection *s) {
> >> +	struct vpe_q_data *q_data;
> >> +
> >> +	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
> >> +	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT))
> >> +		return -EINVAL;
> >> +
> >> +	q_data = get_q_data(ctx, s->type);
> >> +	if (!q_data)
> >> +		return -EINVAL;
> >> +
> >> +	switch (s->target) {
> >> +	case V4L2_SEL_TGT_COMPOSE:
> >> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> >> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> >> +		/*
> >> +		 * COMPOSE target is only valid for capture buffer type,
> for
> >> +		 * output buffer type, assign existing crop parameters to
> the
> >> +		 * selection rectangle
> >> +		 */
> >> +		if (s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> >> +			break;
> >> +		} else {
> >
> > No need for the 'else' keywork here.
> >
> >> +			s->r = q_data->c_rect;
> >> +			return 0;
> >> +		}
> >> +
> >> +	case V4L2_SEL_TGT_CROP:
> >> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> >> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> >> +		/*
> >> +		 * CROP target is only valid for output buffer type, for
> capture
> >> +		 * buffer type, assign existing compose parameters to the
> >> +		 * selection rectangle
> >> +		 */
> >> +		if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> >> +			break;
> >> +		} else {
> >
> > Ditto.
> 
> 
> Thanks. I'll fix these.
> 
> I had a minor question about the selection API:
> 
> Are the V4L2_SET_TGT_CROP/COMPOSE_DEFAULT and the corresponding
> 'BOUNDS'
> targets supposed to be used with VIDIOC_S_SELECTION? If so, what's the
> expect behaviour?
> 
> Thanks,
> Archit

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

