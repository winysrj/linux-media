Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:45825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab1FLOjT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 10:39:19 -0400
Message-ID: <4DF4CF8F.8050507@redhat.com>
Date: Sun, 12 Jun 2011 11:39:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv4 PATCH 2/8] tuner-core: change return type of set_mode_freq
 to bool
References: <1307876389-30347-1-git-send-email-hverkuil@xs4all.nl> <d59fe38f04b4dbce9e79b10133db2f0953ced6e6.1307875512.git.hans.verkuil@cisco.com>
In-Reply-To: <d59fe38f04b4dbce9e79b10133db2f0953ced6e6.1307875512.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 12-06-2011 07:59, Hans Verkuil escreveu:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> set_mode_freq currently returns 0 or -EINVAL. But -EINVAL does not
> indicate a error that should be passed on, it just indicates that the
> tuner does not supportthe requested mode. So change the return type to
> bool.

NACK. Tuner core doesn't return the error code just because the subdev
functions don't allow, currently, at the multiple tuners case.

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/tuner-core.c |   23 ++++++++++-------------
>  1 files changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
> index 083b9f1..ee43e0a 100644
> --- a/drivers/media/video/tuner-core.c
> +++ b/drivers/media/video/tuner-core.c
> @@ -746,11 +746,11 @@ static bool supported_mode(struct tuner *t, enum v4l2_tuner_type mode)
>   * @freq:	frequency to set (0 means to use the previous one)
>   *
>   * If tuner doesn't support the needed mode (radio or TV), prints a
> - * debug message and returns -EINVAL, changing its state to standby.
> - * Otherwise, changes the state and sets frequency to the last value, if
> - * the tuner can sleep or if it supports both Radio and TV.
> + * debug message and returns false, changing its state to standby.
> + * Otherwise, changes the state and sets frequency to the last value
> + * and returns true.
>   */
> -static int set_mode_freq(struct i2c_client *client, struct tuner *t,
> +static bool set_mode_freq(struct i2c_client *client, struct tuner *t,
>  			 enum v4l2_tuner_type mode, unsigned int freq)
>  {
>  	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
> @@ -762,7 +762,7 @@ static int set_mode_freq(struct i2c_client *client, struct tuner *t,
>  			t->standby = true;
>  			if (analog_ops->standby)
>  				analog_ops->standby(&t->fe);
> -			return -EINVAL;
> +			return false;
>  		}
>  		t->mode = mode;
>  		tuner_dbg("Changing to mode %d\n", mode);
> @@ -777,7 +777,7 @@ static int set_mode_freq(struct i2c_client *client, struct tuner *t,
>  		set_tv_freq(client, t->tv_freq);
>  	}
>  
> -	return 0;
> +	return true;
>  }
>  
>  /*
> @@ -1075,8 +1075,7 @@ static int tuner_s_radio(struct v4l2_subdev *sd)
>  	struct tuner *t = to_tuner(sd);
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
> -	if (set_mode_freq(client, t, V4L2_TUNER_RADIO, 0) == -EINVAL)
> -		return 0;
> +	set_mode_freq(client, t, V4L2_TUNER_RADIO, 0);
>  	return 0;
>  }
>  
> @@ -1110,7 +1109,7 @@ static int tuner_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
>  	struct tuner *t = to_tuner(sd);
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
> -	if (set_mode_freq(client, t, V4L2_TUNER_ANALOG_TV, 0) == -EINVAL)
> +	if (!set_mode_freq(client, t, V4L2_TUNER_ANALOG_TV, 0))
>  		return 0;
>  
>  	t->std = std;
> @@ -1124,9 +1123,7 @@ static int tuner_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
>  	struct tuner *t = to_tuner(sd);
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
> -	if (set_mode_freq(client, t, f->type, f->frequency) == -EINVAL)
> -		return 0;
> -
> +	set_mode_freq(client, t, f->type, f->frequency);
>  	return 0;
>  }
>  
> @@ -1197,7 +1194,7 @@ static int tuner_s_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
>  	struct tuner *t = to_tuner(sd);
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
> -	if (set_mode_freq(client, t, vt->type, 0) == -EINVAL)
> +	if (!set_mode_freq(client, t, vt->type, 0))
>  		return 0;
>  
>  	if (t->mode == V4L2_TUNER_RADIO)

