Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBH96bQ0006326
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 04:11:08 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBH92T28009717
	for <video4linux-list@redhat.com>; Wed, 17 Dec 2008 04:02:30 -0500
Date: Wed, 17 Dec 2008 10:02:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <ubpvbgqf1.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0812170941040.4610@axis700.grange>
References: <ubpvbgqf1.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH v5] Add tw9910 driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

What a pity, you were too fast:-( I tried to comment on your v4 to prevent 
an extra round, but you were faster:-( Let's hope v6 will be the last one! 
And the changes I'm proposing below are not too hard, so, should be an 
easy one.

On Wed, 17 Dec 2008, Kuninori Morimoto wrote:

> +static const struct tw9910_scale_ctrl*
> +tw9910_select_norm(v4l2_std_id norm, struct v4l2_rect *rect)
> +{
> +	const struct tw9910_scale_ctrl *scale;
> +	const struct tw9910_scale_ctrl *ret = NULL;
> +	int i;
> +
> +	if (norm & V4L2_STD_NTSC) {
> +		scale = tw9910_ntsc_scales;
> +		for (i = 0; i < ARRAY_SIZE(tw9910_ntsc_scales); i++) {
> +			if (scale[i].width  == rect->width ||
> +			    scale[i].height == rect->height) {
> +				ret = scale + i;
> +			}
> +
> +			if (scale[i].width  == rect->width &&
> +			    scale[i].height == rect->height) {
> +				return scale + i;
> +			}
> +		}
> +	} else if (norm & V4L2_STD_PAL) {
> +		scale = tw9910_pal_scales;
> +		for (i = 0; i < ARRAY_SIZE(tw9910_pal_scales); i++) {
> +			if (scale[i].width  == rect->width ||
> +			    scale[i].height == rect->height) {
> +				ret = scale + i;
> +			}
> +
> +			if (scale[i].width  == rect->width &&
> +			    scale[i].height == rect->height) {
> +				return scale + i;
> +			}
> +		}
> +	}
> +
> +	return ret;
> +}

Hm, sorry, I should have explained "select the nearest if no exact match
is found" better. Now you check whether at least one parameter matches
exactly, if not, you just fail. But if we allow one parameter to not match
and just overwrite it, maybe we could do better yet and allow both to not
match? Wouldn't it be better to select some metric in your width-height
space and find the nearest point to the requested one? You can either use
the classical (w - w_fixed)^2 + (h - h_fixed)^2 or a computationally
lighter abs(w - w_fixed) + abs(h - h_fixed).

This method also has an advantage over yours if one of parameters match 
exactly. Suppose, the user requested 600x480 NTSC. With your current 
implementation you'd end up selecting 720x480, whereas 640x480 is closer.

> +static int tw9910_start_capture(struct soc_camera_device *icd)
> +{
> +	struct tw9910_priv *priv = container_of(icd, struct tw9910_priv, icd);
> +
> +	if (!priv->scale) {
> +		dev_err(&icd->dev, "norm select error\n");
> +		return -EPERM;
> +	}
> +
> +	if (icd->width  != priv->scale->width ||
> +	    icd->height != priv->scale->height) {
> +		dev_err(&icd->dev, "norm scale error\n");
> +		return -EPERM;
> +	}
> +
> +	dev_info(&icd->dev, "%s %dx%d\n",
> +		 priv->scale->name,
> +		 priv->scale->width,
> +		 priv->scale->height);

dev_dbg, please.

> +static int tw9910_remove(struct i2c_client *client)
> +{
> +	struct tw9910_priv *priv = i2c_get_clientdata(client);
> +
> +	soc_camera_device_unregister(&priv->icd);

Here too:

+		i2c_set_clientdata(client, NULL);

> +	kfree(priv);
> +	return 0;
> +}

Fingers crossed for v6!

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
