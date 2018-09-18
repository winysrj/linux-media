Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33960 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbeIRLzS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 07:55:18 -0400
Received: by mail-it0-f67.google.com with SMTP id x79-v6so13255318ita.1
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2018 23:24:13 -0700 (PDT)
MIME-Version: 1.0
References: <1537200191-17956-1-git-send-email-akinobu.mita@gmail.com> <1537200191-17956-5-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1537200191-17956-5-git-send-email-akinobu.mita@gmail.com>
From: Matt Ranostay <matt.ranostay@konsulko.com>
Date: Tue, 18 Sep 2018 08:24:01 +0200
Message-ID: <CAJCx=gmvPjC90qHOer30B7rC_-KhR3j-zsWohFXBKp-C5ZEO9g@mail.gmail.com>
Subject: Re: [PATCH 4/5] media: video-i2c: support changing frame interval
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        Hans Verkuil <hansverk@cisco.com>, mchehab@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 17, 2018 at 6:03 PM Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
> AMG88xx has a register for setting frame rate 1 or 10 FPS.
> This adds support changing frame interval.
>
> Reference specifications:
> https://docid81hrs3j1.cloudfront.net/medialibrary/2017/11/PANA-S-A0002141979-1.pdf
>
> Cc: Matt Ranostay <matt.ranostay@konsulko.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Hans Verkuil <hansverk@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>

