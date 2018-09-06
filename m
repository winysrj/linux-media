Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:41164 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728776AbeIFSGl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2018 14:06:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v2 4/5] media: ov5640: fix auto controls values when switching to manual mode
Date: Thu, 06 Sep 2018 16:31:09 +0300
Message-ID: <1747395.R2Yra0TKY1@avalon>
In-Reply-To: <1534155586-26974-5-git-send-email-hugues.fruchet@st.com>
References: <1534155586-26974-1-git-send-email-hugues.fruchet@st.com> <1534155586-26974-5-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

Thank you for the patch.

On Monday, 13 August 2018 13:19:45 EEST Hugues Fruchet wrote:
> When switching from auto to manual mode, V4L2 core is calling
> g_volatile_ctrl() in manual mode in order to get the manual initial value.
> Remove the manual mode check/return to not break this behaviour.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  drivers/media/i2c/ov5640.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 9fb17b5..c110a6a 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -2277,16 +2277,12 @@ static int ov5640_g_volatile_ctrl(struct v4l2_ctrl
> *ctrl)
> 
>  	switch (ctrl->id) {
>  	case V4L2_CID_AUTOGAIN:
> -		if (!ctrl->val)
> -			return 0;
>  		val = ov5640_get_gain(sensor);
>  		if (val < 0)
>  			return val;
>  		sensor->ctrls.gain->val = val;
>  		break;

What is this even supposed to do ? Only the V4L2_CID_GAIN and 
V4L2_CID_EXPOSURE have the volatile flag set. Why can't this code be replaced 
with

	case V4L2_CID_GAIN:
  		val = ov5640_get_gain(sensor);
  		if (val < 0)
  			return val;
  		ctrl->val = val;
		break;


>  	case V4L2_CID_EXPOSURE_AUTO:
> -		if (ctrl->val == V4L2_EXPOSURE_MANUAL)
> -			return 0;
>  		val = ov5640_get_exposure(sensor);
>  		if (val < 0)
>  			return val;

And same here.

-- 
Regards,

Laurent Pinchart
