Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37695 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727756AbeIRTvd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 15:51:33 -0400
Received: by mail-pl1-f195.google.com with SMTP id f1-v6so1082187plt.4
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2018 07:18:44 -0700 (PDT)
MIME-Version: 1.0
References: <1537200191-17956-1-git-send-email-akinobu.mita@gmail.com>
 <1537200191-17956-6-git-send-email-akinobu.mita@gmail.com> <CAJCx=gm1KAcgAtG40R-AtSjRuhfXJ_S-x9=a2op+FPZ1nJfKxQ@mail.gmail.com>
In-Reply-To: <CAJCx=gm1KAcgAtG40R-AtSjRuhfXJ_S-x9=a2op+FPZ1nJfKxQ@mail.gmail.com>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Tue, 18 Sep 2018 23:18:32 +0900
Message-ID: <CAC5umyjLNBm+62KfQjX-DO=4+zRzvu9fsz04M4gCZ=NcY34Lkg@mail.gmail.com>
Subject: Re: [PATCH 5/5] media: video-i2c: support runtime PM
To: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018=E5=B9=B49=E6=9C=8818=E6=97=A5(=E7=81=AB) 15:23 Matt Ranostay <matt.ran=
ostay@konsulko.com>:
>
> On Mon, Sep 17, 2018 at 6:03 PM Akinobu Mita <akinobu.mita@gmail.com> wro=
te:
> >
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
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> >  drivers/media/i2c/video-i2c.c | 140 ++++++++++++++++++++++++++++++++++=
+++++++-
> >  1 file changed, 138 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2=
c.c
> > index 916f36e..93822f4 100644
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
> > @@ -94,6 +95,9 @@ struct video_i2c_chip {
> >         /* xfer function */
> >         int (*xfer)(struct video_i2c_data *data, char *buf);
> >
> > +       /* power control function */
> > +       int (*set_power)(struct video_i2c_data *data, bool on);
> > +
> >         /* hwmon init function */
> >         int (*hwmon_init)(struct video_i2c_data *data);
> >  };
> > @@ -104,6 +108,14 @@ static int amg88xx_xfer(struct video_i2c_data *dat=
a, char *buf)
> >                                 data->chip->buffer_size);
> >  }
> >
> > +#define AMG88XX_REG_PCTL               0x00
> > +#define AMG88XX_PCTL_NORMAL            0x00
> > +#define AMG88XX_PCTL_SLEEP             0x10
> > +
> > +#define AMG88XX_REG_RST                        0x01
> > +#define AMG88XX_RST_FLAG               0x30
> > +#define AMG88XX_RST_INIT               0x3f
> > +
> >  #define AMG88XX_REG_FPSC               0x02
> >  #define AMG88XX_FPSC_1FPS              BIT(0)
> >
> > @@ -120,6 +132,59 @@ static int amg88xx_setup(struct video_i2c_data *da=
ta)
> >         return regmap_update_bits(data->regmap, AMG88XX_REG_FPSC, mask,=
 val);
