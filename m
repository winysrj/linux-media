Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1592 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab3AWHfi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 02:35:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [PATCH] tuner-core: return tuner name with ioctl VIDIOC_G_TUNER
Date: Wed, 23 Jan 2013 08:35:29 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
References: <1358883981-2645-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1358883981-2645-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301230835.29623.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue January 22 2013 20:46:21 Frank Schäfer wrote:
> tuner_g_tuner() is supposed to fill struct v4l2_tuner passed by ioctl
> VIDIOC_G_TUNER, but misses setting the name field.
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> Cc: stable@kernel.org
> ---
>  drivers/media/v4l2-core/tuner-core.c |    1 +
>  1 Datei geändert, 1 Zeile hinzugefügt(+)
> 
> diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
> index b5a819a..95a47cf 100644
> --- a/drivers/media/v4l2-core/tuner-core.c
> +++ b/drivers/media/v4l2-core/tuner-core.c
> @@ -1187,6 +1187,7 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
>  
>  	if (check_mode(t, vt->type) == -EINVAL)
>  		return 0;
> +	strcpy(vt->name, t->name);
>  	if (vt->type == t->mode && analog_ops->get_afc)
>  		vt->afc = analog_ops->get_afc(&t->fe);
>  	if (analog_ops->has_signal)
> 

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

And the reason is that the tuner field should be filled in by the bridge
driver. That's because you may have multiple tuners and it's only the
bridge driver that will know which tuner is which and what name to give
it.

Regards,

	Hans