> ---
>  drivers/media/i2c/video-i2c.c | 76 ++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 64 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
> index 90d389b..916f36e 100644
> --- a/drivers/media/i2c/video-i2c.c
> +++ b/drivers/media/i2c/video-i2c.c
> @@ -52,6 +52,8 @@ struct video_i2c_data {
>
>         struct task_struct *kthread_vid_cap;
>         struct list_head vid_cap_active;
> +
> +       struct v4l2_fract frame_interval;
>  };
>
>  static const struct v4l2_fmtdesc amg88xx_format = {
> @@ -74,8 +76,9 @@ struct video_i2c_chip {
>         const struct v4l2_fmtdesc *format;
>         const struct v4l2_frmsize_discrete *size;
>
> -       /* max frames per second */
> -       unsigned int max_fps;
> +       /* available frame intervals */
> +       const struct v4l2_fract *frame_intervals;
> +       unsigned int num_frame_intervals;
>
>         /* pixel buffer size */
>         unsigned int buffer_size;
> @@ -85,6 +88,9 @@ struct video_i2c_chip {
>
>         const struct regmap_config *regmap_config;
>
> +       /* setup function */
> +       int (*setup)(struct video_i2c_data *data);
> +
>         /* xfer function */
>         int (*xfer)(struct video_i2c_data *data, char *buf);
>
> @@ -98,6 +104,22 @@ static int amg88xx_xfer(struct video_i2c_data *data, char *buf)
>                                 data->chip->buffer_size);
>  }
>
> +#define AMG88XX_REG_FPSC               0x02
> +#define AMG88XX_FPSC_1FPS              BIT(0)
> +
> +static int amg88xx_setup(struct video_i2c_data *data)
> +{
> +       unsigned int mask = AMG88XX_FPSC_1FPS;
> +       unsigned int val;
> +
> +       if (data->frame_interval.numerator == data->frame_interval.denominator)
> +               val = mask;
> +       else
> +               val = 0;
> +
> +       return regmap_update_bits(data->regmap, AMG88XX_REG_FPSC, mask, val);
> +}
> +
>  #if IS_ENABLED(CONFIG_HWMON)
>
>  static const u32 amg88xx_temp_config[] = {
> @@ -172,14 +194,21 @@ static int amg88xx_hwmon_init(struct video_i2c_data *data)
>
>  #define AMG88XX                0
>
> +static const struct v4l2_fract amg88xx_frame_intervals[] = {
> +       { 1, 10 },
> +       { 1, 1 },
> +};
> +
>  static const struct video_i2c_chip video_i2c_chip[] = {
>         [AMG88XX] = {
>                 .size           = &amg88xx_size,
>                 .format         = &amg88xx_format,
> -               .max_fps        = 10,
> +               .frame_intervals        = amg88xx_frame_intervals,
> +               .num_frame_intervals    = ARRAY_SIZE(amg88xx_frame_intervals),
>                 .buffer_size    = 128,
>                 .bpp            = 16,
>                 .regmap_config  = &amg88xx_regmap_config,
> +               .setup          = &amg88xx_setup,
>                 .xfer           = &amg88xx_xfer,
>                 .hwmon_init     = amg88xx_hwmon_init,
>         },
> @@ -244,7 +273,8 @@ static void buffer_queue(struct vb2_buffer *vb)
>  static int video_i2c_thread_vid_cap(void *priv)
>  {
>         struct video_i2c_data *data = priv;
> -       unsigned int delay = msecs_to_jiffies(1000 / data->chip->max_fps);
> +       unsigned int delay = mult_frac(HZ, data->frame_interval.numerator,
> +                                      data->frame_interval.denominator);
>
>         set_freezable();
>
> @@ -306,19 +336,26 @@ static void video_i2c_del_list(struct vb2_queue *vq, enum vb2_buffer_state state
>  static int start_streaming(struct vb2_queue *vq, unsigned int count)
>  {
>         struct video_i2c_data *data = vb2_get_drv_priv(vq);
> +       int ret;
>
>         if (data->kthread_vid_cap)
>                 return 0;
>
> +       ret = data->chip->setup(data);
> +       if (ret)
> +               goto error_del_list;
> +
>         data->sequence = 0;
>         data->kthread_vid_cap = kthread_run(video_i2c_thread_vid_cap, data,
>                                             "%s-vid-cap", data->v4l2_dev.name);
> -       if (!IS_ERR(data->kthread_vid_cap))
> +       ret = PTR_ERR_OR_ZERO(data->kthread_vid_cap);
> +       if (!ret)
>                 return 0;
>
> +error_del_list:
>         video_i2c_del_list(vq, VB2_BUF_STATE_QUEUED);
>
> -       return PTR_ERR(data->kthread_vid_cap);
> +       return ret;
>  }
>
>  static void stop_streaming(struct vb2_queue *vq)
> @@ -425,15 +462,14 @@ static int video_i2c_enum_frameintervals(struct file *file, void *priv,
>         const struct video_i2c_data *data = video_drvdata(file);
>         const struct v4l2_frmsize_discrete *size = data->chip->size;
>
> -       if (fe->index > 0)
> +       if (fe->index >= data->chip->num_frame_intervals)
>                 return -EINVAL;
>
>         if (fe->width != size->width || fe->height != size->height)
>                 return -EINVAL;
>
>         fe->type = V4L2_FRMIVAL_TYPE_DISCRETE;
> -       fe->discrete.numerator = 1;
> -       fe->discrete.denominator = data->chip->max_fps;
> +       fe->discrete = data->chip->frame_intervals[fe->index];
>
>         return 0;
>  }
> @@ -478,12 +514,26 @@ static int video_i2c_g_parm(struct file *filp, void *priv,
>
>         parm->parm.capture.readbuffers = 1;
>         parm->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
> -       parm->parm.capture.timeperframe.numerator = 1;
> -       parm->parm.capture.timeperframe.denominator = data->chip->max_fps;
> +       parm->parm.capture.timeperframe = data->frame_interval;
>
>         return 0;
>  }
>
> +static int video_i2c_s_parm(struct file *filp, void *priv,
> +                             struct v4l2_streamparm *parm)
> +{
> +       struct video_i2c_data *data = video_drvdata(filp);
> +       int n;
> +
> +       n = v4l2_find_closest_fract(parm->parm.capture.timeperframe,
> +                                   data->chip->frame_intervals,
> +                                   data->chip->num_frame_intervals);
> +
> +       data->frame_interval = data->chip->frame_intervals[n];
> +
> +       return video_i2c_g_parm(filp, priv, parm);
> +}
> +
>  static const struct v4l2_ioctl_ops video_i2c_ioctl_ops = {
>         .vidioc_querycap                = video_i2c_querycap,
>         .vidioc_g_input                 = video_i2c_g_input,
> @@ -495,7 +545,7 @@ static const struct v4l2_ioctl_ops video_i2c_ioctl_ops = {
>         .vidioc_g_fmt_vid_cap           = video_i2c_try_fmt_vid_cap,
>         .vidioc_s_fmt_vid_cap           = video_i2c_s_fmt_vid_cap,
>         .vidioc_g_parm                  = video_i2c_g_parm,
> -       .vidioc_s_parm                  = video_i2c_g_parm,
> +       .vidioc_s_parm                  = video_i2c_s_parm,
>         .vidioc_try_fmt_vid_cap         = video_i2c_try_fmt_vid_cap,
>         .vidioc_reqbufs                 = vb2_ioctl_reqbufs,
>         .vidioc_create_bufs             = vb2_ioctl_create_bufs,
> @@ -572,6 +622,8 @@ static int video_i2c_probe(struct i2c_client *client,
>         spin_lock_init(&data->slock);
>         INIT_LIST_HEAD(&data->vid_cap_active);
>
> +       data->frame_interval = data->chip->frame_intervals[0];
> +
>         video_set_drvdata(&data->vdev, data);
>         i2c_set_clientdata(client, data);
>
> --
> 2.7.4
>
