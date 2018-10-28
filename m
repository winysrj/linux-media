Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34247 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727762AbeJ1MWi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 Oct 2018 08:22:38 -0400
Received: by mail-pg1-f193.google.com with SMTP id k1-v6so870517pgq.1
        for <linux-media@vger.kernel.org>; Sat, 27 Oct 2018 20:39:21 -0700 (PDT)
MIME-Version: 1.0
References: <1540045588-9091-1-git-send-email-akinobu.mita@gmail.com> <1540045588-9091-6-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1540045588-9091-6-git-send-email-akinobu.mita@gmail.com>
From: Matt Ranostay <matt.ranostay@konsulko.com>
Date: Sat, 27 Oct 2018 20:39:10 -0700
Message-ID: <CAJCx=gm46oXQS=hGZw2zK1N=tx_Y11BuKn-xhda7F8gARbHmhg@mail.gmail.com>
Subject: Re: [PATCH v4 5/6] media: video-i2c: support changing frame interval
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        Hans Verkuil <hansverk@cisco.com>, mchehab@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 20, 2018 at 7:26 AM Akinobu Mita <akinobu.mita@gmail.com> wrote:
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
> Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> * v4
> - No changes from v3
>
>  drivers/media/i2c/video-i2c.c | 78 ++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 66 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
> index f23cb91..3334fc2 100644
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
> @@ -92,6 +98,10 @@ struct video_i2c_chip {
>         int (*hwmon_init)(struct video_i2c_data *data);
>  };
>
> +/* Frame rate register */
> +#define AMG88XX_REG_FPSC       0x02
> +#define AMG88XX_FPSC_1FPS              BIT(0)
> +
>  /* Thermistor register */
>  #define AMG88XX_REG_TTHL       0x0e
>
> @@ -104,6 +114,19 @@ static int amg88xx_xfer(struct video_i2c_data *data, char *buf)
>                                 data->chip->buffer_size);
>  }
>
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
> @@ -178,14 +201,21 @@ static int amg88xx_hwmon_init(struct video_i2c_data *data)
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
> @@ -250,7 +280,8 @@ static void buffer_queue(struct vb2_buffer *vb)
>  static int video_i2c_thread_vid_cap(void *priv)
>  {
>         struct video_i2c_data *data = priv;
> -       unsigned int delay = msecs_to_jiffies(1000 / data->chip->max_fps);
> +       unsigned int delay = mult_frac(HZ, data->frame_interval.numerator,
> +                                      data->frame_interval.denominator);
>
>         set_freezable();
>
> @@ -312,19 +343,26 @@ static void video_i2c_del_list(struct vb2_queue *vq, enum vb2_buffer_state state
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
> @@ -431,15 +469,14 @@ static int video_i2c_enum_frameintervals(struct file *file, void *priv,
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
> @@ -484,12 +521,27 @@ static int video_i2c_g_parm(struct file *filp, void *priv,
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
> +       int i;
> +
> +       for (i = 0; i < data->chip->num_frame_intervals - 1; i++) {

Just noticed this when testing for another thermal camera.

Why is this "i < data->chip->num_frame_intervals - 1" and not just "i
< data->chip->num_frame_intervals"?
It won't ever check the last possible frame interval in the respective
array as written.

- Matt

> +               if (V4L2_FRACT_COMPARE(parm->parm.capture.timeperframe, <=,
> +                                      data->chip->frame_intervals[i]))
> +                       break;
> +       }
> +       data->frame_interval = data->chip->frame_intervals[i];
> +
> +       return video_i2c_g_parm(filp, priv, parm);
> +}
> +
>  static const struct v4l2_ioctl_ops video_i2c_ioctl_ops = {
>         .vidioc_querycap                = video_i2c_querycap,
>         .vidioc_g_input                 = video_i2c_g_input,
> @@ -501,7 +553,7 @@ static const struct v4l2_ioctl_ops video_i2c_ioctl_ops = {
>         .vidioc_g_fmt_vid_cap           = video_i2c_try_fmt_vid_cap,
>         .vidioc_s_fmt_vid_cap           = video_i2c_s_fmt_vid_cap,
>         .vidioc_g_parm                  = video_i2c_g_parm,
> -       .vidioc_s_parm                  = video_i2c_g_parm,
> +       .vidioc_s_parm                  = video_i2c_s_parm,
>         .vidioc_try_fmt_vid_cap         = video_i2c_try_fmt_vid_cap,
>         .vidioc_reqbufs                 = vb2_ioctl_reqbufs,
>         .vidioc_create_bufs             = vb2_ioctl_create_bufs,
> @@ -591,6 +643,8 @@ static int video_i2c_probe(struct i2c_client *client,
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
