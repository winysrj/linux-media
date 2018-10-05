Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36961 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbeJEV6h (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 17:58:37 -0400
Received: by mail-pl1-f193.google.com with SMTP id az3-v6so6973678plb.4
        for <linux-media@vger.kernel.org>; Fri, 05 Oct 2018 07:59:32 -0700 (PDT)
MIME-Version: 1.0
References: <1537720492-31201-1-git-send-email-akinobu.mita@gmail.com>
 <1537720492-31201-2-git-send-email-akinobu.mita@gmail.com>
 <faa8cdeb-d824-f2ef-9d87-53d1af3ec468@xs4all.nl> <20181005093337.ncqqqn74slsfdrhj@paasikivi.fi.intel.com>
In-Reply-To: <20181005093337.ncqqqn74slsfdrhj@paasikivi.fi.intel.com>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Fri, 5 Oct 2018 23:59:20 +0900
Message-ID: <CAC5umyieGAE4TFb3Sv-n36WqpC4f+NuTEe_Z-07jYTJXOgAsmQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] media: video-i2c: avoid accessing released memory
 area when removing driver
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018=E5=B9=B410=E6=9C=885=E6=97=A5(=E9=87=91) 18:36 Sakari Ailus <sakari.ai=
lus@linux.intel.com>:
>
> Hi Hans,
>
> On Mon, Oct 01, 2018 at 11:40:00AM +0200, Hans Verkuil wrote:
> > On 09/23/2018 06:34 PM, Akinobu Mita wrote:
> > > The video_i2c_data is allocated by kzalloc and released by the video
> > > device's release callback.  The release callback is called when
> > > video_unregister_device() is called, but it will still be accessed af=
ter
> > > calling video_unregister_device().
> > >
> > > Fix the use after free by allocating video_i2c_data by devm_kzalloc()=
 with
> > > i2c_client->dev so that it will automatically be released when the i2=
c
> > > driver is removed.
> >
> > Hmm. The patch is right, but the explanation isn't. The core problem is
> > that vdev.release was set to video_i2c_release, but that should only be
> > used if struct video_device was kzalloc'ed. But in this case it is embe=
dded
> > in a larger struct, and then vdev.release should always be set to
> > video_device_release_empty.
>
> When the driver is unbound, what's acquired using the devm_() family of
> functions is released. At the same time, the user still holds a file
> handle, and can issue IOCTLs --- but the device's data structures no long=
er
> exist.
>
> That's not ok, and also the reason why we have the release callback.
>
> While there are issues elsewhere, this bit of the V4L2 / MC frameworks is
> fine.
>
> Or am I missing something?

How about moving the lines causing use-after-free to release callback
like below?

static void video_i2c_release(struct video_device *vdev)
{
        struct video_i2c_data *data =3D video_get_drvdata(vdev);

        v4l2_device_unregister(&data->v4l2_dev);
        mutex_destroy(&data->lock);
        mutex_destroy(&data->queue_lock);
        kfree(data);
}