> >  }
> >
> > +static int amg88xx_set_power_on(struct video_i2c_data *data)
> > +{
> > +       int ret;
> > +
> > +       ret =3D regmap_write(data->regmap, AMG88XX_REG_PCTL, AMG88XX_PC=
TL_NORMAL);
> > +       if (ret)
> > +               return ret;
> > +
> > +       msleep(50);
> > +
> > +       ret =3D regmap_write(data->regmap, AMG88XX_REG_RST, AMG88XX_RST=
_INIT);
> > +       if (ret)
> > +               return ret;
> > +
> > +       msleep(2);
> > +
> > +       ret =3D regmap_write(data->regmap, AMG88XX_REG_RST, AMG88XX_RST=
_FLAG);
> > +       if (ret)
> > +               return ret;
> > +
> > +       /*
> > +        * Wait two frames before reading thermistor and temperature re=
gisters
> > +        */
> > +       msleep(200);
> > +
> > +       return 0;
> > +}
> > +
> > +static int amg88xx_set_power_off(struct video_i2c_data *data)
> > +{
> > +       int ret;
> > +
> > +       ret =3D regmap_write(data->regmap, AMG88XX_REG_PCTL, AMG88XX_PC=
TL_SLEEP);
> > +       if (ret)
> > +               return ret;
> > +       /*
> > +        * Wait for a while to avoid resuming normal mode immediately a=
fter
> > +        * entering sleep mode, otherwise the device occasionally goes =
wrong
> > +        * (thermistor and temperature registers are not updated at all=
)
> > +        */
> > +       msleep(100);
> > +
> > +       return 0;
> > +}
> > +
> > +static int amg88xx_set_power(struct video_i2c_data *data, bool on)
> > +{
> > +       if (on)
> > +               return amg88xx_set_power_on(data);
> > +
> > +       return amg88xx_set_power_off(data);
> > +}
> > +
> >  #if IS_ENABLED(CONFIG_HWMON)
> >
> >  static const u32 amg88xx_temp_config[] =3D {
> > @@ -151,7 +216,15 @@ static int amg88xx_read(struct device *dev, enum h=
wmon_sensor_types type,
> >         __le16 buf;
> >         int tmp;
> >
> > +       tmp =3D pm_runtime_get_sync(regmap_get_device(data->regmap));
> > +       if (tmp < 0) {
> > +               pm_runtime_put_noidle(regmap_get_device(data->regmap));
> > +               return tmp;
> > +       }
> > +
> >         tmp =3D regmap_bulk_read(data->regmap, 0x0e, &buf, 2);
> > +       pm_runtime_mark_last_busy(regmap_get_device(data->regmap));
> > +       pm_runtime_put_autosuspend(regmap_get_device(data->regmap));
> >         if (tmp)
> >                 return tmp;
> >
> > @@ -210,6 +283,7 @@ static const struct video_i2c_chip video_i2c_chip[]=
 =3D {
> >                 .regmap_config  =3D &amg88xx_regmap_config,
> >                 .setup          =3D &amg88xx_setup,
> >                 .xfer           =3D &amg88xx_xfer,
> > +               .set_power      =3D amg88xx_set_power,
> >                 .hwmon_init     =3D amg88xx_hwmon_init,
> >         },
> >  };
> > @@ -336,14 +410,21 @@ static void video_i2c_del_list(struct vb2_queue *=
vq, enum vb2_buffer_state state
> >  static int start_streaming(struct vb2_queue *vq, unsigned int count)
> >  {
> >         struct video_i2c_data *data =3D vb2_get_drv_priv(vq);
> > +       struct device *dev =3D regmap_get_device(data->regmap);
> >         int ret;
> >
> >         if (data->kthread_vid_cap)
> >                 return 0;
> >
> > +       ret =3D pm_runtime_get_sync(dev);
> > +       if (ret < 0) {
> > +               pm_runtime_put_noidle(dev);
> > +               goto error_del_list;
> > +       }
> > +
> >         ret =3D data->chip->setup(data);
> >         if (ret)
> > -               goto error_del_list;
> > +               goto error_rpm_put;
> >
> >         data->sequence =3D 0;
> >         data->kthread_vid_cap =3D kthread_run(video_i2c_thread_vid_cap,=
 data,
> > @@ -352,6 +433,9 @@ static int start_streaming(struct vb2_queue *vq, un=
signed int count)
> >         if (!ret)
> >                 return 0;
> >
> > +error_rpm_put:
> > +       pm_runtime_mark_last_busy(dev);
> > +       pm_runtime_put_autosuspend(dev);
> >  error_del_list:
> >         video_i2c_del_list(vq, VB2_BUF_STATE_QUEUED);
> >
> > @@ -367,6 +451,8 @@ static void stop_streaming(struct vb2_queue *vq)
> >
> >         kthread_stop(data->kthread_vid_cap);
> >         data->kthread_vid_cap =3D NULL;
> > +       pm_runtime_mark_last_busy(regmap_get_device(data->regmap));
> > +       pm_runtime_put_autosuspend(regmap_get_device(data->regmap));
> >
> >         video_i2c_del_list(vq, VB2_BUF_STATE_ERROR);
> >  }
> > @@ -627,6 +713,18 @@ static int video_i2c_probe(struct i2c_client *clie=
nt,
> >         video_set_drvdata(&data->vdev, data);
> >         i2c_set_clientdata(client, data);
> >
> > +       ret =3D data->chip->set_power(data, true);
> > +       if (ret)
> > +               goto error_unregister_device;
> > +
> > +       pm_runtime_get_noresume(&client->dev);
> > +       pm_runtime_set_active(&client->dev);
> > +       pm_runtime_enable(&client->dev);
> > +       pm_runtime_set_autosuspend_delay(&client->dev, 2000);
>
> 2 seconds arbitrary for runtime suspending? I could be blind (or that
> I can't read the part English + Japanese datasheet) but not sure how
> much power is saved in low-power mode.

According to 4-4) Detection characteristics,

Normal mode: Typ. 4.5 mA
Sleep mode: Typ. 0.2 mA

I arbitrarily selected 2 seconds for runtime suspending as it can be config=
ured
to any value through sysfs interface.

> In any case looks fine to me.
>
> - Matt
>
> Reviewed-by: Matt Ranostay <matt.ranostay@konsulko.com>
>
> > +       pm_runtime_use_autosuspend(&client->dev);
> > +       pm_runtime_mark_last_busy(&client->dev);
> > +       pm_runtime_put_autosuspend(&client->dev);
> > +
> >         if (data->chip->hwmon_init) {
> >                 ret =3D data->chip->hwmon_init(data);
> >                 if (ret < 0) {
> > @@ -637,10 +735,17 @@ static int video_i2c_probe(struct i2c_client *cli=
ent,
> >
> >         ret =3D video_register_device(&data->vdev, VFL_TYPE_GRABBER, -1=
);
> >         if (ret < 0)
> > -               goto error_unregister_device;
> > +               goto error_pm_disable;
> >
> >         return 0;
> >
> > +error_pm_disable:
> > +       pm_runtime_get_sync(&client->dev);
> > +       pm_runtime_disable(&client->dev);
> > +       pm_runtime_set_suspended(&client->dev);
> > +       pm_runtime_put_noidle(&client->dev);
> > +       data->chip->set_power(data, false);
> > +
> >  error_unregister_device:
> >         v4l2_device_unregister(v4l2_dev);
> >         mutex_destroy(&data->lock);
> > @@ -654,6 +759,13 @@ static int video_i2c_remove(struct i2c_client *cli=
ent)
> >         struct video_i2c_data *data =3D i2c_get_clientdata(client);
> >
> >         video_unregister_device(&data->vdev);
> > +
> > +       pm_runtime_get_sync(&client->dev);
> > +       pm_runtime_disable(&client->dev);
> > +       pm_runtime_set_suspended(&client->dev);
> > +       pm_runtime_put_noidle(&client->dev);
> > +       data->chip->set_power(data, false);
> > +
> >         v4l2_device_unregister(&data->v4l2_dev);
> >
> >         mutex_destroy(&data->lock);
> > @@ -662,6 +774,29 @@ static int video_i2c_remove(struct i2c_client *cli=
ent)
> >         return 0;
> >  }
> >
> > +#ifdef CONFIG_PM
> > +
> > +static int video_i2c_pm_runtime_suspend(struct device *dev)
> > +{
> > +       struct video_i2c_data *data =3D i2c_get_clientdata(to_i2c_clien=
t(dev));
> > +
> > +       return data->chip->set_power(data, false);
> > +}
> > +
> > +static int video_i2c_pm_runtime_resume(struct device *dev)
> > +{
> > +       struct video_i2c_data *data =3D i2c_get_clientdata(to_i2c_clien=
t(dev));
> > +
> > +       return data->chip->set_power(data, true);
> > +}
> > +
> > +#endif
> > +
> > +static const struct dev_pm_ops video_i2c_pm_ops =3D {
> > +       SET_RUNTIME_PM_OPS(video_i2c_pm_runtime_suspend,
> > +                          video_i2c_pm_runtime_resume, NULL)
> > +};
> > +
> >  static const struct i2c_device_id video_i2c_id_table[] =3D {
> >         { "amg88xx", AMG88XX },
> >         {}
> > @@ -678,6 +813,7 @@ static struct i2c_driver video_i2c_driver =3D {
> >         .driver =3D {
> >                 .name   =3D VIDEO_I2C_DRIVER,
> >                 .of_match_table =3D video_i2c_of_match,
> > +               .pm     =3D &video_i2c_pm_ops,
> >         },
> >         .probe          =3D video_i2c_probe,
> >         .remove         =3D video_i2c_remove,
> > --
> > 2.7.4
> >
