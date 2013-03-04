Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:42667 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab3CDJXf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 04:23:35 -0500
Received: by mail-wi0-f175.google.com with SMTP id l13so1722743wie.8
        for <linux-media@vger.kernel.org>; Mon, 04 Mar 2013 01:23:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <28ffb525c2da963653402db5550c89f1878050e5.1362387265.git.hans.verkuil@cisco.com>
References: <b14bb5bd725678bc0fadfa241b462b5d6487f099.1362387265.git.hans.verkuil@cisco.com>
 <1362387905-3666-1-git-send-email-hverkuil@xs4all.nl> <28ffb525c2da963653402db5550c89f1878050e5.1362387265.git.hans.verkuil@cisco.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 4 Mar 2013 14:52:46 +0530
Message-ID: <CA+V-a8torY9H_G2twK3Ti2=tFYV8LxoyPKD9dGQAZhtCALLgVw@mail.gmail.com>
Subject: Re: [REVIEW PATCH 07/11] davinci/vpfe_capture: convert to the control framework.
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	linux@arm.linux.org.uk, Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Mar 4, 2013 at 2:35 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Lad, Prabhakar <prabhakar.lad@ti.com>

Regards,
--Prabhakar Lad

> ---
>  drivers/media/platform/davinci/vpfe_capture.c |   47 ++++---------------------
>  1 file changed, 7 insertions(+), 40 deletions(-)
>
> diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
> index 28d019d..70facc0 100644
> --- a/drivers/media/platform/davinci/vpfe_capture.c
> +++ b/drivers/media/platform/davinci/vpfe_capture.c
> @@ -1107,6 +1107,7 @@ static int vpfe_g_input(struct file *file, void *priv, unsigned int *index)
>  static int vpfe_s_input(struct file *file, void *priv, unsigned int index)
>  {
>         struct vpfe_device *vpfe_dev = video_drvdata(file);
> +       struct v4l2_subdev *sd;
>         struct vpfe_subdev_info *sdinfo;
>         int subdev_index, inp_index;
>         struct vpfe_route *route;
> @@ -1138,14 +1139,15 @@ static int vpfe_s_input(struct file *file, void *priv, unsigned int index)
>         }
>
>         sdinfo = &vpfe_dev->cfg->sub_devs[subdev_index];
> +       sd = vpfe_dev->sd[subdev_index];
>         route = &sdinfo->routes[inp_index];
>         if (route && sdinfo->can_route) {
>                 input = route->input;
>                 output = route->output;
>         }
>
> -       ret = v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
> -                                        video, s_routing, input, output, 0);
> +       if (sd)
> +               ret = v4l2_subdev_call(sd, video, s_routing, input, output, 0);
>
>         if (ret) {
>                 v4l2_err(&vpfe_dev->v4l2_dev,
> @@ -1154,6 +1156,8 @@ static int vpfe_s_input(struct file *file, void *priv, unsigned int index)
>                 goto unlock_out;
>         }
>         vpfe_dev->current_subdev = sdinfo;
> +       if (sd)
> +               vpfe_dev->v4l2_dev.ctrl_handler = sd->ctrl_handler;
>         vpfe_dev->current_input = index;
>         vpfe_dev->std_index = 0;
>
> @@ -1439,41 +1443,6 @@ static int vpfe_dqbuf(struct file *file, void *priv,
>                                       buf, file->f_flags & O_NONBLOCK);
>  }
>
> -static int vpfe_queryctrl(struct file *file, void *priv,
> -               struct v4l2_queryctrl *qctrl)
> -{
> -       struct vpfe_device *vpfe_dev = video_drvdata(file);
> -       struct vpfe_subdev_info *sdinfo;
> -
> -       sdinfo = vpfe_dev->current_subdev;
> -
> -       return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
> -                                        core, queryctrl, qctrl);
> -
> -}
> -
> -static int vpfe_g_ctrl(struct file *file, void *priv, struct v4l2_control *ctrl)
> -{
> -       struct vpfe_device *vpfe_dev = video_drvdata(file);
> -       struct vpfe_subdev_info *sdinfo;
> -
> -       sdinfo = vpfe_dev->current_subdev;
> -
> -       return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
> -                                        core, g_ctrl, ctrl);
> -}
> -
> -static int vpfe_s_ctrl(struct file *file, void *priv, struct v4l2_control *ctrl)
> -{
> -       struct vpfe_device *vpfe_dev = video_drvdata(file);
> -       struct vpfe_subdev_info *sdinfo;
> -
> -       sdinfo = vpfe_dev->current_subdev;
> -
> -       return v4l2_device_call_until_err(&vpfe_dev->v4l2_dev, sdinfo->grp_id,
> -                                        core, s_ctrl, ctrl);
> -}
> -
>  /*
>   * vpfe_calculate_offsets : This function calculates buffers offset
>   * for top and bottom field
> @@ -1781,9 +1750,6 @@ static const struct v4l2_ioctl_ops vpfe_ioctl_ops = {
>         .vidioc_querystd         = vpfe_querystd,
>         .vidioc_s_std            = vpfe_s_std,
>         .vidioc_g_std            = vpfe_g_std,
> -       .vidioc_queryctrl        = vpfe_queryctrl,
> -       .vidioc_g_ctrl           = vpfe_g_ctrl,
> -       .vidioc_s_ctrl           = vpfe_s_ctrl,
>         .vidioc_reqbufs          = vpfe_reqbufs,
>         .vidioc_querybuf         = vpfe_querybuf,
>         .vidioc_qbuf             = vpfe_qbuf,
> @@ -2007,6 +1973,7 @@ static int vpfe_probe(struct platform_device *pdev)
>
>         /* set first sub device as current one */
>         vpfe_dev->current_subdev = &vpfe_cfg->sub_devs[0];
> +       vpfe_dev->v4l2_dev.ctrl_handler = vpfe_dev->sd[0]->ctrl_handler;
>
>         /* We have at least one sub device to work with */
>         mutex_unlock(&ccdc_lock);
> --
> 1.7.10.4
>
