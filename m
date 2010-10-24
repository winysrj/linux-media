Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36254 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab0JXOpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Oct 2010 10:45:51 -0400
Received: by bwz11 with SMTP id 11so1724349bwz.19
        for <linux-media@vger.kernel.org>; Sun, 24 Oct 2010 07:45:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikAKhfcdjwCZjvez4A7OBLyE1s7mgVKoO3ChAa=@mail.gmail.com>
References: <1287730851-18579-1-git-send-email-mats.randgaard@tandberg.com>
	<1287730851-18579-5-git-send-email-mats.randgaard@tandberg.com>
	<AANLkTikAKhfcdjwCZjvez4A7OBLyE1s7mgVKoO3ChAa=@mail.gmail.com>
Date: Sun, 24 Oct 2010 10:45:49 -0400
Message-ID: <AANLkTimCkGpZGNPyr0qfzuEKrp65MCQ+wOh_4w7CW7nr@mail.gmail.com>
Subject: Fwd: [RFC/PATCH 4/5] vpif_cap/disp: Added support for DV timings
From: Muralidharan Karicheri <mkaricheri@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

---------- Forwarded message ----------
From: Muralidharan Karicheri <mkaricheri@gmail.com>
Date: Sun, Oct 24, 2010 at 10:33 AM
Subject: Re: [RFC/PATCH 4/5] vpif_cap/disp: Added support for DV timings
To: mats.randgaard@tandberg.com




On Fri, Oct 22, 2010 at 3:00 AM, <mats.randgaard@tandberg.com> wrote:
>
> From: Mats Randgaard <mats.randgaard@tandberg.com>
>
> Added functions to set and get custom DV timings.
>
> Signed-off-by: Mats Randgaard <mats.randgaard@tandberg.com>
> Signed-off-by: Hans Verkuil <hans.verkuil@tandberg.com>
> ---
>  drivers/media/video/davinci/vpif_capture.c |  119 +++++++++++++++++++++++++++
>  drivers/media/video/davinci/vpif_capture.h |    1 +
>  drivers/media/video/davinci/vpif_display.c |  120 ++++++++++++++++++++++++++++
>  drivers/media/video/davinci/vpif_display.h |    1 +
>  4 files changed, 241 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
> index bf1adea..184fa3c 100644
> --- a/drivers/media/video/davinci/vpif_capture.c
> +++ b/drivers/media/video/davinci/vpif_capture.c
> @@ -1927,6 +1927,123 @@ static int vpif_g_dv_preset(struct file *file, void *priv,
>        return 0;
>  }
>
> +/**
> + * vpif_s_dv_timings() - S_DV_TIMINGS handler
> + * @file: file ptr
> + * @priv: file handle
> + * @timings: digital video timings
> + */
> +static int vpif_s_dv_timings(struct file *file, void *priv,
> +               struct v4l2_dv_timings *timings)
> +{
> +       struct vpif_fh *fh = priv;
> +       struct channel_obj *ch = fh->channel;
> +       struct vpif_params *vpifparams = &ch->vpifparams;
> +       struct vpif_channel_config_params *std_info = &vpifparams->std_info;
> +       struct video_obj *vid_obj = &ch->video;
> +       struct v4l2_bt_timings *bt = &vid_obj->bt_timings;
> +       int ret;
> +
> +       if (timings->type != V4L2_DV_BT_656_1120) {
> +               vpif_dbg(2, debug, "Timing type not defined\n");
> +               return -EINVAL;
> +       }
> +
> +       /* Configure subdevice timings, if any */
> +       ret = v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index],
> +                       video, s_dv_timings, timings);
> +       if (ret == -ENOIOCTLCMD) {
> +               vpif_dbg(2, debug, "Custom DV timings not supported by "
> +                               "subdevice\n");
> +               return -EINVAL;
> +       }
> +       if (ret < 0) {
> +               vpif_dbg(2, debug, "Error setting custom DV timings\n");
> +               return ret;
> +       }
> +
> +       if (!(timings->bt.width && timings->bt.height &&
> +                               (timings->bt.hbackporch ||
> +                                timings->bt.hfrontporch ||
> +                                timings->bt.hsync) &&
> +                               timings->bt.vfrontporch &&
> +                               (timings->bt.vbackporch ||
> +                                timings->bt.vsync))) {
> +               vpif_dbg(2, debug, "Timings for width, height, "
> +                               "horizontal back porch, horizontal sync, "
> +                               "horizontal front porch, vertical back porch, "
> +                               "vertical sync and vertical back porch "
> +                               "must be defined\n");
> +               return -EINVAL;
> +       }
> +
> +       *bt = timings->bt;
> +
> +       /* Configure videoport timings */


