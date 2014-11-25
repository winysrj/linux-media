Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62276 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbaKYK7s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 05:59:48 -0500
Received: by mail-wi0-f178.google.com with SMTP id hi2so977541wib.17
        for <linux-media@vger.kernel.org>; Tue, 25 Nov 2014 02:59:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1416821846-7677-3-git-send-email-hverkuil@xs4all.nl>
References: <1416821846-7677-1-git-send-email-hverkuil@xs4all.nl> <1416821846-7677-3-git-send-email-hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 25 Nov 2014 10:59:16 +0000
Message-ID: <CA+V-a8tQq=dBiRcuhrekTU8HJfetA9bj_xLB4nKifVXEcWifHw@mail.gmail.com>
Subject: Re: [PATCH 2/6] staging/media: fix querycap
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Mon, Nov 24, 2014 at 9:37 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Querycap shouldn't set the version field (the core does that for you),
> but it should set the device_caps field.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> ---
>  drivers/staging/media/bcm2048/radio-bcm2048.c   | 5 +++--
>  drivers/staging/media/davinci_vpfe/vpfe_video.c | 8 ++++----
>  drivers/staging/media/dt3155v4l/dt3155v4l.c     | 5 ++---
>  3 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> index bdc6854..60a57b2 100644
> --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> @@ -2327,9 +2327,10 @@ static int bcm2048_vidioc_querycap(struct file *file, void *priv,
>         strlcpy(capability->card, BCM2048_DRIVER_CARD,
>                 sizeof(capability->card));
>         snprintf(capability->bus_info, 32, "I2C: 0x%X", bdev->client->addr);
> -       capability->version = BCM2048_DRIVER_VERSION;
> -       capability->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO |
> +       capability->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO |
>                                         V4L2_CAP_HW_FREQ_SEEK;
> +       capability->capabilities = capability->device_caps |
> +               V4L2_CAP_DEVICE_CAPS;
>
>         return 0;
>  }
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> index 6f9171c..06d48d5 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -600,11 +600,11 @@ static int vpfe_querycap(struct file *file, void  *priv,
>         v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_querycap\n");
>
>         if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -               cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +               cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
>         else
> -               cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> -       cap->device_caps = cap->capabilities;
> -       cap->version = VPFE_CAPTURE_VERSION_CODE;
> +               cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> +       cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
> +                           V4L2_CAP_STREAMING | V4L2_CAP_DEVICE_CAPS;
>         strlcpy(cap->driver, CAPTURE_DRV_NAME, sizeof(cap->driver));
>         strlcpy(cap->bus_info, "VPFE", sizeof(cap->bus_info));
>         strlcpy(cap->card, vpfe_dev->cfg->card_name, sizeof(cap->card));
> diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
> index 4058022..293ffda 100644
> --- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
> +++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
> @@ -512,10 +512,9 @@ dt3155_ioc_querycap(struct file *filp, void *p, struct v4l2_capability *cap)
>         strcpy(cap->driver, DT3155_NAME);
>         strcpy(cap->card, DT3155_NAME " frame grabber");
>         sprintf(cap->bus_info, "PCI:%s", pci_name(pd->pdev));
> -       cap->version =
> -              KERNEL_VERSION(DT3155_VER_MAJ, DT3155_VER_MIN, DT3155_VER_EXT);
> -       cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
> +       cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
>                                 DT3155_CAPTURE_METHOD;
> +       cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>         return 0;
>  }
>
> --
> 2.1.3
>
