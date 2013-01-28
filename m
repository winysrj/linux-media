Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2332 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab3A1KK7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 05:10:59 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 4/7] saa7134: v4l2-compliance: return real frequency
Date: Mon, 28 Jan 2013 11:10:45 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1359315912-1767-1-git-send-email-linux@rainbow-software.org> <1359315912-1767-5-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1359315912-1767-5-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301281110.45990.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun January 27 2013 20:45:09 Ondrej Zary wrote:
> Make saa7134 driver more V4L2 compliant: don't cache frequency in
> s_frequency/g_frequency but return real one instead
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>


> ---
>  drivers/media/pci/saa7134/saa7134-video.c |    6 ++++--
>  drivers/media/pci/saa7134/saa7134.h       |    1 -
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
> index be745c0..87b2b9e 100644
> --- a/drivers/media/pci/saa7134/saa7134-video.c
> +++ b/drivers/media/pci/saa7134/saa7134-video.c
> @@ -2048,8 +2048,11 @@ static int saa7134_g_frequency(struct file *file, void *priv,
>  	struct saa7134_fh *fh = priv;
>  	struct saa7134_dev *dev = fh->dev;
>  
> +	if (0 != f->tuner)
> +		return -EINVAL;
> +
>  	f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
> -	f->frequency = dev->ctl_freq;
> +	saa_call_all(dev, tuner, g_frequency, f);
>  
>  	return 0;
>  }
> @@ -2067,7 +2070,6 @@ static int saa7134_s_frequency(struct file *file, void *priv,
>  	if (1 == fh->radio && V4L2_TUNER_RADIO != f->type)
>  		return -EINVAL;
>  	mutex_lock(&dev->lock);
> -	dev->ctl_freq = f->frequency;
>  
>  	saa_call_all(dev, tuner, s_frequency, f);
>  
> diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
> index 2ffe069..d0ee05e 100644
> --- a/drivers/media/pci/saa7134/saa7134.h
> +++ b/drivers/media/pci/saa7134/saa7134.h
> @@ -604,7 +604,6 @@ struct saa7134_dev {
>  	int                        ctl_contrast;
>  	int                        ctl_hue;
>  	int                        ctl_saturation;
> -	int                        ctl_freq;
>  	int                        ctl_mute;             /* audio */
>  	int                        ctl_volume;
>  	int                        ctl_invert;           /* private */
> 
