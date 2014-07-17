Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:29815 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbaGQWqE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 18:46:04 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8V00KGUOKQHQ10@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 17 Jul 2014 18:46:02 -0400 (EDT)
Date: Thu, 17 Jul 2014 19:45:56 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, it@sca-uk.com, =stoth@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/2] cx23885: fix UNSET/TUNER_ABSENT confusion.
Message-id: <20140717194556.5b6e8636.m.chehab@samsung.com>
In-reply-to: <1403878542-1230-2-git-send-email-hverkuil@xs4all.nl>
References: <1403878542-1230-1-git-send-email-hverkuil@xs4all.nl>
 <1403878542-1230-2-git-send-email-hverkuil@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 27 Jun 2014 16:15:41 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Sometimes dev->tuner_type is compared to UNSET, sometimes to TUNER_ABSENT,
> but these defines have different values.
> 
> Standardize to TUNER_ABSENT.

That patch looks wrong. UNSET has value -1, while TUNER_ABSENT has value 4.
The only way that this patch won't be causing regressions is if none
was used, with is not the case, IMHO.

A patch removing either one would be a way more complex, and should likely
touch on other cx23885 files:

$ git grep -e UNSET --or -e TUNER_ABSENT -l drivers/media/pci/cx23885/ 
drivers/media/pci/cx23885/cx23885-417.c
drivers/media/pci/cx23885/cx23885-cards.c
drivers/media/pci/cx23885/cx23885-core.c
drivers/media/pci/cx23885/cx23885-video.c
drivers/media/pci/cx23885/cx23885.h

and also on tveeprom.

However, touching at tveeprom would require touching also on all
other drivers that support Hauppauge devices.

Regards,
Mauro

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/pci/cx23885/cx23885-417.c   |  8 ++++----
>  drivers/media/pci/cx23885/cx23885-video.c | 10 +++++-----
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
> index 95666ee..bf89fc8 100644
> --- a/drivers/media/pci/cx23885/cx23885-417.c
> +++ b/drivers/media/pci/cx23885/cx23885-417.c
> @@ -1266,7 +1266,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
>  	struct cx23885_fh  *fh  = file->private_data;
>  	struct cx23885_dev *dev = fh->dev;
>  
> -	if (UNSET == dev->tuner_type)
> +	if (dev->tuner_type == TUNER_ABSENT)
>  		return -EINVAL;
>  	if (0 != t->index)
>  		return -EINVAL;
> @@ -1284,7 +1284,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
>  	struct cx23885_fh  *fh  = file->private_data;
>  	struct cx23885_dev *dev = fh->dev;
>  
> -	if (UNSET == dev->tuner_type)
> +	if (dev->tuner_type == TUNER_ABSENT)
>  		return -EINVAL;
>  
>  	/* Update the A/V core */
> @@ -1299,7 +1299,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
>  	struct cx23885_fh  *fh  = file->private_data;
>  	struct cx23885_dev *dev = fh->dev;
>  
> -	if (UNSET == dev->tuner_type)
> +	if (dev->tuner_type == TUNER_ABSENT)
>  		return -EINVAL;
>  	f->type = V4L2_TUNER_ANALOG_TV;
>  	f->frequency = dev->freq;
> @@ -1347,7 +1347,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
>  		V4L2_CAP_READWRITE     |
>  		V4L2_CAP_STREAMING     |
>  		0;
> -	if (UNSET != dev->tuner_type)
> +	if (dev->tuner_type != TUNER_ABSENT)
>  		cap->capabilities |= V4L2_CAP_TUNER;
>  
>  	return 0;
> diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
> index e0a5952..2a890e9 100644
> --- a/drivers/media/pci/cx23885/cx23885-video.c
> +++ b/drivers/media/pci/cx23885/cx23885-video.c
> @@ -1156,7 +1156,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
>  		V4L2_CAP_READWRITE     |
>  		V4L2_CAP_STREAMING     |
>  		V4L2_CAP_VBI_CAPTURE;
> -	if (UNSET != dev->tuner_type)
> +	if (dev->tuner_type != TUNER_ABSENT)
>  		cap->capabilities |= V4L2_CAP_TUNER;
>  	return 0;
>  }
> @@ -1474,7 +1474,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
>  {
>  	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
>  
> -	if (unlikely(UNSET == dev->tuner_type))
> +	if (dev->tuner_type == TUNER_ABSENT)
>  		return -EINVAL;
>  	if (0 != t->index)
>  		return -EINVAL;
> @@ -1490,7 +1490,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
>  {
>  	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
>  
> -	if (UNSET == dev->tuner_type)
> +	if (dev->tuner_type == TUNER_ABSENT)
>  		return -EINVAL;
>  	if (0 != t->index)
>  		return -EINVAL;
> @@ -1506,7 +1506,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
>  	struct cx23885_fh *fh = priv;
>  	struct cx23885_dev *dev = fh->dev;
>  
> -	if (unlikely(UNSET == dev->tuner_type))
> +	if (dev->tuner_type == TUNER_ABSENT)
>  		return -EINVAL;
>  
>  	/* f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV; */
> @@ -1522,7 +1522,7 @@ static int cx23885_set_freq(struct cx23885_dev *dev, const struct v4l2_frequency
>  {
>  	struct v4l2_control ctrl;
>  
> -	if (unlikely(UNSET == dev->tuner_type))
> +	if (dev->tuner_type == TUNER_ABSENT)
>  		return -EINVAL;
>  	if (unlikely(f->tuner != 0))
>  		return -EINVAL;
