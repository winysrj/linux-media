Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.122.230]:54488 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab0H3Li4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Aug 2010 07:38:56 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com, mchehab@redhat.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v9 0/4] FM Radio driver.
Date: Mon, 30 Aug 2010 14:38:18 +0300
Message-Id: <1283168302-19111-1-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi again,

and thanks for the comments.
I've left the audio codec out of this patch set.

Hans wrote:
> > In principle yes, but we haven't yet decided to implement those now, at
> > the moment the RDS interpretation is left completely to user space
> > applications.
> 
> Matti, is it even possible to use the current FM TX RDS API for this chip?
> That API expects that the chip can generate the correct RDS packets based on
> high-level data. If the chip can only handle 'raw' RDS packets (requiring a
> userspace RDS encoder), then that API will never work.
> 
> But if this chip can indeed handle raw RDS only, then we need to add some
> capability flags to signal that to userspace.

It is possible to use the current FM TX RDS API, the chip supports at least
most of it. I just haven't implemented the support into the driver yet,
for a multiple of reasons. I'm planning of adding that in the relatively 
near future.

Anyhow, I've now added a way of telling that only raw RDS is supported.
Can we use one bit it the capability field for that?

> > +     struct wl1273_device *radio = ctrl->priv;
> 
> No need to use priv for this. You can use this instead:
> 
> static inline struct wl1273_device *to_radio(struct v4l2_ctrl *ctrl)
> {
>         return container_of(ctrl->handler, struct wl1273_device, ctrl_handler);
> }

Fixed. I just didn't come to think that it can be done like this. 

> > +     dev_dbg(radio->dev, "%s\n", __func__);
> > +     return r;
> > +}
> 
> Was the documentation on the control handler understandable enough? Any
> comments on how to improve the API or documentation? It's very new, so
> I'm interested in hearing about your experiences implementing this API.

I think the documentation is OK. But I didn't have time to dwell on it,
but on the other hand I remember thinking that the new API is better
than the previous one...

But what's the motivation behind having subdevices? You'll hardly
have several FM radios and want to do the same things on each
one at the same time?

> No need to use priv.
...
> First V4L2_CID_FM_BAND using new_std instead of new_std_menu (which it should
be).
...
> And a second?!
> 
> > +     if (ctrl) {
> > +             ctrl->is_volatile = 1;
> > +             ctrl->priv = radio;
> > +     }
> 
> And it is volatile? I thought that the ANTENNA_CAPACITOR was volatile.
> Something is messed up here.

Fixed. Yes, that was completely messed up...

Thanks...

Matti

Matti J. Aaltonen (4):
  V4L2: Add seek spacing and FM RX class.
  MFD: WL1273 FM Radio: MFD driver for the FM radio.
  V4L2: WL1273 FM Radio: Controls for the FM radio.
  Documentation: v4l: Add hw_seek spacing and FM_RX class

 Documentation/DocBook/v4l/controls.xml             |   71 +
 Documentation/DocBook/v4l/dev-rds.xml              |    5 +
 .../DocBook/v4l/vidioc-s-hw-freq-seek.xml          |   10 +-
 drivers/media/radio/Kconfig                        |   15 +
 drivers/media/radio/Makefile                       |    1 +
 drivers/media/radio/radio-wl1273.c                 | 1935 ++++++++++++++++++++
 drivers/media/video/v4l2-ctrls.c                   |   12 +
 drivers/mfd/Kconfig                                |    5 +
 drivers/mfd/Makefile                               |    2 +
 drivers/mfd/wl1273-core.c                          |  612 +++++++
 include/linux/mfd/wl1273-core.h                    |  314 ++++
 include/linux/videodev2.h                          |   16 +-
 12 files changed, 2995 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/radio/radio-wl1273.c
 create mode 100644 drivers/mfd/wl1273-core.c
 create mode 100644 include/linux/mfd/wl1273-core.h

