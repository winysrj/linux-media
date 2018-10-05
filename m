Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:38140 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727073AbeJEQe1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 12:34:27 -0400
Date: Fri, 5 Oct 2018 12:33:38 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH v2 1/6] media: video-i2c: avoid accessing released memory
 area when removing driver
Message-ID: <20181005093337.ncqqqn74slsfdrhj@paasikivi.fi.intel.com>
References: <1537720492-31201-1-git-send-email-akinobu.mita@gmail.com>
 <1537720492-31201-2-git-send-email-akinobu.mita@gmail.com>
 <faa8cdeb-d824-f2ef-9d87-53d1af3ec468@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <faa8cdeb-d824-f2ef-9d87-53d1af3ec468@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Oct 01, 2018 at 11:40:00AM +0200, Hans Verkuil wrote:
> On 09/23/2018 06:34 PM, Akinobu Mita wrote:
> > The video_i2c_data is allocated by kzalloc and released by the video
> > device's release callback.  The release callback is called when
> > video_unregister_device() is called, but it will still be accessed after
> > calling video_unregister_device().
> > 
> > Fix the use after free by allocating video_i2c_data by devm_kzalloc() with
> > i2c_client->dev so that it will automatically be released when the i2c
> > driver is removed.
> 
> Hmm. The patch is right, but the explanation isn't. The core problem is
> that vdev.release was set to video_i2c_release, but that should only be
> used if struct video_device was kzalloc'ed. But in this case it is embedded
> in a larger struct, and then vdev.release should always be set to
> video_device_release_empty.

When the driver is unbound, what's acquired using the devm_() family of
functions is released. At the same time, the user still holds a file
handle, and can issue IOCTLs --- but the device's data structures no longer
exist.

That's not ok, and also the reason why we have the release callback.

While there are issues elsewhere, this bit of the V4L2 / MC frameworks is
fine.

Or am I missing something?

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
