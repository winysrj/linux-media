Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:27122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366Ab1FLOiA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 10:38:00 -0400
Message-ID: <4DF4CF43.9050907@redhat.com>
Date: Sun, 12 Jun 2011 11:37:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv4 PATCH 1/8] tuner-core: rename check_mode to supported_mode
References: <1307876389-30347-1-git-send-email-hverkuil@xs4all.nl> <980897e53f7cc2ec9bbbf58d9d451ee56a249309.1307875512.git.hans.verkuil@cisco.com>
In-Reply-To: <980897e53f7cc2ec9bbbf58d9d451ee56a249309.1307875512.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 12-06-2011 07:59, Hans Verkuil escreveu:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The check_mode function checks whether a mode is supported. So calling it
> supported_mode is more appropriate. In addition it returned either 0 or
> -EINVAL which suggests that the -EINVAL error should be passed on. However,
> that's not the case so change the return type to bool.

I prefer to keep returning -EINVAL. This is the proper thing to do, and
to return the result to the caller. A fixme should be added though, so,
after someone add a subdev call that would properly handle the -EINVAL
code for multiple tuners, the functions should return the error code
instead of 0.

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/tuner-core.c |   19 ++++++++-----------
>  1 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
> index 5748d04..083b9f1 100644
> --- a/drivers/media/video/tuner-core.c
> +++ b/drivers/media/video/tuner-core.c
> @@ -723,22 +723,19 @@ static int tuner_remove(struct i2c_client *client)
>   */
>  
>  /**
> - * check_mode - Verify if tuner supports the requested mode
> + * supported_mode - Verify if tuner supports the requested mode
>   * @t: a pointer to the module's internal struct_tuner
>   *
>   * This function checks if the tuner is capable of tuning analog TV,
>   * digital TV or radio, depending on what the caller wants. If the
> - * tuner can't support that mode, it returns -EINVAL. Otherwise, it
> - * returns 0.
> + * tuner can't support that mode, it returns false. Otherwise, it
> + * returns true.
>   * This function is needed for boards that have a separate tuner for
>   * radio (like devices with tea5767).
>   */
> -static inline int check_mode(struct tuner *t, enum v4l2_tuner_type mode)
> +static bool supported_mode(struct tuner *t, enum v4l2_tuner_type mode)
>  {
> -	if ((1 << mode & t->mode_mask) == 0)
> -		return -EINVAL;
> -
> -	return 0;
> +	return 1 << mode & t->mode_mask;
>  }
>  
>  /**
> @@ -759,7 +756,7 @@ static int set_mode_freq(struct i2c_client *client, struct tuner *t,
>  	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
>  
>  	if (mode != t->mode) {
> -		if (check_mode(t, mode) == -EINVAL) {
> +		if (!supported_mode(t, mode)) {
>  			tuner_dbg("Tuner doesn't support mode %d. "
>  				  "Putting tuner to sleep\n", mode);
>  			t->standby = true;
> @@ -1138,7 +1135,7 @@ static int tuner_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
>  	struct tuner *t = to_tuner(sd);
>  	struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
>  
> -	if (check_mode(t, f->type) == -EINVAL)
> +	if (!supported_mode(t, f->type))
>  		return 0;
>  	f->type = t->mode;
>  	if (fe_tuner_ops->get_frequency && !t->standby) {
> @@ -1161,7 +1158,7 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
>  	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
>  	struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
>  
> -	if (check_mode(t, vt->type) == -EINVAL)
> +	if (!supported_mode(t, vt->type))
>  		return 0;
>  	vt->type = t->mode;
>  	if (analog_ops->get_afc)

