Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51272 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751271AbcKNNlY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 08:41:24 -0500
Date: Mon, 14 Nov 2016 15:40:50 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: Re: [RFC v4 08/21] media: Enable allocating the media device
 dynamically
Message-ID: <20161114134049.GS3217@valkosipuli.retiisi.org.uk>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
 <1478613330-24691-8-git-send-email-sakari.ailus@linux.intel.com>
 <CAKocOONNR9NBszp5Qq+geRdR+qAD70GYXguN7c3Q0Ptoz0Vzhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKocOONNR9NBszp5Qq+geRdR+qAD70GYXguN7c3Q0Ptoz0Vzhg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Tue, Nov 08, 2016 at 12:20:29PM -0700, Shuah Khan wrote:
> On Tue, Nov 8, 2016 at 6:55 AM, Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
> > From: Sakari Ailus <sakari.ailus@iki.fi>
> >
> > Allow allocating the media device dynamically. As the struct media_device
> > embeds struct media_devnode, the lifetime of that object is that same than
> > that of the media_device.
> >
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/media-device.c | 15 +++++++++++++++
> >  include/media/media-device.h | 13 +++++++++++++
> >  2 files changed, 28 insertions(+)
> >
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index a31329d..496195e 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -684,6 +684,21 @@ void media_device_init(struct media_device *mdev)
> >  }
> >  EXPORT_SYMBOL_GPL(media_device_init);
> >
> > +struct media_device *media_device_alloc(struct device *dev)
> > +{
> > +       struct media_device *mdev;
> > +
> > +       mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
> > +       if (!mdev)
> > +               return NULL;
> > +
> > +       mdev->dev = dev;
> > +       media_device_init(mdev);
> > +
> > +       return mdev;
> > +}
> > +EXPORT_SYMBOL_GPL(media_device_alloc);
> > +
> 
> One problem with this allocation is, this media device can't be shared across
> drivers. For au0828 and snd-usb-audio should be able to share the
> media_device. That is what the Media Allocator API patch series does.
> This a quick review and I will review the patch series and get back to
> you.

The assumption has always been there that a media device has a single struct
device related to it. It hasn't been visible in the function call API
though, just in the data structures.

I have to admit I may have forgotten something that was discussed back then,
but do you need to share the same media device over multiple devices in the
system? I don't see that at least in the allocator patch itself. It's
"[PATCH v3] media: Media Device Allocator API", isn't it?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
