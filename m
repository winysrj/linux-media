Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:1163 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbZKIMjz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 07:39:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: hvaibhav@ti.com
Subject: Re: [PATCH 6/6] TVP514x:Switch to automode for s_input/querystd
Date: Mon, 9 Nov 2009 13:39:52 +0100
Cc: linux-media@vger.kernel.org, Brijesh Jadav <brijesh.j@ti.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
References: <hvaibhav@ti.com> <1255446779-16969-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1255446779-16969-1-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911091339.52771.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vaibhav,

See the review comments below.

On Tuesday 13 October 2009 17:12:59 hvaibhav@ti.com wrote:
> From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> Driver should switch to AutoSwitch mode on S_INPUT and QUERYSTD ioctls.
> It has been observed that, if user configure the standard explicitely
> then driver preserves the old settings.
> 
> Reviewed by: Vaibhav Hiremath <hvaibhav@ti.com>
> Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> ---
>  drivers/media/video/tvp514x.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
> index 2443726..0b0412d 100644
> --- a/drivers/media/video/tvp514x.c
> +++ b/drivers/media/video/tvp514x.c
> @@ -523,10 +523,18 @@ static int tvp514x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std_id)
>  	enum tvp514x_std current_std;
>  	enum tvp514x_input input_sel;
>  	u8 sync_lock_status, lock_mask;
> +	int err;
> 
>  	if (std_id == NULL)
>  		return -EINVAL;
> 
> +	err = tvp514x_write_reg(sd, REG_VIDEO_STD,
> +			VIDEO_STD_AUTO_SWITCH_BIT);
> +	if (err < 0)
> +		return err;
> +
> +	msleep(LOCK_RETRY_DELAY);
> +

We have a problem here with the V4L2 spec.

The spec says that the standard should not change unless set explicitly by
the user. So switching to auto mode in querystd is not correct.

Is it possible to detect the standard without switching to automode? If it is,
then that's the preferred solution.

If it cannot be done, then we need to extend the API and add support for a
proper way of enabling automode.

This is actually a long standing issue that used to be pretty low prio since
it is very rare to see 'spontaneous' switches from e.g. PAL to NTSC.

But with the upcoming timings API for HDTV this will become much more common.
(e.g. switching from 1080p to 720p).

We need to define this quite carefully. In particular what will happen if the
standard switches while streaming. How does that relate to a scaler setup with
S_FMT? Do we know when this happens so that we can notify the application? Can
we lock the standard when starting capturing?

My gut feeling is that AUTO detect should only be allowed if the application
can be notified when the standard changes, or if the standard can be locked
when streaming starts.

The second part that is needed is some way to set the receiver into auto
switching mode. For SDTV that probably means adding a new AUTO standard bit.
Although to be honest I'm not keen on having to add something to v4l2_std_id.

For the HDTV timings API we probably need to add an AUTO preset.

Murali, can you think about this a bit and see how that will work out?

>  	/* get the current standard */
>  	current_std = tvp514x_get_current_std(sd);
>  	if (current_std == STD_INVALID)
> @@ -643,6 +651,15 @@ static int tvp514x_s_routing(struct v4l2_subdev *sd,
>  		/* Index out of bound */
>  		return -EINVAL;
> 
> +	/* Since this api is goint to detect the input, it is required
> +	   to set the standard in the auto switch mode */
> +	err = tvp514x_write_reg(sd, REG_VIDEO_STD,
> +			VIDEO_STD_AUTO_SWITCH_BIT);

Huh? I don't see what s_routing has to do with auto switch mode.

> +	if (err < 0)
> +		return err;
> +
> +	msleep(LOCK_RETRY_DELAY);
> +
>  	input_sel = input;
>  	output_sel = output;
> 
> --
> 1.6.2.4
> 

Regards,

	Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
