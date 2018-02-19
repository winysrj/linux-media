Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49022 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753443AbeBST1N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 14:27:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [RFC PATCH] Add core tuner_standby op, use where needed
Date: Mon, 19 Feb 2018 21:27:51 +0200
Message-ID: <2482708.3kx7sGYsxZ@avalon>
In-Reply-To: <b94bf7a2-27b3-94f5-5eb9-88462c92ca38@xs4all.nl>
References: <b94bf7a2-27b3-94f5-5eb9-88462c92ca38@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Monday, 19 February 2018 15:12:05 EET Hans Verkuil wrote:
> The v4l2_subdev core s_power op was used to two different things: power
> on/off sensors or video decoders/encoders and to put a tuner in standby
> (and only the tuner). There is no 'tuner wakeup' op, that's done
> automatically when the tuner is accessed.
> 
> The danger with calling (s_power, 0) to put a tuner into standby is that it
> is usually broadcast for all subdevs. So a video receiver subdev that also
> supports s_power will also be powered off, and since there is no
> corresponding (s_power, 1) they will never be powered on again.
> 
> In addition, this is specifically meant for tuners only since they draw the
> most current.
> 
> This patch adds a new core op called 'tuner_standby' and replaces all calls
> to (s_power, 0) by tuner_standby. This prevents confusion between the two
> uses of s_power. Note that there is no overlap: bridge drivers either just
> want to put the tuner into standby, or they deal with powering on/off
> sensors. Never both.
> 
> This also makes it easier to replace s_power for the remaining bridge
> drivers with some PM code later.
> 
> Whether we want something similar for tuners in the future is a separate
> topic. There is a lot of legacy code surrounding tuners, and I am very
> hesitant about making changes there.

While I don't request you to make changes, someone should. I assume the tuners 
are still maintained, aren't they ? :-)

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---

[snip]
 
>  static const struct v4l2_subdev_tuner_ops tuner_tuner_ops = {
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 980a86c08fce..b214da92a5c0 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -184,6 +184,9 @@ struct v4l2_subdev_io_pin_config {
>   * @s_power: puts subdevice in power saving mode (on == 0) or normal
> operation *	mode (on == 1).
>   *
> + * @tuner_standby: puts the tuner in standby mode. It will be woken up
> + *	automatically the next time it is used.
> + *
>   * @interrupt_service_routine: Called by the bridge chip's interrupt
> service
>   *	handler, when an interrupt status has be raised due to this subdev,
>   *	so that this subdev can handle the details.  It may schedule work to be
> @@ -212,6 +215,7 @@ struct v4l2_subdev_core_ops {
>  	int (*s_register)(struct v4l2_subdev *sd, const struct v4l2_dbg_register
> *reg); #endif
>  	int (*s_power)(struct v4l2_subdev *sd, int on);
> +	int (*tuner_standby)(struct v4l2_subdev *sd);

If it's a tuner operation, how about moving it to v4l2_subdev_tuner_ops ? That 
would at least make it clear that it shouldn't be used by other drivers (and I 
think we should also mention in the documentation that this is a legacy 
operation that shouldn't be used for any new purpose).

>  	int (*interrupt_service_routine)(struct v4l2_subdev *sd,
>  						u32 status, bool *handled);
>  	int (*subscribe_event)(struct v4l2_subdev *sd, struct v4l2_fh *fh,

I'd prefer the bridge drivers to be fixed to use s_power in a balanced way, 
but I understand that it might be difficult to achieve in a timely fashion. 
I'm thus not against this patch, but I don't think it makes too much sense to 
merge it without a user, that is a patch series that works on removing 
s_power.

-- 
Regards,

Laurent Pinchart
