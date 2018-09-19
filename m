Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40515 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731665AbeISUis (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 16:38:48 -0400
Received: by mail-pf1-f196.google.com with SMTP id s13-v6so2840919pfi.7
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 08:00:28 -0700 (PDT)
MIME-Version: 1.0
References: <1537200191-17956-1-git-send-email-akinobu.mita@gmail.com>
 <1537200191-17956-2-git-send-email-akinobu.mita@gmail.com> <20180919103531.k5yhvngj6gdgdnq2@paasikivi.fi.intel.com>
In-Reply-To: <20180919103531.k5yhvngj6gdgdnq2@paasikivi.fi.intel.com>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Thu, 20 Sep 2018 00:00:17 +0900
Message-ID: <CAC5umyiO5g5vZGGE4HPpxEkUNUd==GzkfMoavzmWn-gS9+emPw@mail.gmail.com>
Subject: Re: [PATCH 1/5] media: video-i2c: avoid accessing released memory
 area when removing driver
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018=E5=B9=B49=E6=9C=8819=E6=97=A5(=E6=B0=B4) 19:35 Sakari Ailus <sakari.ai=
lus@linux.intel.com>:
>
> Hi Mita-san,
>
> On Tue, Sep 18, 2018 at 01:03:07AM +0900, Akinobu Mita wrote:
> > The struct video_i2c_data is released when video_unregister_device() is
> > called, but it will still be accessed after calling
> > video_unregister_device().
> >
> > Use devm_kzalloc() and let the memory be automatically released on driv=
er
> > detach.
> >
> > Fixes: 5cebaac60974 ("media: video-i2c: add video-i2c driver")
> > Cc: Matt Ranostay <matt.ranostay@konsulko.com>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: Hans Verkuil <hansverk@cisco.com>
> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> >  drivers/media/i2c/video-i2c.c | 18 +++++-------------
> >  1 file changed, 5 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2=
c.c
> > index 06d29d8..b7a2af9 100644
> > --- a/drivers/media/i2c/video-i2c.c
> > +++ b/drivers/media/i2c/video-i2c.c
> > @@ -508,20 +508,15 @@ static const struct v4l2_ioctl_ops video_i2c_ioct=
l_ops =3D {
> >       .vidioc_streamoff               =3D vb2_ioctl_streamoff,
> >  };
> >
> > -static void video_i2c_release(struct video_device *vdev)
> > -{
> > -     kfree(video_get_drvdata(vdev));
>
> This is actually correct: it ensures that that the device data stays in
> place as long as the device is being accessed. Allocating device data wit=
h
> devm_kzalloc() no longer guarantees that, and is not the right thing to d=
o
> for that reason.

I have actually inserted printk() each line in video_i2_remove().  When
rmmod this driver, video_i2c_release() (and also kfree) is called while
executing video_unregister_device().  Because video_unregister_device()
releases the last reference to data->vdev.dev, then v4l2_device_release()
callback executes data->vdev.release.

So use after freeing video_i2c_data actually happened.

In this patch, devm_kzalloc() is called with client->dev (not with vdev->de=
v).
So the allocated memory is released when the last user of client->dev
is gone (maybe just after video_i2_remove() is finished).

> > -}
> > -
> >  static int video_i2c_probe(struct i2c_client *client,
> >                            const struct i2c_device_id *id)
> >  {
> >       struct video_i2c_data *data;
> >       struct v4l2_device *v4l2_dev;
> >       struct vb2_queue *queue;
> > -     int ret =3D -ENODEV;
> > +     int ret;
> >
> > -     data =3D kzalloc(sizeof(*data), GFP_KERNEL);
> > +     data =3D devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
> >       if (!data)
> >               return -ENOMEM;
> >
> > @@ -530,7 +525,7 @@ static int video_i2c_probe(struct i2c_client *clien=
t,
> >       else if (id)
> >               data->chip =3D &video_i2c_chip[id->driver_data];
> >       else
> > -             goto error_free_device;
> > +             return -ENODEV;
> >
> >       data->client =3D client;
> >       v4l2_dev =3D &data->v4l2_dev;
> > @@ -538,7 +533,7 @@ static int video_i2c_probe(struct i2c_client *clien=
t,
> >
> >       ret =3D v4l2_device_register(&client->dev, v4l2_dev);
> >       if (ret < 0)
> > -             goto error_free_device;
> > +             return ret;
> >
> >       mutex_init(&data->lock);
> >       mutex_init(&data->queue_lock);
> > @@ -568,7 +563,7 @@ static int video_i2c_probe(struct i2c_client *clien=
t,
> >       data->vdev.fops =3D &video_i2c_fops;
> >       data->vdev.lock =3D &data->lock;
> >       data->vdev.ioctl_ops =3D &video_i2c_ioctl_ops;
> > -     data->vdev.release =3D video_i2c_release;
> > +     data->vdev.release =3D video_device_release_empty;
> >       data->vdev.device_caps =3D V4L2_CAP_VIDEO_CAPTURE |
> >                                V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
> >
> > @@ -597,9 +592,6 @@ static int video_i2c_probe(struct i2c_client *clien=
t,
> >       mutex_destroy(&data->lock);
> >       mutex_destroy(&data->queue_lock);
> >
> > -error_free_device:
> > -     kfree(data);
> > -
> >       return ret;
> >  }
> >
>
> --
> Regards,
>
> Sakari Ailus
> sakari.ailus@linux.intel.com
