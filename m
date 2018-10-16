Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:47071 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbeJPW6z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Oct 2018 18:58:55 -0400
Received: by mail-pg1-f195.google.com with SMTP id a5-v6so10978180pgv.13
        for <linux-media@vger.kernel.org>; Tue, 16 Oct 2018 08:08:02 -0700 (PDT)
MIME-Version: 1.0
References: <1539453759-29976-1-git-send-email-akinobu.mita@gmail.com>
 <1539453759-29976-7-git-send-email-akinobu.mita@gmail.com> <20181015153112.sshgnv7un4mm6tav@paasikivi.fi.intel.com>
In-Reply-To: <20181015153112.sshgnv7un4mm6tav@paasikivi.fi.intel.com>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 17 Oct 2018 00:07:50 +0900
Message-ID: <CAC5umyjqz5rW9dnyCEeHVwvRe0LXXaKZQ-OLHFwCgZp2NwcPvA@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] media: video-i2c: support runtime PM
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018=E5=B9=B410=E6=9C=8816=E6=97=A5(=E7=81=AB) 0:31 Sakari Ailus <sakari.ai=
lus@linux.intel.com>:
>
> Hi Mita-san,
>
> On Sun, Oct 14, 2018 at 03:02:39AM +0900, Akinobu Mita wrote:
> > AMG88xx has a register for setting operating mode.  This adds support
> > runtime PM by changing the operating mode.
> >
> > The instruction for changing sleep mode to normal mode is from the
> > reference specifications.
> >
> > https://docid81hrs3j1.cloudfront.net/medialibrary/2017/11/PANA-S-A00021=
41979-1.pdf
> >
> > Cc: Matt Ranostay <matt.ranostay@konsulko.com>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: Hans Verkuil <hansverk@cisco.com>
> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Reviewed-by: Matt Ranostay <matt.ranostay@konsulko.com>
> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> > * v3
> > - Move chip->set_power() call to the video device release() callback.
> > - Add Acked-by line
> >
> >  drivers/media/i2c/video-i2c.c | 141 ++++++++++++++++++++++++++++++++++=
+++++++-
> >  1 file changed, 139 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2=
c.c
> > index 3334fc2..22fdc43 100644
> > --- a/drivers/media/i2c/video-i2c.c
> > +++ b/drivers/media/i2c/video-i2c.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/module.h>
> >  #include <linux/mutex.h>
> >  #include <linux/of_device.h>
> > +#include <linux/pm_runtime.h>
> >  #include <linux/regmap.h>
> >  #include <linux/sched.h>
> >  #include <linux/slab.h>
> > @@ -94,10 +95,23 @@ struct video_i2c_chip {
> >       /* xfer function */
> >       int (*xfer)(struct video_i2c_data *data, char *buf);
> >
> > +     /* power control function */
> > +     int (*set_power)(struct video_i2c_data *data, bool on);
> > +
> >       /* hwmon init function */
> >       int (*hwmon_init)(struct video_i2c_data *data);
> >  };
> >
> > +/* Power control register */
> > +#define AMG88XX_REG_PCTL     0x00
> > +#define AMG88XX_PCTL_NORMAL          0x00
> > +#define AMG88XX_PCTL_SLEEP           0x10
> > +
> > +/* Reset register */
> > +#define AMG88XX_REG_RST              0x01
> > +#define AMG88XX_RST_FLAG             0x30
> > +#define AMG88XX_RST_INIT             0x3f
> > +
> >  /* Frame rate register */
> >  #define AMG88XX_REG_FPSC     0x02
> >  #define AMG88XX_FPSC_1FPS            BIT(0)
> > @@ -127,6 +141,59 @@ static int amg88xx_setup(struct video_i2c_data *da=
ta)
> >       return regmap_update_bits(data->regmap, AMG88XX_REG_FPSC, mask, v=
al);
> >  }
> >
> > +static int amg88xx_set_power_on(struct video_i2c_data *data)
> > +{
> > +     int ret;
> > +
> > +     ret =3D regmap_write(data->regmap, AMG88XX_REG_PCTL, AMG88XX_PCTL=
_NORMAL);
> > +     if (ret)
> > +             return ret;
> > +
> > +     msleep(50);
> > +
> > +     ret =3D regmap_write(data->regmap, AMG88XX_REG_RST, AMG88XX_RST_I=
NIT);
> > +     if (ret)
> > +             return ret;
> > +
> > +     msleep(2);
> > +
> > +     ret =3D regmap_write(data->regmap, AMG88XX_REG_RST, AMG88XX_RST_F=
LAG);
> > +     if (ret)
> > +             return ret;
> > +
> > +     /*
> > +      * Wait two frames before reading thermistor and temperature regi=
sters
> > +      */
> > +     msleep(200);
> > +
> > +     return 0;
> > +}
> > +
> > +static int amg88xx_set_power_off(struct video_i2c_data *data)
> > +{
> > +     int ret;
> > +
> > +     ret =3D regmap_write(data->regmap, AMG88XX_REG_PCTL, AMG88XX_PCTL=
_SLEEP);
> > +     if (ret)
> > +             return ret;
> > +     /*
> > +      * Wait for a while to avoid resuming normal mode immediately aft=
er
> > +      * entering sleep mode, otherwise the device occasionally goes wr=
ong
> > +      * (thermistor and temperature registers are not updated at all)
> > +      */
> > +     msleep(100);
> > +
> > +     return 0;
> > +}
> > +
> > +static int amg88xx_set_power(struct video_i2c_data *data, bool on)
> > +{
> > +     if (on)
> > +             return amg88xx_set_power_on(data);
> > +
> > +     return amg88xx_set_power_off(data);
> > +}
> > +
> >  #if IS_ENABLED(CONFIG_HWMON)
> >
> >  static const u32 amg88xx_temp_config[] =3D {
> > @@ -158,7 +225,15 @@ static int amg88xx_read(struct device *dev, enum h=
wmon_sensor_types type,
> >       __le16 buf;
> >       int tmp;
> >
> > +     tmp =3D pm_runtime_get_sync(regmap_get_device(data->regmap));
> > +     if (tmp < 0) {
> > +             pm_runtime_put_noidle(regmap_get_device(data->regmap));
> > +             return tmp;
> > +     }
> > +
> >       tmp =3D regmap_bulk_read(data->regmap, AMG88XX_REG_TTHL, &buf, 2)=
;
> > +     pm_runtime_mark_last_busy(regmap_get_device(data->regmap));
> > +     pm_runtime_put_autosuspend(regmap_get_device(data->regmap));
> >       if (tmp)
> >               return tmp;
> >
> > @@ -217,6 +292,7 @@ static const struct video_i2c_chip video_i2c_chip[]=
 =3D {
> >               .regmap_config  =3D &amg88xx_regmap_config,
> >               .setup          =3D &amg88xx_setup,
> >               .xfer           =3D &amg88xx_xfer,
> > +             .set_power      =3D amg88xx_set_power,
> >               .hwmon_init     =3D amg88xx_hwmon_init,
> >       },
> >  };
> > @@ -343,14 +419,21 @@ static void video_i2c_del_list(struct vb2_queue *=
vq, enum vb2_buffer_state state
> >  static int start_streaming(struct vb2_queue *vq, unsigned int count)
> >  {
> >       struct video_i2c_data *data =3D vb2_get_drv_priv(vq);
> > +     struct device *dev =3D regmap_get_device(data->regmap);
> >       int ret;
> >
> >       if (data->kthread_vid_cap)
> >               return 0;
> >
> > +     ret =3D pm_runtime_get_sync(dev);
> > +     if (ret < 0) {
> > +             pm_runtime_put_noidle(dev);
> > +             goto error_del_list;
> > +     }
> > +
> >       ret =3D data->chip->setup(data);
> >       if (ret)
> > -             goto error_del_list;
> > +             goto error_rpm_put;
> >
> >       data->sequence =3D 0;
> >       data->kthread_vid_cap =3D kthread_run(video_i2c_thread_vid_cap, d=
ata,
> > @@ -359,6 +442,9 @@ static int start_streaming(struct vb2_queue *vq, un=
signed int count)
> >       if (!ret)
> >               return 0;
> >
> > +error_rpm_put:
> > +     pm_runtime_mark_last_busy(dev);
> > +     pm_runtime_put_autosuspend(dev);
> >  error_del_list:
> >       video_i2c_del_list(vq, VB2_BUF_STATE_QUEUED);
> >
> > @@ -374,6 +460,8 @@ static void stop_streaming(struct vb2_queue *vq)
> >
> >       kthread_stop(data->kthread_vid_cap);
> >       data->kthread_vid_cap =3D NULL;
> > +     pm_runtime_mark_last_busy(regmap_get_device(data->regmap));
> > +     pm_runtime_put_autosuspend(regmap_get_device(data->regmap));
> >
> >       video_i2c_del_list(vq, VB2_BUF_STATE_ERROR);
> >  }
> > @@ -569,6 +657,7 @@ static void video_i2c_release(struct video_device *=
vdev)
> >  {
> >       struct video_i2c_data *data =3D video_get_drvdata(vdev);
> >
> > +     data->chip->set_power(data, false);
> >       v4l2_device_unregister(&data->v4l2_dev);
> >       mutex_destroy(&data->lock);
> >       mutex_destroy(&data->queue_lock);
> > @@ -648,6 +737,16 @@ static int video_i2c_probe(struct i2c_client *clie=
nt,
> >       video_set_drvdata(&data->vdev, data);
> >       i2c_set_clientdata(client, data);
> >
> > +     ret =3D data->chip->set_power(data, true);
> > +     if (ret)
> > +             goto error_unregister_device;
> > +
> > +     pm_runtime_get_noresume(&client->dev);
> > +     pm_runtime_set_active(&client->dev);
> > +     pm_runtime_enable(&client->dev);
> > +     pm_runtime_set_autosuspend_delay(&client->dev, 2000);
> > +     pm_runtime_use_autosuspend(&client->dev);
> > +
> >       if (data->chip->hwmon_init) {
> >               ret =3D data->chip->hwmon_init(data);
> >               if (ret < 0) {
> > @@ -658,10 +757,19 @@ static int video_i2c_probe(struct i2c_client *cli=
ent,
> >
> >       ret =3D video_register_device(&data->vdev, VFL_TYPE_GRABBER, -1);
> >       if (ret < 0)
> > -             goto error_unregister_device;
> > +             goto error_pm_disable;
> > +
> > +     pm_runtime_mark_last_busy(&client->dev);
> > +     pm_runtime_put_autosuspend(&client->dev);
> >
> >       return 0;
> >
> > +error_pm_disable:
> > +     pm_runtime_disable(&client->dev);
> > +     pm_runtime_set_suspended(&client->dev);
> > +     pm_runtime_put_noidle(&client->dev);
> > +     data->chip->set_power(data, false);
> > +
> >  error_unregister_device:
> >       v4l2_device_unregister(v4l2_dev);
> >       mutex_destroy(&data->lock);
> > @@ -680,11 +788,39 @@ static int video_i2c_remove(struct i2c_client *cl=
ient)
> >  {
> >       struct video_i2c_data *data =3D i2c_get_clientdata(client);
> >
> > +     pm_runtime_get_sync(&client->dev);
> > +     pm_runtime_disable(&client->dev);
> > +     pm_runtime_set_suspended(&client->dev);
> > +     pm_runtime_put_noidle(&client->dev);
>
> The release callback exists so you can release the allocated resources, b=
ut
> the I=E6=B6=8E transactions need to cease after that. So you should call =
the
> set_power() callback here instead --- as you do in probe() function's err=
or
> handling.

Hi Sakari,

The set_power() callback is called in video_i2c_release() release
callback in this patch, so it should be the last I2C transaction.

case a.1)  When the driver is unbound, no users grab a file handle.

video_i2c_remove
 |
 -> pm_runtime_*
 -> video_unregister_device
     :
     -> video_i2c_release
         |
         -> data->chip->set_power
         -> v4l2_device_unregister
         -> mutex_destroy
         -> regmap_exit(data->regmap);
         -> kfree

case a.2)  When the driver is unbound, some users grab a file handle.

video_i2c_remove
 |
 -> pm_runtime_*
 -> video_unregister_device

<All users ungrab a file handle>

video_i2c_release
 |
 -> data->chip->set_power
 -> v4l2_device_unregister
 -> mutex_destroy
 -> regmap_exit(data->regmap);
 -> kfree

If the set_power() callback is moved to video_i2c_remove() as you
suggested, it doesn't ensure set_power() callback is the last I2C
transaction in case b.2), does it?

case b.1)  When the driver is unbound, no users grab a file handle.

video_i2c_remove
 |
 -> pm_runtime_*
 -> data->chip->set_power
 -> video_unregister_device
     :
     -> video_i2c_release
         |
         -> v4l2_device_unregister
         -> mutex_destroy
         -> regmap_exit(data->regmap);
         -> kfree

case b.2)  When the driver is unbound, some users grab a file handle.

video_i2c_remove
 |
 -> pm_runtime_*
 -> data->chip->set_power
 -> video_unregister_device

<All users ungrab a file handle>

video_i2c_release
 |
 -> v4l2_device_unregister
 -> mutex_destroy
 -> regmap_exit(data->regmap);
 -> kfree
