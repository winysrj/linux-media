Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39592 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750835AbbDXL4v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 07:56:51 -0400
Date: Fri, 24 Apr 2015 14:56:14 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski81@gmail.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, s.nawrocki@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v5 06/10] media: Add registration helpers for V4L2 flash
 sub-devices
Message-ID: <20150424115614.GA27451@valkosipuli.retiisi.org.uk>
References: <1429080520-10687-1-git-send-email-j.anaszewski@samsung.com>
 <1429080520-10687-7-git-send-email-j.anaszewski@samsung.com>
 <20150423074008.GY27451@valkosipuli.retiisi.org.uk>
 <20150423171026.099b9ea1@ja.home>
 <5539698C.5030707@iki.fi>
 <20150424122917.697a0a6f@ja.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150424122917.697a0a6f@ja.home>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Fri, Apr 24, 2015 at 12:29:17PM +0200, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> On Fri, 24 Apr 2015 00:52:12 +0300
> Sakari Ailus <sakari.ailus@iki.fi> wrote:
> 
> > Hi Jacek,
> > 
> > Jacek Anaszewski wrote:
> > ...
> > >>> +#define call_flash_op(v4l2_flash, op,
> > >>> arg)			\
> > >>> +		(has_flash_op(v4l2_flash,
> > >>> op) ?			\
> > >>> +			v4l2_flash->ops->op(v4l2_flash,
> > >>> arg) :	\
> > >>> +			-EINVAL)
> > >>> +
> > >>> +static enum led_brightness __intensity_to_led_brightness(
> > >>> +					struct v4l2_ctrl *ctrl,
> > >>> +					s32 intensity)
> > >>
> > >> Fits on previous line.
> > >>
> > >>> +{
> > >>> +	s64 intensity64 = intensity - ctrl->minimum;
> > >>
> > >> intensity, ctrl->step and ctrl->minimum are 32-bit signed integers.
> > >> Do you need a 64-bit integer here?
> > > 
> > > step is u64.
> > 
> > Nevertheless integer controls will not have values outside the s32
> > range, using a step value that's outside the range makes no sense
> > either. I think you should use s32 instead.
> 
> I infer that local u32 variable should be assigned ctrl->step,
> and then used as a divisor.

You could cast explicitly as well. Either is fine for me.

> 
> > > 
> > >>
> > >>> +
> > >>> +	do_div(intensity64, ctrl->step);
> > >>> +
> > >>> +	/*
> > >>> +	 * Indicator LEDs, unlike torch LEDs, are turned on/off
> > >>> basing on
> > >>> +	 * the state of V4L2_CID_FLASH_INDICATOR_INTENSITY
> > >>> control only.
> > >>> +	 * Therefore it must be possible to set it to 0 level
> > >>> which in
> > >>> +	 * the LED subsystem reflects LED_OFF state.
> > >>> +	 */
> > >>> +	if (ctrl->id != V4L2_CID_FLASH_INDICATOR_INTENSITY)
> > >>> +		++intensity64;
> > >>
> > >> I think the condition could simply be ctrl->minimum instead, that
> > >> way I find it easier to understand what's happening here. I'd
> > >> expect the minimum for non-intensity controls always to be
> > >> non-zero, though, so the end result is the same. Up to you.
> > > 
> > > Minimum for indicator control must be 0 to make possible
> > > turning the indicator LED off only with this control.
> > 
> > Would torch be still on if the minimum torch current was 0 mA? I'd
> > say no.
> > 
> > Although in that case I'd expect the driver to use a different range,
> > and selecting the off mode would then turn it off, I still think
> > that's a better condition than relying on the control id.
> 
> I didn't catch your point previously. Probably you was thinking
> about somethig like this:
> 
> if (ctrl->minimum)
> 	++intensity;
> 
> If so, I agree.

Yes, that's what I meant.

> 
> > ...
> > 
> > >>> +static int v4l2_flash_g_volatile_ctrl(struct v4l2_ctrl *c)
> > >>> +{
> > >>> +	struct v4l2_flash *v4l2_flash =
> > >>> v4l2_ctrl_to_v4l2_flash(c);
> > >>> +	struct led_classdev_flash *fled_cdev =
> > >>> v4l2_flash->fled_cdev;
> > >>> +	bool is_strobing;
> > >>> +	int ret;
> > >>> +
> > >>> +	switch (c->id) {
> > >>> +	case V4L2_CID_FLASH_TORCH_INTENSITY:
> > >>> +	case V4L2_CID_FLASH_INDICATOR_INTENSITY:
> > >>> +		return
> > >>> v4l2_flash_update_led_brightness(v4l2_flash, c);
> > >>> +	case V4L2_CID_FLASH_INTENSITY:
> > >>> +		ret = led_update_flash_brightness(fled_cdev);
> > >>> +		if (ret < 0)
> > >>> +			return ret;
> > >>> +		/* no conversion is needed */
> > >>
> > >> Maybe a stupid question, but why is it not needed?
> > > 
> > > Because LED Flash class also uses microamperes.
> > 
> > Right, I had missed that. It'd be nice if that was said in the
> > comment, it might not be obvious to others either.
> 
> OK, I will add the comment.

Thanks!

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
