Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:49837 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728495AbeJEWP4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 18:15:56 -0400
Date: Fri, 5 Oct 2018 18:16:44 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH v2 1/6] media: video-i2c: avoid accessing released memory
 area when removing driver
Message-ID: <20181005151644.6sf7lebztniif4qs@paasikivi.fi.intel.com>
References: <1537720492-31201-1-git-send-email-akinobu.mita@gmail.com>
 <1537720492-31201-2-git-send-email-akinobu.mita@gmail.com>
 <faa8cdeb-d824-f2ef-9d87-53d1af3ec468@xs4all.nl>
 <20181005093337.ncqqqn74slsfdrhj@paasikivi.fi.intel.com>
 <CAC5umyieGAE4TFb3Sv-n36WqpC4f+NuTEe_Z-07jYTJXOgAsmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC5umyieGAE4TFb3Sv-n36WqpC4f+NuTEe_Z-07jYTJXOgAsmQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mita-san,

On Fri, Oct 05, 2018 at 11:59:20PM +0900, Akinobu Mita wrote:
> 2018年10月5日(金) 18:36 Sakari Ailus <sakari.ailus@linux.intel.com>:
> >
> > Hi Hans,
> >
> > On Mon, Oct 01, 2018 at 11:40:00AM +0200, Hans Verkuil wrote:
> > > On 09/23/2018 06:34 PM, Akinobu Mita wrote:
> > > > The video_i2c_data is allocated by kzalloc and released by the video
> > > > device's release callback.  The release callback is called when
> > > > video_unregister_device() is called, but it will still be accessed after
> > > > calling video_unregister_device().
> > > >
> > > > Fix the use after free by allocating video_i2c_data by devm_kzalloc() with
> > > > i2c_client->dev so that it will automatically be released when the i2c
> > > > driver is removed.
> > >
> > > Hmm. The patch is right, but the explanation isn't. The core problem is
> > > that vdev.release was set to video_i2c_release, but that should only be
> > > used if struct video_device was kzalloc'ed. But in this case it is embedded
> > > in a larger struct, and then vdev.release should always be set to
> > > video_device_release_empty.
> >
> > When the driver is unbound, what's acquired using the devm_() family of
> > functions is released. At the same time, the user still holds a file
> > handle, and can issue IOCTLs --- but the device's data structures no longer
> > exist.
> >
> > That's not ok, and also the reason why we have the release callback.
> >
> > While there are issues elsewhere, this bit of the V4L2 / MC frameworks is
> > fine.
> >
> > Or am I missing something?
> 
> How about moving the lines causing use-after-free to release callback
> like below?
> 
> static void video_i2c_release(struct video_device *vdev)
> {
>         struct video_i2c_data *data = video_get_drvdata(vdev);
> 
>         v4l2_device_unregister(&data->v4l2_dev);
>         mutex_destroy(&data->lock);
>         mutex_destroy(&data->queue_lock);
>         kfree(data);
> }


So the remove function would only contain video_unregister_device()? That's
the way it should be, as far as I can see.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
