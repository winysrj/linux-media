Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f192.google.com ([209.85.222.192]:42370 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875AbZFKLKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 07:10:12 -0400
Received: by pzk30 with SMTP id 30so86910pzk.33
        for <linux-media@vger.kernel.org>; Thu, 11 Jun 2009 04:10:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0906101604420.4817@axis700.grange>
References: <Pine.LNX.4.64.0906101549160.4817@axis700.grange>
	 <Pine.LNX.4.64.0906101604420.4817@axis700.grange>
Date: Thu, 11 Jun 2009 20:10:14 +0900
Message-ID: <5e9665e10906110410w7893e016g6e35742c9a55889d@mail.gmail.com>
Subject: Re: [PATCH 3/4] soc-camera: add support for camera-host controls
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Guennadi,

It's a very interesting patch. Actually some camera interfaces support
for various image effects and I was wondering how to use them in SoC
camera subsystem.

But here is a question. Is it possible to make a choice with the same
CID between icd and ici? I mean, if both of camera interface and
camera device are supporting for same CID how can user select any of
them to use? Sometimes, some image effects supported by camera
interface are not good so I want to use the same effect supported by
external camera ISP device.

I think, it might be possible but I can't see how.
Cheers,

Nate

On Thu, Jun 11, 2009 at 4:12 PM, Guennadi
Liakhovetski<g.liakhovetski@gmx.de> wrote:
> Until now soc-camera only supported client (sensor) controls. This patch
> enables camera-host drivers to implement their own controls too.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/video/soc_camera.c |   24 ++++++++++++++++++++++++
>  include/media/soc_camera.h       |    4 ++++
>  2 files changed, 28 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index 824c68b..8e987ca 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -633,6 +633,7 @@ static int soc_camera_queryctrl(struct file *file, void *priv,
>  {
>        struct soc_camera_file *icf = file->private_data;
>        struct soc_camera_device *icd = icf->icd;
> +       struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>        int i;
>
>        WARN_ON(priv != file->private_data);
> @@ -640,6 +641,15 @@ static int soc_camera_queryctrl(struct file *file, void *priv,
>        if (!qc->id)
>                return -EINVAL;
>
> +       /* First check host controls */
> +       for (i = 0; i < ici->ops->num_controls; i++)
> +               if (qc->id == ici->ops->controls[i].id) {
> +                       memcpy(qc, &(ici->ops->controls[i]),
> +                               sizeof(*qc));
> +                       return 0;
> +               }
> +
> +       /* Then device controls */
>        for (i = 0; i < icd->ops->num_controls; i++)
>                if (qc->id == icd->ops->controls[i].id) {
>                        memcpy(qc, &(icd->ops->controls[i]),
> @@ -656,6 +666,7 @@ static int soc_camera_g_ctrl(struct file *file, void *priv,
>        struct soc_camera_file *icf = file->private_data;
>        struct soc_camera_device *icd = icf->icd;
>        struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +       int ret;
>
>        WARN_ON(priv != file->private_data);
>
> @@ -672,6 +683,12 @@ static int soc_camera_g_ctrl(struct file *file, void *priv,
>                return 0;
>        }
>
> +       if (ici->ops->get_ctrl) {
> +               ret = ici->ops->get_ctrl(icd, ctrl);
> +               if (ret != -ENOIOCTLCMD)
> +                       return ret;
> +       }
> +
>        return v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, core, g_ctrl, ctrl);
>  }
>
> @@ -681,9 +698,16 @@ static int soc_camera_s_ctrl(struct file *file, void *priv,
>        struct soc_camera_file *icf = file->private_data;
>        struct soc_camera_device *icd = icf->icd;
>        struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +       int ret;
>
>        WARN_ON(priv != file->private_data);
>
> +       if (ici->ops->set_ctrl) {
> +               ret = ici->ops->set_ctrl(icd, ctrl);
> +               if (ret != -ENOIOCTLCMD)
> +                       return ret;
> +       }
> +
>        return v4l2_device_call_until_err(&ici->v4l2_dev, (__u32)icd, core, s_ctrl, ctrl);
>  }
>
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index 3bc5b6b..2d116bb 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -83,7 +83,11 @@ struct soc_camera_host_ops {
>        int (*reqbufs)(struct soc_camera_file *, struct v4l2_requestbuffers *);
>        int (*querycap)(struct soc_camera_host *, struct v4l2_capability *);
>        int (*set_bus_param)(struct soc_camera_device *, __u32);
> +       int (*get_ctrl)(struct soc_camera_device *, struct v4l2_control *);
> +       int (*set_ctrl)(struct soc_camera_device *, struct v4l2_control *);
>        unsigned int (*poll)(struct file *, poll_table *);
> +       const struct v4l2_queryctrl *controls;
> +       int num_controls;
>  };
>
>  #define SOCAM_SENSOR_INVERT_PCLK       (1 << 0)
> --
> 1.6.2.4
>
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
