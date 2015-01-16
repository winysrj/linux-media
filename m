Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:40190 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424AbbAPJgB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 04:36:01 -0500
Message-ID: <54B8DB6E.6090804@xs4all.nl>
Date: Fri, 16 Jan 2015 10:35:42 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] bttv: Improve TEA575x support
References: <1421352647-10383-1-git-send-email-linux@rainbow-software.org> <1421352647-10383-3-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1421352647-10383-3-git-send-email-linux@rainbow-software.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ondrej,

Just two small comments:

On 01/15/2015 09:10 PM, Ondrej Zary wrote:
> Improve g_tuner and add s_hw_freq_seek and enum_freq_bands support for cards
> with TEA575x radio.
> 
> This allows signal/stereo detection and HW seek to work on these cards.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  drivers/media/pci/bt8xx/bttv-driver.c |   31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index e7f8ade..5476a7d 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -2515,6 +2515,8 @@ static int bttv_querycap(struct file *file, void  *priv,
>  		if (btv->has_saa6588)
>  			cap->device_caps |= V4L2_CAP_READWRITE |
>  						V4L2_CAP_RDS_CAPTURE;
> +		if (btv->has_tea575x)
> +			cap->device_caps |= V4L2_CAP_HW_FREQ_SEEK;
>  	}
>  	return 0;
>  }
> @@ -3244,6 +3246,9 @@ static int radio_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
>  	if (btv->audio_mode_gpio)
>  		btv->audio_mode_gpio(btv, t, 0);
>  
> +	if (btv->has_tea575x)
> +		return snd_tea575x_g_tuner(&btv->tea, t);
> +
>  	return 0;
>  }
>  
> @@ -3261,6 +3266,30 @@ static int radio_s_tuner(struct file *file, void *priv,
>  	return 0;
>  }
>  
> +static int radio_s_hw_freq_seek(struct file *file, void *priv,
> +					const struct v4l2_hw_freq_seek *a)
> +{
> +	struct bttv_fh *fh = priv;
> +	struct bttv *btv = fh->btv;
> +
> +	if (btv->has_tea575x)
> +		return snd_tea575x_s_hw_freq_seek(file, &btv->tea, a);
> +	else
> +		return -ENOTTY;

Please drop the superfluous 'else'. I thought checkpatch warned about this these days.

> +}
> +
> +static int radio_enum_freq_bands(struct file *file, void *priv,
> +					 struct v4l2_frequency_band *band)
> +{
> +	struct bttv_fh *fh = priv;
> +	struct bttv *btv = fh->btv;
> +
> +	if (btv->has_tea575x)
> +		return snd_tea575x_enum_freq_bands(&btv->tea, band);
> +	else
> +		return -ENOTTY;

Ditto.

> +}
> +
>  static ssize_t radio_read(struct file *file, char __user *data,
>  			 size_t count, loff_t *ppos)
>  {
> @@ -3318,6 +3347,8 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
>  	.vidioc_s_tuner         = radio_s_tuner,
>  	.vidioc_g_frequency     = bttv_g_frequency,
>  	.vidioc_s_frequency     = bttv_s_frequency,
> +	.vidioc_s_hw_freq_seek	= radio_s_hw_freq_seek,
> +	.vidioc_enum_freq_bands	= radio_enum_freq_bands,
>  	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
>  	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>  };
> 

Regards,

	Hans