>
> video port ?


>
> +       std_info->eav2sav = bt->hbackporch + bt->hfrontporch +
> +               bt->hsync - 8;
> +       std_info->sav2eav = bt->width;
> +
> +       std_info->l1 = 1;
> +       std_info->l3 = bt->vsync + bt->vbackporch + 1;
> +
> +       if (bt->interlaced) {
> +               if (bt->il_vbackporch || bt->il_vfrontporch || bt->il_vsync) {
> +                       std_info->vsize = bt->height * 2 +
> +                               bt->vfrontporch + bt->vsync + bt->vbackporch +
> +                               bt->il_vfrontporch + bt->il_vsync +
> +                               bt->il_vbackporch;
> +                       std_info->l5 = std_info->vsize/2 -
> +                               (bt->vfrontporch - 1);
> +                       std_info->l7 = std_info->vsize/2 + 1;
> +                       std_info->l9 = std_info->l7 + bt->il_vsync +
> +                               bt->il_vbackporch + 1;
> +                       std_info->l11 = std_info->vsize -
> +                               (bt->il_vfrontporch - 1);
> +               } else {
> +                       vpif_dbg(2, debug, "Required timing values for "
> +                                       "interlaced BT format missing\n");
> +                       return -EINVAL;
> +               }
> +       } else {
> +               std_info->vsize = bt->height + bt->vfrontporch +
> +                       bt->vsync + bt->vbackporch;
> +               std_info->l5 = std_info->vsize - (bt->vfrontporch - 1);
> +       }

Is the calculation above generic? If not, better this be moved to vpif.c

