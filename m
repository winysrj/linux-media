Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37233 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab1LPIeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Dec 2011 03:34:07 -0500
Received: by vcbfk14 with SMTP id fk14so2261019vcb.19
        for <linux-media@vger.kernel.org>; Fri, 16 Dec 2011 00:34:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
Date: Fri, 16 Dec 2011 16:34:06 +0800
Message-ID: <CAHG8p1Cki1tbziatSXsB3e1NVtZ2VmKgCLpR3-8+6QAKrzFEVg@mail.gmail.com>
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	saaguirre@ti.com, mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/12/16 Javier Martin <javier.martin@vista-silicon.com>:
> Some v4l-subdevs such as tvp5150 have multiple
> inputs. This patch allows the user of a soc-camera
> device to select between them.
>
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/media/video/soc_camera.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index b72580c..1cea1a9 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -235,10 +235,10 @@ static int soc_camera_g_input(struct file *file, void *priv, unsigned int *i)
>
>  static int soc_camera_s_input(struct file *file, void *priv, unsigned int i)
>  {
> -       if (i > 0)
> -               return -EINVAL;
should it check max input?

> +       struct soc_camera_device *icd = file->private_data;
> +       struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>
> -       return 0;
> +       return v4l2_subdev_call(sd, video, s_routing, i, 0, 0);
>  }
>
why must output be zero?

Regards,
Scott
