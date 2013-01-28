Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2119 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3A1KL3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 05:11:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 5/7] saa7134: v4l2-compliance: fix g_tuner/s_tuner
Date: Mon, 28 Jan 2013 11:11:15 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1359315912-1767-1-git-send-email-linux@rainbow-software.org> <1359315912-1767-6-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1359315912-1767-6-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301281111.15114.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun January 27 2013 20:45:10 Ondrej Zary wrote:
> Make saa7134 driver more V4L2 compliant: return real frequency range in
> g_tuner and fail in s_tuner for non-zero tuner
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>


> ---
>  drivers/media/pci/saa7134/saa7134-video.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
> index 87b2b9e..0b42f0c 100644
> --- a/drivers/media/pci/saa7134/saa7134-video.c
> +++ b/drivers/media/pci/saa7134/saa7134-video.c
> @@ -2011,11 +2011,11 @@ static int saa7134_g_tuner(struct file *file, void *priv,
>  	if (NULL != card_in(dev, n).name) {
>  		strcpy(t->name, "Television");
>  		t->type = V4L2_TUNER_ANALOG_TV;
> +		saa_call_all(dev, tuner, g_tuner, t);
>  		t->capability = V4L2_TUNER_CAP_NORM |
>  			V4L2_TUNER_CAP_STEREO |
>  			V4L2_TUNER_CAP_LANG1 |
>  			V4L2_TUNER_CAP_LANG2;
> -		t->rangehigh = 0xffffffffUL;
>  		t->rxsubchans = saa7134_tvaudio_getstereo(dev);
>  		t->audmode = saa7134_tvaudio_rx2mode(t->rxsubchans);
>  	}
> @@ -2031,6 +2031,9 @@ static int saa7134_s_tuner(struct file *file, void *priv,
>  	struct saa7134_dev *dev = fh->dev;
>  	int rx, mode;
>  
> +	if (0 != t->index)
> +		return -EINVAL;
> +
>  	mode = dev->thread.mode;
>  	if (UNSET == mode) {
>  		rx   = saa7134_tvaudio_getstereo(dev);
> 
