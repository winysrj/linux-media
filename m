Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55028 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932739AbcKJXyC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 18:54:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC v4 08/21] media: Enable allocating the media device dynamically
Date: Fri, 11 Nov 2016 01:53:59 +0200
Message-ID: <4251827.ADF06xmuSS@avalon>
In-Reply-To: <CAKocOONNR9NBszp5Qq+geRdR+qAD70GYXguN7c3Q0Ptoz0Vzhg@mail.gmail.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk> <1478613330-24691-8-git-send-email-sakari.ailus@linux.intel.com> <CAKocOONNR9NBszp5Qq+geRdR+qAD70GYXguN7c3Q0Ptoz0Vzhg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Tuesday 08 Nov 2016 12:20:29 Shuah Khan wrote:
> On Tue, Nov 8, 2016 at 6:55 AM, Sakari Ailus wrote:
> > From: Sakari Ailus <sakari.ailus@iki.fi>
> > 
> > Allow allocating the media device dynamically. As the struct media_device
> > embeds struct media_devnode, the lifetime of that object is that same than
> > that of the media_device.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> > 
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
> One problem with this allocation is, this media device can't be shared
> across drivers. For au0828 and snd-usb-audio should be able to share the
> media_device. That is what the Media Allocator API patch series does.

No disagreement here, Sakari's patches don't address the issues that the media 
allocator API fixes. The media allocator API, when ready, should replace (or 
at least complement, if we decide to keep a simpler API for drivers that don't 
need to share a media device, but I have no opinion on this at this time) this 
allocation function.

> This a quick review and I will review the patch series and get back to
> you.
>
> >  void media_device_cleanup(struct media_device *mdev)
> >  {
> >         ida_destroy(&mdev->entity_internal_idx);
> > diff --git a/include/media/media-device.h b/include/media/media-device.h
> > index 96de915..c9b5798 100644
> > --- a/include/media/media-device.h
> > +++ b/include/media/media-device.h
> > @@ -207,6 +207,15 @@ static inline __must_check int
> > media_entity_enum_init(
> >  void media_device_init(struct media_device *mdev);
> >  
> >  /**
> > + * media_device_alloc() - Allocate and initialise a media device
> > + *
> > + * @dev:       The associated struct device pointer
> > + *
> > + * Allocate and initialise a media device. Returns a media device.
> > + */
> > +struct media_device *media_device_alloc(struct device *dev);
> > +
> > +/**
> >   * media_device_cleanup() - Cleanups a media device element
> >   *
> >   * @mdev:      pointer to struct &media_device
> > @@ -451,6 +460,10 @@ void __media_device_usb_init(struct media_device
> > *mdev,
> >                              const char *driver_name);
> >  #else
> > +static inline struct media_device *media_device_alloc(struct device *dev)
> > +{
> > +       return NULL;
> > +}
> >  static inline int media_device_register(struct media_device *mdev)
> >  {
> >         return 0;

-- 
Regards,

Laurent Pinchart

