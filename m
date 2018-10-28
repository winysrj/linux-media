Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41114 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727729AbeJ2BHG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 Oct 2018 21:07:06 -0400
Received: by mail-pg1-f194.google.com with SMTP id 23-v6so2701632pgc.8
        for <linux-media@vger.kernel.org>; Sun, 28 Oct 2018 09:22:03 -0700 (PDT)
MIME-Version: 1.0
References: <1540045588-9091-1-git-send-email-akinobu.mita@gmail.com>
 <1540045588-9091-6-git-send-email-akinobu.mita@gmail.com> <CAJCx=gm46oXQS=hGZw2zK1N=tx_Y11BuKn-xhda7F8gARbHmhg@mail.gmail.com>
In-Reply-To: <CAJCx=gm46oXQS=hGZw2zK1N=tx_Y11BuKn-xhda7F8gARbHmhg@mail.gmail.com>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Mon, 29 Oct 2018 01:21:51 +0900
Message-ID: <CAC5umyhBn+5+S7jgi+NGoLtfeykMaDB=rXOr7Ko8oV64AVddkg@mail.gmail.com>
Subject: Re: [PATCH v4 5/6] media: video-i2c: support changing frame interval
To: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018=E5=B9=B410=E6=9C=8828=E6=97=A5(=E6=97=A5) 12:39 Matt Ranostay <matt.ra=
nostay@konsulko.com>:
>
> On Sat, Oct 20, 2018 at 7:26 AM Akinobu Mita <akinobu.mita@gmail.com> wro=
te:
> >
> > AMG88xx has a register for setting frame rate 1 or 10 FPS.
> > This adds support changing frame interval.
> >
> > Reference specifications:
> > https://docid81hrs3j1.cloudfront.net/medialibrary/2017/11/PANA-S-A00021=
41979-1.pdf
> >
> > Cc: Matt Ranostay <matt.ranostay@konsulko.com>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: Hans Verkuil <hansverk@cisco.com>
> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>
> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> > * v4
> > - No changes from v3
> >
> >  drivers/media/i2c/video-i2c.c | 78 +++++++++++++++++++++++++++++++++++=
+-------
> >  1 file changed, 66 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2=
c.c
> > index f23cb91..3334fc2 100644
> > --- a/drivers/media/i2c/video-i2c.c
> > +++ b/drivers/media/i2c/video-i2c.c
> > @@ -52,6 +52,8 @@ struct video_i2c_data {
> >
> >         struct task_struct *kthread_vid_cap;
> >         struct list_head vid_cap_active;
> > +
> > +       struct v4l2_fract frame_interval;
> >  };
> >
> >  static const struct v4l2_fmtdesc amg88xx_format =3D {
> > @@ -74,8 +76,9 @@ struct video_i2c_chip {
> >         const struct v4l2_fmtdesc *format;
> >         const struct v4l2_frmsize_discrete *size;
> >
> > -       /* max frames per second */
> > -       unsigned int max_fps;
> > +       /* available frame intervals */
> > +       const struct v4l2_fract *frame_intervals;
> > +       unsigned int num_frame_intervals;
> >
> >         /* pixel buffer size */
> >         unsigned int buffer_size;
> > @@ -85,6 +88,9 @@ struct video_i2c_chip {
> >
> >         const struct regmap_config *regmap_config;
> >
> > +       /* setup function */
> > +       int (*setup)(struct video_i2c_data *data);
> > +
> >         /* xfer function */
> >         int (*xfer)(struct video_i2c_data *data, char *buf);
> >
> > @@ -92,6 +98,10 @@ struct video_i2c_chip {
> >         int (*hwmon_init)(struct video_i2c_data *data);
> >  };
> >
> > +/* Frame rate register */
> > +#define AMG88XX_REG_FPSC       0x02
> > +#define AMG88XX_FPSC_1FPS              BIT(0)
> > +
> >  /* Thermistor register */
> >  #define AMG88XX_REG_TTHL       0x0e
> >
> > @@ -104,6 +114,19 @@ static int amg88xx_xfer(struct video_i2c_data *dat=
a, char *buf)
> >                                 data->chip->buffer_size);
> >  }
> >
> > +static int amg88xx_setup(struct video_i2c_data *data)
> > +{
> > +       unsigned int mask =3D AMG88XX_FPSC_1FPS;
> > +       unsigned int val;
> > +
> > +       if (data->frame_interval.numerator =3D=3D data->frame_interval.=
denominator)
> > +               val =3D mask;
> > +       else
> > +               val =3D 0;
> > +
> > +       return regmap_update_bits(data->regmap, AMG88XX_REG_FPSC, mask,=
 val);
> > +}
> > +
> >  #if IS_ENABLED(CONFIG_HWMON)
> >
> >  static const u32 amg88xx_temp_config[] =3D {
> > @@ -178,14 +201,21 @@ static int amg88xx_hwmon_init(struct video_i2c_da=
ta *data)
> >
> >  #define AMG88XX                0
> >
> > +static const struct v4l2_fract amg88xx_frame_intervals[] =3D {
> > +       { 1, 10 },
> > +       { 1, 1 },
> > +};
> > +
> >  static const struct video_i2c_chip video_i2c_chip[] =3D {
> >         [AMG88XX] =3D {
> >                 .size           =3D &amg88xx_size,
> >                 .format         =3D &amg88xx_format,
> > -               .max_fps        =3D 10,
> > +               .frame_intervals        =3D amg88xx_frame_intervals,
> > +               .num_frame_intervals    =3D ARRAY_SIZE(amg88xx_frame_in=
tervals),
> >                 .buffer_size    =3D 128,
> >                 .bpp            =3D 16,
> >                 .regmap_config  =3D &amg88xx_regmap_config,
> > +               .setup          =3D &amg88xx_setup,
> >                 .xfer           =3D &amg88xx_xfer,
> >                 .hwmon_init     =3D amg88xx_hwmon_init,
> >         },
> > @@ -250,7 +280,8 @@ static void buffer_queue(struct vb2_buffer *vb)
> >  static int video_i2c_thread_vid_cap(void *priv)
> >  {
> >         struct video_i2c_data *data =3D priv;
> > -       unsigned int delay =3D msecs_to_jiffies(1000 / data->chip->max_=
fps);
> > +       unsigned int delay =3D mult_frac(HZ, data->frame_interval.numer=
ator,
> > +                                      data->frame_interval.denominator=
);
> >
> >         set_freezable();
> >
> > @@ -312,19 +343,26 @@ static void video_i2c_del_list(struct vb2_queue *=
vq, enum vb2_buffer_state state
> >  static int start_streaming(struct vb2_queue *vq, unsigned int count)
> >  {
> >         struct video_i2c_data *data =3D vb2_get_drv_priv(vq);
> > +       int ret;
> >
> >         if (data->kthread_vid_cap)
> >                 return 0;
> >
> > +       ret =3D data->chip->setup(data);
> > +       if (ret)
> > +               goto error_del_list;
> > +
> >         data->sequence =3D 0;
> >         data->kthread_vid_cap =3D kthread_run(video_i2c_thread_vid_cap,=
 data,
> >                                             "%s-vid-cap", data->v4l2_de=
v.name);
> > -       if (!IS_ERR(data->kthread_vid_cap))
> > +       ret =3D PTR_ERR_OR_ZERO(data->kthread_vid_cap);
> > +       if (!ret)
> >                 return 0;
> >
> > +error_del_list:
> >         video_i2c_del_list(vq, VB2_BUF_STATE_QUEUED);
> >
> > -       return PTR_ERR(data->kthread_vid_cap);
> > +       return ret;
> >  }
> >
> >  static void stop_streaming(struct vb2_queue *vq)
> > @@ -431,15 +469,14 @@ static int video_i2c_enum_frameintervals(struct f=
ile *file, void *priv,
> >         const struct video_i2c_data *data =3D video_drvdata(file);
> >         const struct v4l2_frmsize_discrete *size =3D data->chip->size;
> >
> > -       if (fe->index > 0)
> > +       if (fe->index >=3D data->chip->num_frame_intervals)
> >                 return -EINVAL;
> >
> >         if (fe->width !=3D size->width || fe->height !=3D size->height)
> >                 return -EINVAL;
> >
> >         fe->type =3D V4L2_FRMIVAL_TYPE_DISCRETE;
> > -       fe->discrete.numerator =3D 1;
> > -       fe->discrete.denominator =3D data->chip->max_fps;
> > +       fe->discrete =3D data->chip->frame_intervals[fe->index];
> >
> >         return 0;
> >  }
> > @@ -484,12 +521,27 @@ static int video_i2c_g_parm(struct file *filp, vo=
id *priv,
> >
> >         parm->parm.capture.readbuffers =3D 1;
> >         parm->parm.capture.capability =3D V4L2_CAP_TIMEPERFRAME;
> > -       parm->parm.capture.timeperframe.numerator =3D 1;
> > -       parm->parm.capture.timeperframe.denominator =3D data->chip->max=
_fps;
> > +       parm->parm.capture.timeperframe =3D data->frame_interval;
> >
> >         return 0;
> >  }
> >
> > +static int video_i2c_s_parm(struct file *filp, void *priv,
> > +                             struct v4l2_streamparm *parm)
> > +{
> > +       struct video_i2c_data *data =3D video_drvdata(filp);
> > +       int i;
> > +
> > +       for (i =3D 0; i < data->chip->num_frame_intervals - 1; i++) {
>
> Just noticed this when testing for another thermal camera.
>
> Why is this "i < data->chip->num_frame_intervals - 1" and not just "i
> < data->chip->num_frame_intervals"?
> It won't ever check the last possible frame interval in the respective
> array as written.

It is just unnecessary to check the last entry, because the array
must be sorted in ascending order.

If it checks the last entry, the code will be more redundant like below.

for (i =3D 0; i < data->chip->num_frame_intervals; i++) {
        if (V4L2_FRACT_COMPARE(parm->parm.capture.timeperframe, <=3D,
                        data->chip->frame_intervals[i]))
                break;
}
if (i =3D=3D data->chip->num_frame_intervals)
        i =3D data->chip->num_frame_intervals - 1;

data->frame_interval =3D data->chip->frame_intervals[i];

> > +               if (V4L2_FRACT_COMPARE(parm->parm.capture.timeperframe,=
 <=3D,
> > +                                      data->chip->frame_intervals[i]))
> > +                       break;
> > +       }
> > +       data->frame_interval =3D data->chip->frame_intervals[i];
> > +
> > +       return video_i2c_g_parm(filp, priv, parm);
> > +}
> > +
> >  static const struct v4l2_ioctl_ops video_i2c_ioctl_ops =3D {
> >         .vidioc_querycap                =3D video_i2c_querycap,
> >         .vidioc_g_input                 =3D video_i2c_g_input,
> > @@ -501,7 +553,7 @@ static const struct v4l2_ioctl_ops video_i2c_ioctl_=
ops =3D {
> >         .vidioc_g_fmt_vid_cap           =3D video_i2c_try_fmt_vid_cap,
> >         .vidioc_s_fmt_vid_cap           =3D video_i2c_s_fmt_vid_cap,
> >         .vidioc_g_parm                  =3D video_i2c_g_parm,
> > -       .vidioc_s_parm                  =3D video_i2c_g_parm,
> > +       .vidioc_s_parm                  =3D video_i2c_s_parm,
> >         .vidioc_try_fmt_vid_cap         =3D video_i2c_try_fmt_vid_cap,
> >         .vidioc_reqbufs                 =3D vb2_ioctl_reqbufs,
> >         .vidioc_create_bufs             =3D vb2_ioctl_create_bufs,
> > @@ -591,6 +643,8 @@ static int video_i2c_probe(struct i2c_client *clien=
t,
> >         spin_lock_init(&data->slock);
> >         INIT_LIST_HEAD(&data->vid_cap_active);
> >
> > +       data->frame_interval =3D data->chip->frame_intervals[0];
> > +
> >         video_set_drvdata(&data->vdev, data);
> >         i2c_set_clientdata(client, data);
> >
> > --
> > 2.7.4
> >
