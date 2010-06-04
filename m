Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:51762 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab0FDKer (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jun 2010 06:34:47 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v4 0/5] WL1273 FM Radio driver.
Date: Fri,  4 Jun 2010 13:34:18 +0300
Message-Id: <1275647663-20650-1-git-send-email-matti.j.aaltonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello again,

and thank you for the comments. 

New in this version of the patch set:

General headers:

I removed the seek level stuff and added the FM RX class. And I've added the
BAND IOCTL and I defined the three existing bands: I also added the OIRT band
because I think it's nicer to have three bands than only two.


Hans wrote:
> Is there a difference in power consumption between the 'off' and 'suspend' state
> of the device? I assume that 'off' has the lowest power consumption.

> In that case I would have the driver go to suspend when no one has opened the
> radioX device. And if the driver is asked to go to suspend (that's the linux
> suspend state), then the driver can turn off the radio and on resume it will
> reload the firmware.

> Does that sound reasonable?

Yes that's reasonable... But I have had one problem here: the "suspend" does not
work, but we are working on it.


> As mentioned I don't think the level stuff should be added at the moment.
> The spacing field is no problem, but don't forget to update the V4L2 spec as
> well. Also document there what should happen if spacing == 0 (which is the
> case for existing apps). It basically boils down to the fact that the driver
> uses the spacing as a hint only and will adjust it to whatever the hardware
> supports.

I've fixed the spacing handling.

I've dropped the seek level stuff.

drivers/mfd/wl1273-core.c:

> Don't use bitfields! How bitfields are ordered is compiler specific.

I've dropped the bitfields.

> Does the data you copy here conform to the v4l2_rds_data struct?
> In particular the block byte. It is well documented in the Spec in the
> section on 'Reading RDS data'.

The error bits are not same as in the spec so I now copy them to the correct
positions and use the v4l2_rds_data struct.


drivers/media/radio/radio-wl1273.c:

> I understood that the band was relevant for receiving only?

That's true, I've removed the band stuff here.

> Rather than continually allocating and freeing this buffer I would just make
> it a field in struct wl1273_device. It's never more than 256 bytes, so that's
> no problem.

Now the buffer gets allocated and freed only once.

> Don't. Just make sure there can be only one reader. This is the same principle
> used by video: there can be multiple file handles open on a video node, but
> only one can be used for streaming at a time. Trying to handle multiple readers
> or writers in a driver will lead to chaos. And this can be done much better by
> userspace.

Now only one reader or writer is accepted.

> Where are the other FM_TX controls?

Added the missing controls. However, there's read-only control - I didn't add that.

> Use strlcpy here as well.

Now I'm using strlcpy everywhere...

> I strongly recommend using v4l2_ctrl_query_fill() instead (defined in
> v4l2-common.c). This ensures consistent naming. It will also make it easier
> to convert to the upcoming new control framework.

Replaced the old code with code that uses v4l2_ctrl_query_fill etc.


> Make this dev_dbg. I think it is probably better to pick the closest spacing
> rather than falling back to 50.

I've changed spacing handling quite a bit.

Cheers,


Matti J. Aaltonen (5):
  V4L2: Add seek spacing and FM RX class.
  MFD: WL1273 FM Radio: MFD driver for the FM radio.
  ASoC: WL1273 FM Radio Digital audio codec.
  V4L2: WL1273 FM Radio: Controls for the FM radio.
  Documentation: v4l: Add hw_seek spacing.

 .../DocBook/v4l/vidioc-s-hw-freq-seek.xml          |   10 +-
 drivers/media/radio/Kconfig                        |   15 +
 drivers/media/radio/Makefile                       |    1 +
 drivers/media/radio/radio-wl1273.c                 | 1907 ++++++++++++++++++++
 drivers/mfd/Kconfig                                |    6 +
 drivers/mfd/Makefile                               |    2 +
 drivers/mfd/wl1273-core.c                          |  616 +++++++
 include/linux/mfd/wl1273-core.h                    |  326 ++++
 include/linux/videodev2.h                          |   15 +-
 sound/soc/codecs/Kconfig                           |    6 +
 sound/soc/codecs/Makefile                          |    2 +
 sound/soc/codecs/wl1273.c                          |  594 ++++++
 sound/soc/codecs/wl1273.h                          |   40 +
 13 files changed, 3537 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/radio/radio-wl1273.c
 create mode 100644 drivers/mfd/wl1273-core.c
 create mode 100644 include/linux/mfd/wl1273-core.h
 create mode 100644 sound/soc/codecs/wl1273.c
 create mode 100644 sound/soc/codecs/wl1273.h

