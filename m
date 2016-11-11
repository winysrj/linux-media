Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55092 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935019AbcKKAK5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 19:10:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Shuah Khan <shuahkhan@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC v4 08/21] media: Enable allocating the media device dynamically
Date: Fri, 11 Nov 2016 02:11 +0200
Message-ID: <1698237.M9v6idgxsX@avalon>
In-Reply-To: <2d71d705-bfd4-696d-52ff-c5a043eed158@osg.samsung.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk> <4251827.ADF06xmuSS@avalon> <2d71d705-bfd4-696d-52ff-c5a043eed158@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Thursday 10 Nov 2016 17:00:16 Shuah Khan wrote:
> On 11/10/2016 04:53 PM, Laurent Pinchart wrote:
> > On Tuesday 08 Nov 2016 12:20:29 Shuah Khan wrote:
> >> On Tue, Nov 8, 2016 at 6:55 AM, Sakari Ailus wrote:
> >>> From: Sakari Ailus <sakari.ailus@iki.fi>
> >>> 
> >>> Allow allocating the media device dynamically. As the struct
> >>> media_device embeds struct media_devnode, the lifetime of that object is
> >>> that same than that of the media_device.
> >>> 
> >>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >>> ---
> >>> 
> >>>  drivers/media/media-device.c | 15 +++++++++++++++
> >>>  include/media/media-device.h | 13 +++++++++++++
> >>>  2 files changed, 28 insertions(+)
> >>> 
> >>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> >>> index a31329d..496195e 100644
> >>> --- a/drivers/media/media-device.c
> >>> +++ b/drivers/media/media-device.c
> >>> @@ -684,6 +684,21 @@ void media_device_init(struct media_device *mdev)
> >>>  }
> >>>  EXPORT_SYMBOL_GPL(media_device_init);
> >>> 
> >>> +struct media_device *media_device_alloc(struct device *dev)
> >>> +{
> >>> +       struct media_device *mdev;
> >>> +
> >>> +       mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
> >>> +       if (!mdev)
> >>> +               return NULL;
> >>> +
> >>> +       mdev->dev = dev;
> >>> +       media_device_init(mdev);
> >>> +
> >>> +       return mdev;
> >>> +}
> >>> +EXPORT_SYMBOL_GPL(media_device_alloc);
> >>> +
> >> 
> >> One problem with this allocation is, this media device can't be shared
> >> across drivers. For au0828 and snd-usb-audio should be able to share the
> >> media_device. That is what the Media Allocator API patch series does.
> > 
> > No disagreement here, Sakari's patches don't address the issues that the
> > media allocator API fixes. The media allocator API, when ready, should
> > replace (or at least complement, if we decide to keep a simpler API for
> > drivers that don't need to share a media device, but I have no opinion on
> > this at this time) this allocation function.
> 
> Media Device Allocator API is ready and reviewed. au0828 uses it as the
> first driver using it. I will be sending out snd-usb-audio patch soon that
> makes use of the shared media device.

I don't think it would be too difficult to rebase this series on top of the 
media allocator API, as all that is needed here is a way to dynamically 
allocate the media device in a clean fashion. I don't think Sakari's patches 
depend on a specific implementation of media_device_alloc(). Sakari, please 
let me know if I got this wrong.

> >> This a quick review and I will review the patch series and get back to
> >> you.

-- 
Regards,

Laurent Pinchart