>
> +       strncpy(std_info->name, "Custom timings BT656/1120", VPIF_MAX_NAME);
> +       std_info->width = bt->width;
> +       std_info->height = bt->height;
> +       std_info->frm_fmt = bt->interlaced ? 0 : 1;
> +       std_info->ycmux_mode = 0;
> +       std_info->capture_format = 0;
> +       std_info->vbi_supported = 0;
> +       std_info->hd_sd = 1;
> +       std_info->stdid = 0;
> +       std_info->dv_preset = V4L2_DV_INVALID;
> +
> +       return 0;
> +}
> +
> +/**
> + * vpif_g_dv_timings() - G_DV_TIMINGS handler
> + * @file: file ptr
> + * @priv: file handle
> + * @timings: digital video timings
> + */
> +static int vpif_g_dv_timings(struct file *file, void *priv,
> +               struct v4l2_dv_timings *timings)
> +{
> +       struct vpif_fh *fh = priv;
> +       struct channel_obj *ch = fh->channel;
> +       struct video_obj *vid_obj = &ch->video;
> +       struct v4l2_bt_timings *bt = &vid_obj->bt_timings;
> +
> +       timings->bt = *bt;
> +
> +       return 0;
> +}
> +
>  /*
>  * vpif_g_chip_ident() - Identify the chip
>  * @file: file ptr
> @@ -2033,6 +2150,8 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
>        .vidioc_s_dv_preset             = vpif_s_dv_preset,
>        .vidioc_g_dv_preset             = vpif_g_dv_preset,
>        .vidioc_query_dv_preset         = vpif_query_dv_preset,
> +       .vidioc_s_dv_timings            = vpif_s_dv_timings,
> +       .vidioc_g_dv_timings            = vpif_g_dv_timings,
>        .vidioc_g_chip_ident            = vpif_g_chip_ident,
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>        .vidioc_g_register              = vpif_dbg_g_register,
> diff --git a/drivers/media/video/davinci/vpif_capture.h b/drivers/media/video/davinci/vpif_capture.h
> index 3452a8a..7a4196d 100644
> --- a/drivers/media/video/davinci/vpif_capture.h
> +++ b/drivers/media/video/davinci/vpif_capture.h
> @@ -60,6 +60,7 @@ struct video_obj {
>        /* Currently selected or default standard */
>        v4l2_std_id stdid;
>        u32 dv_preset;
> +       struct v4l2_bt_timings bt_timings;
>        /* This is to track the last input that is passed to application */
>        u32 input_idx;
>  };
> diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
> index 4554971..bc42505 100644
> --- a/drivers/media/video/davinci/vpif_display.c
> +++ b/drivers/media/video/davinci/vpif_display.c
> @@ -1409,6 +1409,124 @@ static int vpif_g_dv_preset(struct file *file, void *priv,
>
>        return 0;
>  }
> +/**
> + * vpif_s_dv_timings() - S_DV_TIMINGS handler
> + * @file: file ptr
> + * @priv: file handle
> + * @timings: digital video timings
> + */
> +static int vpif_s_dv_timings(struct file *file, void *priv,
> +               struct v4l2_dv_timings *timings)
> +{
> +       struct vpif_fh *fh = priv;
> +       struct channel_obj *ch = fh->channel;
> +       struct vpif_params *vpifparams = &ch->vpifparams;
> +       struct vpif_channel_config_params *std_info = &vpifparams->std_info;
> +       struct video_obj *vid_obj = &ch->video;
> +       struct v4l2_bt_timings *bt = &vid_obj->bt_timings;
> +       struct video_obj *vid_ch = &ch->video;
> +       int ret;
> +
> +       if (timings->type != V4L2_DV_BT_656_1120) {
> +               vpif_dbg(2, debug, "Timing type not defined\n");
> +               return -EINVAL;
> +       }
> +
> +       /* Configure subdevice timings, if any */
> +       ret = v4l2_subdev_call(vpif_obj.sd[vid_ch->output_id],
> +                       video, s_dv_timings, timings);
> +       if (ret == -ENOIOCTLCMD) {
> +               vpif_dbg(2, debug, "Custom DV timings not supported by "
> +                               "subdevice\n");
> +               return -EINVAL;
> +       }
> +       if (ret < 0) {
> +               vpif_dbg(2, debug, "Error setting custom DV timings\n");
> +               return ret;
> +       }
> +
> +       if (!(timings->bt.width && timings->bt.height &&
> +                               (timings->bt.hbackporch ||
> +                                timings->bt.hfrontporch ||
> +                                timings->bt.hsync) &&
> +                               timings->bt.vfrontporch &&
> +                               (timings->bt.vbackporch ||
> +                                timings->bt.vsync))) {
> +               vpif_dbg(2, debug, "Timings for width, height, "
> +                               "horizontal back porch, horizontal sync, "
> +                               "horizontal front porch, vertical back porch, "
> +                               "vertical sync and vertical back porch "
> +                               "must be defined\n");
> +               return -EINVAL;
> +       }
> +
> +       *bt = timings->bt;
> +
> +       /* Configure videoport timings */
> +

video port?

>
> +       std_info->eav2sav = bt->hbackporch + bt->hfrontporch +
> +               bt->hsync - 8;
> +       std_info->sav2eav = bt->width;
> +
> +       std_info->l1 = 1;
> +       std_info->l3 = bt->vsync + bt->vbackporch + 1;
> +
> +       if (bt->interlaced) {
> +               if (bt->il_vbackporch || bt->il_vfrontporch || bt->il_vsync) {
> +                       std_info->vsize = bt->height * 2 +
> +                               bt->vfrontporch + bt->vsync + bt->vbackporch +
> +                               bt->il_vfrontporch + bt->il_vsync +
> +                               bt->il_vbackporch;
> +                       std_info->l5 = std_info->vsize/2 -
> +                               (bt->vfrontporch - 1);
> +                       std_info->l7 = std_info->vsize/2 + 1;
> +                       std_info->l9 = std_info->l7 + bt->il_vsync +
> +                               bt->il_vbackporch + 1;
> +                       std_info->l11 = std_info->vsize -
> +                               (bt->il_vfrontporch - 1);
> +               } else {
> +                       vpif_dbg(2, debug, "Required timing values for "
> +                                       "interlaced BT format missing\n");
> +                       return -EINVAL;
> +               }
> +       } else {
> +               std_info->vsize = bt->height + bt->vfrontporch +
> +                       bt->vsync + bt->vbackporch;
> +               std_info->l5 = std_info->vsize - (bt->vfrontporch - 1);
> +       }

If the calculation above is dependent on vpif, move this part to vpif?

>
> +       strncpy(std_info->name, "Custom timings BT656/1120",
> +                       VPIF_MAX_NAME);
> +       std_info->width = bt->width;
> +       std_info->height = bt->height;
> +       std_info->frm_fmt = bt->interlaced ? 0 : 1;
> +       std_info->ycmux_mode = 0;
> +       std_info->capture_format = 0;
> +       std_info->vbi_supported = 0;
> +       std_info->hd_sd = 1;
> +       std_info->stdid = 0;
> +       std_info->dv_preset = V4L2_DV_INVALID;
> +
> +       return 0;
> +}
> +
> +/**
> + * vpif_g_dv_timings() - G_DV_TIMINGS handler
> + * @file: file ptr
> + * @priv: file handle
> + * @timings: digital video timings
> + */
> +static int vpif_g_dv_timings(struct file *file, void *priv,
> +               struct v4l2_dv_timings *timings)
> +{
> +       struct vpif_fh *fh = priv;
> +       struct channel_obj *ch = fh->channel;
> +       struct video_obj *vid_obj = &ch->video;
> +       struct v4l2_bt_timings *bt = &vid_obj->bt_timings;
> +
> +       timings->bt = *bt;
> +
> +       return 0;
> +}
>
>  /*
>  * vpif_g_chip_ident() - Identify the chip
> @@ -1517,6 +1635,8 @@ static const struct v4l2_ioctl_ops vpif_ioctl_ops = {
>        .vidioc_enum_dv_presets         = vpif_enum_dv_presets,
>        .vidioc_s_dv_preset             = vpif_s_dv_preset,
>        .vidioc_g_dv_preset             = vpif_g_dv_preset,
> +       .vidioc_s_dv_timings            = vpif_s_dv_timings,
> +       .vidioc_g_dv_timings            = vpif_g_dv_timings,
>        .vidioc_g_chip_ident            = vpif_g_chip_ident,
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>        .vidioc_g_register              = vpif_dbg_g_register,
> diff --git a/drivers/media/video/davinci/vpif_display.h b/drivers/media/video/davinci/vpif_display.h
> index 3d56b3e..b53aaa8 100644
> --- a/drivers/media/video/davinci/vpif_display.h
> +++ b/drivers/media/video/davinci/vpif_display.h
> @@ -68,6 +68,7 @@ struct video_obj {
>        v4l2_std_id stdid;              /* Currently selected or default
>                                         * standard */
>        u32 dv_preset;
> +       struct v4l2_bt_timings bt_timings;
>        u32 output_id;                  /* Current output id */
>  };
>
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Murali Karicheri
mkaricheri@gmail.com



-- 
Murali Karicheri
mkaricheri@gmail.com
