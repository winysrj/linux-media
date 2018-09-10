Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:51956 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbeIJPjZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 11:39:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v2 4/5] media: ov5640: fix auto controls values when switching to manual mode
Date: Mon, 10 Sep 2018 13:46:05 +0300
Message-ID: <1637570.gloTqPpV0r@avalon>
In-Reply-To: <104d1a65-0504-62e9-f0b2-eafaaa7f18ee@st.com>
References: <1534155586-26974-1-git-send-email-hugues.fruchet@st.com> <1747395.R2Yra0TKY1@avalon> <104d1a65-0504-62e9-f0b2-eafaaa7f18ee@st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Monday, 10 September 2018 13:23:41 EEST Hugues FRUCHET wrote:
> On 09/06/2018 03:31 PM, Laurent Pinchart wrote:
> > On Monday, 13 August 2018 13:19:45 EEST Hugues Fruchet wrote:
> > 
> >> When switching from auto to manual mode, V4L2 core is calling
> >> g_volatile_ctrl() in manual mode in order to get the manual initial
> >> value. Remove the manual mode check/return to not break this behaviour.
> >>
> >> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> >> ---
> >>   drivers/media/i2c/ov5640.c | 4 ----
> >>   1 file changed, 4 deletions(-)
> >>
> >> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> >> index 9fb17b5..c110a6a 100644
> >> --- a/drivers/media/i2c/ov5640.c
> >> +++ b/drivers/media/i2c/ov5640.c
> >> @@ -2277,16 +2277,12 @@ static int ov5640_g_volatile_ctrl(struct
> >> v4l2_ctrl *ctrl)
> >>
> >>   	switch (ctrl->id) {
> >>   	case V4L2_CID_AUTOGAIN:
> >> -		if (!ctrl->val)
> >> -			return 0;
> >> 
> >>   		val = ov5640_get_gain(sensor);
> >>   		if (val < 0)
> >>   			return val;
> >>   		
> >>   		sensor->ctrls.gain->val = val;
> >>   		break;
> > 
> > What is this even supposed to do ? Only the V4L2_CID_GAIN and
> > V4L2_CID_EXPOSURE have the volatile flag set. Why can't this code be
> > replaced with
> 
> This is because V4L2_CID_AUTOGAIN & V4L2_CID_GAIN are declared as 
> auto-cluster:
>   static int ov5640_init_controls(struct ov5640_dev *sensor)
> 	/* Auto/manual gain */
> 	ctrls->auto_gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_AUTOGAIN,
> 					     0, 1, 1, 1);
> 	ctrls->gain = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_GAIN,
> 					0, 1023, 1, 0);
> [...]
> 	v4l2_ctrl_auto_cluster(2, &ctrls->auto_gain, 0, true);
> 
> By checking many other drivers that are using clustered auto controls, 
> they are all doing that way:
> 
> ctrls->auto_x = v4l2_ctrl_new_std(CID_X_AUTO..
> ctrls->x = v4l2_ctrl_new_std(CID_X..
> v4l2_ctrl_auto_cluster(2, &ctrls->auto, 0, true);
> 
> g_volatile_ctrl(ctrl)
>    switch (ctrl->id) {
>     case CID_X_AUTO:
>       ctrls->x->val = READ_REG()

Seems like cargo-cult to me. Why is this better than the construct below ?

> > 	case V4L2_CID_GAIN:
> >    		val = ov5640_get_gain(sensor);
> >    		if (val < 0)
> >    			return val;
> >    		ctrl->val = val;
> > 		break;
> > 
> >>   	case V4L2_CID_EXPOSURE_AUTO:
> >> -		if (ctrl->val == V4L2_EXPOSURE_MANUAL)
> >> -			return 0;
> >>   		val = ov5640_get_exposure(sensor);
> >>   		if (val < 0)
> >>   			return val;
> > 
> > And same here.

-- 
Regards,

Laurent Pinchart
