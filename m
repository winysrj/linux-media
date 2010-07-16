Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:19454 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965066Ab0GPK2T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jul 2010 06:28:19 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v5 0/5] WL1273 FM Radio driver
Date: Fri, 16 Jul 2010 13:27:42 +0300
Message-Id: <1279276067-1736-1-git-send-email-matti.j.aaltonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

and thanks for the comments Hans. NowIn this version there are several small fixes
because now I had time to actually test the driver... 

Hans wrote:
> I've been thinking about this a bit more. Would it be possible to do this automatically
> in the driver? I.e. based on the frequency you switch the device into the appropriate
> band?
> If that is not possible, then you shouldn't forget to document this new control in the spec.
> When you document it you should give some background information as well: the freq ranges of
> these bands and roughly where they are used.

What you suggest could of course be done but I think it would be kind of ugly especially
when doing HW scan and things like that. So I kept the bands and added it to the documentation.


drivers/mfd/wl1273-core.c 
> Have you verified that bits 0-2 correctly match the block numbering as defined
> by the spec? You should also copy bits 0-2 into bits 3-5. This is for backwards
> compatibility. Eventually we should be able to drop this, but for now we still
> need to do this.

Yes I think the block numbering is OK. Also added a copy to bits 3 to 5 etc...

drivers/media/radio/radio-wl1273.c
>> +     /* TODO: handle the case of multiple readers */
>
> Please remove this comment: multiple reader support does not belong in the kernel,
> so this will never happen.

Fixed.

>> +             return POLLIN | POLLRDNORM;
>
> Since you can write as well, shouldn't there be POLLOUT handling too?
>
>> +

Yes, fixed...


Cheers,
Matti


Matti J. Aaltonen (5):
  V4L2: Add seek spacing and FM RX class.
  MFD: WL1273 FM Radio: MFD driver for the FM radio.
  ASoC: WL1273 FM Radio Digital audio codec.
  V4L2: WL1273 FM Radio: Controls for the FM radio.
  Documentation: v4l: Add hw_seek spacing and FM_RX class

 Documentation/DocBook/v4l/controls.xml             |   71 +
 .../DocBook/v4l/vidioc-s-hw-freq-seek.xml          |   10 +-
 drivers/media/radio/Kconfig                        |   15 +
 drivers/media/radio/Makefile                       |    1 +
 drivers/media/radio/radio-wl1273.c                 | 1897 ++++++++++++++++++++
 drivers/mfd/Kconfig                                |    6 +
 drivers/mfd/Makefile                               |    2 +
 drivers/mfd/wl1273-core.c                          |  621 +++++++
 include/linux/mfd/wl1273-core.h                    |  313 ++++
 include/linux/videodev2.h                          |   15 +-
 sound/soc/codecs/Kconfig                           |    6 +
 sound/soc/codecs/Makefile                          |    2 +
 sound/soc/codecs/wl1273.c                          |  588 ++++++
 sound/soc/codecs/wl1273.h                          |   40 +
 14 files changed, 3584 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/radio/radio-wl1273.c
 create mode 100644 drivers/mfd/wl1273-core.c
 create mode 100644 include/linux/mfd/wl1273-core.h
 create mode 100644 sound/soc/codecs/wl1273.c
 create mode 100644 sound/soc/codecs/wl1273.h

