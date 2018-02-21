Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39042 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751408AbeBUACF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Feb 2018 19:02:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCHv2] media: add tuner standby op, use where needed
Date: Wed, 21 Feb 2018 02:02:46 +0200
Message-ID: <1537413.80bhSTNWuA@avalon>
In-Reply-To: <06ad8080-255f-b770-40b7-e6bc98b6ce60@cisco.com>
References: <06ad8080-255f-b770-40b7-e6bc98b6ce60@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday, 20 February 2018 11:44:20 EET Hans Verkuil wrote:
> The v4l2_subdev core s_power op was used for two different things: power
> on/off sensors or video decoders/encoders and to put a tuner in standby
> (and only the tuner!). There is no 'tuner wakeup' op, that's done
> automatically when the tuner is accessed.
> 
> The danger with calling (s_power, 0) to put a tuner into standby is that it
> is usually broadcast for all subdevs. So a video receiver subdev that
> supports s_power will also be powered off, and since there is no
> corresponding (s_power, 1) they will never be powered on again.
> 
> In addition, this is specifically meant for tuners only since they draw the
> most current.
> 
> This patch adds a new tuner op called 'standby' and replaces all calls to
> (core, s_power, 0) by (tuner, standby). This prevents confusion between the
> two uses of s_power. Note that there is no overlap: bridge drivers either
> just want to put the tuner into standby, or they deal with powering on/off
> sensors. Never both.
> 
> This also makes it easier to replace s_power for the remaining bridge
> drivers with some PM code later.
> 
> Whether we want something cleaner for tuners in the future is a separate
> topic. There is a lot of legacy code surrounding tuners, and I am very
> hesitant about making changes there.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> Changes since v1:
> - move the standby op to the tuner_ops, which makes much more sense.
> ---

[snip]

> diff --git a/drivers/media/v4l2-core/tuner-core.c
> b/drivers/media/v4l2-core/tuner-core.c index 82852f23a3b6..cb126baf8771
> 100644
> --- a/drivers/media/v4l2-core/tuner-core.c
> +++ b/drivers/media/v4l2-core/tuner-core.c
> @@ -1099,23 +1099,15 @@ static int tuner_s_radio(struct v4l2_subdev *sd)
>   */
> 
>  /**
> - * tuner_s_power - controls the power state of the tuner
> + * tuner_standby - controls the power state of the tuner

I'd update the description too.

>   * @sd: pointer to struct v4l2_subdev
>   * @on: a zero value puts the tuner to sleep, non-zero wakes it up

And this parameter doesn't exist anymore. You could have caught that by 
compiling the documentation.

>   */
> -static int tuner_s_power(struct v4l2_subdev *sd, int on)
> +static int tuner_standby(struct v4l2_subdev *sd)
>  {
>  	struct tuner *t = to_tuner(sd);
>  	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
> 
> -	if (on) {
> -		if (t->standby && set_mode(t, t->mode) == 0) {
> -			dprintk("Waking up tuner\n");
> -			set_freq(t, 0);
> -		}
> -		return 0;
> -	}
> -

Interesting how this code was not used. I've had a look at tuner-core driver 
out of curiosity, it clearly shows its age :/ I2C address probing belongs to 
another century.

>  	dprintk("Putting tuner to sleep\n");
>  	t->standby = true;
>  	if (analog_ops->standby)
> @@ -1328,10 +1320,10 @@ static int tuner_command(struct i2c_client *client,
> unsigned cmd, void *arg)
> 
>  static const struct v4l2_subdev_core_ops tuner_core_ops = {
>  	.log_status = tuner_log_status,
> -	.s_power = tuner_s_power,
>  };
> 
>  static const struct v4l2_subdev_tuner_ops tuner_tuner_ops = {
> +	.standby = tuner_standby,
>  	.s_radio = tuner_s_radio,
>  	.g_tuner = tuner_g_tuner,
>  	.s_tuner = tuner_s_tuner,
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 980a86c08fce..62429cd89620 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -224,6 +224,9 @@ struct v4l2_subdev_core_ops {
>   * struct v4l2_subdev_tuner_ops - Callbacks used when v4l device was opened
>   *	in radio mode.
>   *
> + * @standby: puts the tuner in standby mode. It will be woken up
> + *	     automatically the next time it is used.
> + *

I wouldn't have dared making such a statement as I don't trust myself as being 
able to give such a guarantee after reading the code :-)

>   * @s_radio: callback that switches the tuner to radio mode.
>   *	     drivers should explicitly call it when a tuner ops should
>   *	     operate on radio mode, before being able to handle it.
> @@ -268,6 +271,7 @@ struct v4l2_subdev_core_ops {
>   *	  }
>   */
>  struct v4l2_subdev_tuner_ops {
> +	int (*standby)(struct v4l2_subdev *sd);
>  	int (*s_radio)(struct v4l2_subdev *sd);
>  	int (*s_frequency)(struct v4l2_subdev *sd, const struct v4l2_frequency
> *freq);
> 	int (*g_frequency)(struct v4l2_subdev *sd, struct v4l2_frequency *freq);

-- 
Regards,

Laurent Pinchart
