Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4105 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab0JRKlQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 06:41:16 -0400
Message-ID: <77120174419e5626d8b795bc2722d071.squirrel@webmail.xs4all.nl>
In-Reply-To: <1287395654-1822-1-git-send-email-matti.j.aaltonen@nokia.com>
References: <1287395654-1822-1-git-send-email-matti.j.aaltonen@nokia.com>
Date: Mon, 18 Oct 2010 12:40:59 +0200
Subject: Re: [PATCH RFC 1/1] V4L2: Use new CAP bits in existing RDS capable
 drivers.
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	"Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>


> Add either V4L2_TUNER_CAP_RDS_BLOCK_IO or V4L2_TUNER_CAP_RDS_CONTROLS
> bit to tuner or modulator capabilities of existing drivers of devices with
> RDS capability.
>
> Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
> ---
>  drivers/media/radio/radio-cadet.c                |    3 ++-
>  drivers/media/radio/si470x/radio-si470x-common.c |    2 +-
>  drivers/media/radio/si4713-i2c.c                 |    2 +-
>  drivers/media/video/saa6588.c                    |    2 +-
>  4 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/radio/radio-cadet.c
> b/drivers/media/radio/radio-cadet.c
> index 482d0f3..b701ea6 100644
> --- a/drivers/media/radio/radio-cadet.c
> +++ b/drivers/media/radio/radio-cadet.c
> @@ -374,7 +374,8 @@ static int vidioc_g_tuner(struct file *file, void
> *priv,
>  	switch (v->index) {
>  	case 0:
>  		strlcpy(v->name, "FM", sizeof(v->name));
> -		v->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_RDS;
> +		v->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_RDS |
> +			V4L2_TUNER_CAP_RDS_BLOCK_IO;
>  		v->rangelow = 1400;     /* 87.5 MHz */
>  		v->rangehigh = 1728;    /* 108.0 MHz */
>  		v->rxsubchans = cadet_getstereo(dev);
> diff --git a/drivers/media/radio/si470x/radio-si470x-common.c
> b/drivers/media/radio/si470x/radio-si470x-common.c
> index 9927a59..af5ad45 100644
> --- a/drivers/media/radio/si470x/radio-si470x-common.c
> +++ b/drivers/media/radio/si470x/radio-si470x-common.c
> @@ -681,7 +681,7 @@ static int si470x_vidioc_g_tuner(struct file *file,
> void *priv,
>  	tuner->type = V4L2_TUNER_RADIO;
>  #if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
>  	tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
> -			    V4L2_TUNER_CAP_RDS;
> +			    V4L2_TUNER_CAP_RDS | V4L2_TUNER_CAP_RDS_BLOCK_IO;
>  #else
>  	tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
>  #endif
> diff --git a/drivers/media/radio/si4713-i2c.c
> b/drivers/media/radio/si4713-i2c.c
> index fc7f4b7..a6e6f19 100644
> --- a/drivers/media/radio/si4713-i2c.c
> +++ b/drivers/media/radio/si4713-i2c.c
> @@ -1804,7 +1804,7 @@ static int si4713_g_modulator(struct v4l2_subdev
> *sd, struct v4l2_modulator *vm)
>
>  	strncpy(vm->name, "FM Modulator", 32);
>  	vm->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_LOW |
> -						V4L2_TUNER_CAP_RDS;
> +		V4L2_TUNER_CAP_RDS | V4L2_TUNER_CAP_RDS_CONTROLS;
>
>  	/* Report current frequency range limits */
>  	vm->rangelow = si4713_to_v4l2(FREQ_RANGE_LOW);
> diff --git a/drivers/media/video/saa6588.c b/drivers/media/video/saa6588.c
> index c3e96f0..eac222b 100644
> --- a/drivers/media/video/saa6588.c
> +++ b/drivers/media/video/saa6588.c
> @@ -430,7 +430,7 @@ static int saa6588_g_tuner(struct v4l2_subdev *sd,
> struct v4l2_tuner *vt)
>  {
>  	struct saa6588 *s = to_saa6588(sd);
>
> -	vt->capability |= V4L2_TUNER_CAP_RDS;
> +	vt->capability |= V4L2_TUNER_CAP_RDS | V4L2_TUNER_CAP_RDS_BLOCK_IO;
>  	if (s->sync)
>  		vt->rxsubchans |= V4L2_TUNER_SUB_RDS;
>  	return 0;
> --
> 1.6.1.3
>
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

