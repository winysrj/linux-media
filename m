Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4952 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab3CNHLI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Mar 2013 03:11:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH RFC v3 2/6] v4l2-ctrl: Add helper function for control range update
Date: Thu, 14 Mar 2013 08:10:57 +0100
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
References: <1358979721-17473-1-git-send-email-sylvester.nawrocki@gmail.com> <1358979721-17473-3-git-send-email-sylvester.nawrocki@gmail.com> <201303120756.25167.hverkuil@xs4all.nl>
In-Reply-To: <201303120756.25167.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303140810.57504.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue March 12 2013 07:56:25 Hans Verkuil wrote:
> Hi Sylwester,
> 
> On Wed January 23 2013 23:21:57 Sylwester Nawrocki wrote:
> > This patch adds a helper function that allows to modify range,
> > i.e. minimum, maximum, step and default value of a v4l2 control,
> > after the control has been created and initialized. This is helpful
> > in situations when range of a control depends on user configurable
> > parameters, e.g. camera sensor absolute exposure time depending on
> > an output image resolution and frame rate.
> > 
> > v4l2_ctrl_modify_range() function allows to modify range of an
> > INTEGER, BOOL, MENU, INTEGER_MENU and BITMASK type controls.
> > 
> > Based on a patch from Hans Verkuil http://patchwork.linuxtv.org/patch/8654.
> > 
> > Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> I've been playing around with this a bit, using this vivi patch:
> 
> diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> index c46d2e8..85bc314 100644
> --- a/drivers/media/platform/vivi.c
> +++ b/drivers/media/platform/vivi.c
> @@ -1093,6 +1093,15 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
>  		return 0;
>  
>  	dev->input = i;
> +	/*
> +	 * Modify the brightness range depending on the input.
> +	 * This makes it easy to use vivi to test if applications can
> +	 * handle control range modifications and is also how this is
> +	 * typically used in practice as different inputs may be hooked
> +	 * up to different receivers with different control ranges.
> +	 */
> +	v4l2_ctrl_modify_range(dev->brightness,
> +			128 * i, 255 + 128 * i, 1, 127 + 128 * i);
>  	precalculate_bars(dev);
>  	precalculate_line(dev);
>  	return 0;
> 
> And it made me wonder if it wouldn't be more sensible if modify_range would
> also update the current value to the new default value?

Actually, thinking about it some more, I believe that modify_range should
actually include the new control value as argument. That way the caller can
decide what to do: use the current value (which then might be clamped), use
the default_value or use a remembered previous value.

If you agree with this, then I'll make a patch for it. I just need to know
what the only user of this call (ov9650.c) should do. I suspect it should
use the default value as the new value, but I'm not certain.

Regards,

	Hans

> You get weird effects otherwise where the new value is clamped to either
> the minimum or maximum value if the current value falls outside the new
> range.
> 
> Regards,
> 
> 	Hans
> 
> PS: qv4l2 has been updated to support range update events.
> 
