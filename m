Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2135 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab3A1OVT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 09:21:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 9/7] saa7134: v4l2-compliance: initialize VBI structure
Date: Mon, 28 Jan 2013 15:21:09 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1359315912-1767-1-git-send-email-linux@rainbow-software.org> <201301281511.53915.linux@rainbow-software.org>
In-Reply-To: <201301281511.53915.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301281521.09728.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon January 28 2013 15:11:53 Ondrej Zary wrote:
> Make saa7134 driver more V4L2 compliant: clear VBI structure completely
> before assigning values to make sure any reserved space is cleared
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>  drivers/media/pci/saa7134/saa7134-video.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/pci/saa7134/saa7134-video.c 
> b/drivers/media/pci/saa7134/saa7134-video.c
> index 3e88041..adb83b5 100644
> --- a/drivers/media/pci/saa7134/saa7134-video.c
> +++ b/drivers/media/pci/saa7134/saa7134-video.c
> @@ -1552,6 +1552,7 @@ static int saa7134_try_get_set_fmt_vbi_cap(struct file 
> *file, void *priv,
>  	struct saa7134_dev *dev = fh->dev;
>  	struct saa7134_tvnorm *norm = dev->tvnorm;
>  
> +	memset(&f->fmt.vbi, 0, sizeof(f->fmt.vbi));

I prefer:

	memset(&f->fmt.vbi.reserved, 0, sizeof(f->fmt.vbi.reserved));

After all, that's the only thing that needs clearing.

Regards,

	Hans

>  	f->fmt.vbi.sampling_rate = 6750000 * 4;
>  	f->fmt.vbi.samples_per_line = 2048 /* VBI_LINE_LENGTH */;
>  	f->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
> 
