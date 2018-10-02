Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35350 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729393AbeJBXBr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2018 19:01:47 -0400
Received: by mail-pf1-f193.google.com with SMTP id p12-v6so235051pfh.2
        for <linux-media@vger.kernel.org>; Tue, 02 Oct 2018 09:17:38 -0700 (PDT)
MIME-Version: 1.0
References: <1537720492-31201-1-git-send-email-akinobu.mita@gmail.com>
 <1537720492-31201-2-git-send-email-akinobu.mita@gmail.com> <faa8cdeb-d824-f2ef-9d87-53d1af3ec468@xs4all.nl>
In-Reply-To: <faa8cdeb-d824-f2ef-9d87-53d1af3ec468@xs4all.nl>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 3 Oct 2018 01:17:27 +0900
Message-ID: <CAC5umygWnJOOd3efR1FVK=4660+aYiDg0U+GAqEXzzLgi7h6Yw@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] media: video-i2c: avoid accessing released memory
 area when removing driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018=E5=B9=B410=E6=9C=881=E6=97=A5(=E6=9C=88) 18:40 Hans Verkuil <hverkuil@=
xs4all.nl>:
>
> On 09/23/2018 06:34 PM, Akinobu Mita wrote:
> > The video_i2c_data is allocated by kzalloc and released by the video
> > device's release callback.  The release callback is called when
> > video_unregister_device() is called, but it will still be accessed afte=
r
> > calling video_unregister_device().
> >
> > Fix the use after free by allocating video_i2c_data by devm_kzalloc() w=
ith
> > i2c_client->dev so that it will automatically be released when the i2c
> > driver is removed.
>
> Hmm. The patch is right, but the explanation isn't. The core problem is
> that vdev.release was set to video_i2c_release, but that should only be
> used if struct video_device was kzalloc'ed. But in this case it is embedd=
ed
> in a larger struct, and then vdev.release should always be set to
> video_device_release_empty.
>
> That was the real reason for the invalid access.

How about the commit log below?

struct video_device for video-i2c is embedded in a struct video_i2c_data,
and then vdev.release should always be set to video_device_release_empty.

However, the vdev.release is currently set to video_i2c_release which
frees the whole struct video_i2c_data.  In video_i2c_remove(), some fields
(v4l2_dev, lock, and queue_lock) in struct video_i2c_data are still
accessed after video_unregister_device().

This fixes the use after free by setting the vdev.release to
video_device_release_empty.  Also, convert to use devm_kzalloc() for
allocating a struct video_i2c_data in order to simplify the code.
