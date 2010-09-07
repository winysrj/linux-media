Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4945 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab0IGTK2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Sep 2010 15:10:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: Re: [PATCH v9 0/4] FM Radio driver.
Date: Tue, 7 Sep 2010 21:10:12 +0200
Cc: linux-media@vger.kernel.org, eduardo.valentin@nokia.com,
	mchehab@redhat.com
References: <1283168302-19111-1-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1283168302-19111-1-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009072110.12405.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Monday, August 30, 2010 13:38:18 Matti J. Aaltonen wrote:
> Hi again,
> 
> and thanks for the comments.
> I've left the audio codec out of this patch set.
> 
> Hans wrote:
> > > In principle yes, but we haven't yet decided to implement those now, at
> > > the moment the RDS interpretation is left completely to user space
> > > applications.
> > 
> > Matti, is it even possible to use the current FM TX RDS API for this chip?
> > That API expects that the chip can generate the correct RDS packets based on
> > high-level data. If the chip can only handle 'raw' RDS packets (requiring a
> > userspace RDS encoder), then that API will never work.
> > 
> > But if this chip can indeed handle raw RDS only, then we need to add some
> > capability flags to signal that to userspace.
> 
> It is possible to use the current FM TX RDS API, the chip supports at least
> most of it. I just haven't implemented the support into the driver yet,
> for a multiple of reasons. I'm planning of adding that in the relatively 
> near future.

OK, good to know.

> Anyhow, I've now added a way of telling that only raw RDS is supported.
> Can we use one bit it the capability field for that?

I need to research this a bit. I intended to do that last weekend, but Real
Life (tm) interfered. I hope to get around it in the upcoming weekend.

I'm really sorry about the long delays on my side. Believe me, it's not
intentional.

> > > +     struct wl1273_device *radio = ctrl->priv;
> > 
> > No need to use priv for this. You can use this instead:
> > 
> > static inline struct wl1273_device *to_radio(struct v4l2_ctrl *ctrl)
> > {
> >         return container_of(ctrl->handler, struct wl1273_device, ctrl_handler);
> > }
> 
> Fixed. I just didn't come to think that it can be done like this. 
> 
> > > +     dev_dbg(radio->dev, "%s\n", __func__);
> > > +     return r;
> > > +}
> > 
> > Was the documentation on the control handler understandable enough? Any
> > comments on how to improve the API or documentation? It's very new, so
> > I'm interested in hearing about your experiences implementing this API.
> 
> I think the documentation is OK. But I didn't have time to dwell on it,
> but on the other hand I remember thinking that the new API is better
> than the previous one...

That's good news :-)
 
> But what's the motivation behind having subdevices? You'll hardly
> have several FM radios and want to do the same things on each
> one at the same time?

Right now this driver is a platform device if I'm not mistaken. But what if
someone would stick this wl1273 on a USB stick? Or on some PCI board?

Implementing the core wl1273 driver as a subdevice makes it independent from
how it is assembled in the final product.

There are other reasons as well, but it all boils down to creating an abstract
interface towards hardware devices so that you no longer have to care about
how they are hooked up physically to your platform/board/SoC/whatever.

> > No need to use priv.
> ...
> > First V4L2_CID_FM_BAND using new_std instead of new_std_menu (which it should
> be).
> ...
> > And a second?!
> > 
> > > +     if (ctrl) {
> > > +             ctrl->is_volatile = 1;
> > > +             ctrl->priv = radio;
> > > +     }
> > 
> > And it is volatile? I thought that the ANTENNA_CAPACITOR was volatile.
> > Something is messed up here.
> 
> Fixed. Yes, that was completely messed up...

I hope to have the final comments ready this weekend. It's high time to get
this out of the door.

Regards,

	Hans

> 
> Thanks...
> 
> Matti
> 
> Matti J. Aaltonen (4):
>   V4L2: Add seek spacing and FM RX class.
>   MFD: WL1273 FM Radio: MFD driver for the FM radio.
>   V4L2: WL1273 FM Radio: Controls for the FM radio.
>   Documentation: v4l: Add hw_seek spacing and FM_RX class
> 
>  Documentation/DocBook/v4l/controls.xml             |   71 +
>  Documentation/DocBook/v4l/dev-rds.xml              |    5 +
>  .../DocBook/v4l/vidioc-s-hw-freq-seek.xml          |   10 +-
>  drivers/media/radio/Kconfig                        |   15 +
>  drivers/media/radio/Makefile                       |    1 +
>  drivers/media/radio/radio-wl1273.c                 | 1935 ++++++++++++++++++++
>  drivers/media/video/v4l2-ctrls.c                   |   12 +
>  drivers/mfd/Kconfig                                |    5 +
>  drivers/mfd/Makefile                               |    2 +
>  drivers/mfd/wl1273-core.c                          |  612 +++++++
>  include/linux/mfd/wl1273-core.h                    |  314 ++++
>  include/linux/videodev2.h                          |   16 +-
>  12 files changed, 2995 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/media/radio/radio-wl1273.c
>  create mode 100644 drivers/mfd/wl1273-core.c
>  create mode 100644 include/linux/mfd/wl1273-core.h
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
