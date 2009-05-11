Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:19690 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbZEKJhH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2009 05:37:07 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCH v2 0/7] [RFC] FM Transmitter (si4713) and another changes
Date: Mon, 11 May 2009 12:31:42 +0300
Message-Id: <1242034309-13448-1-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

It took a few but I'm resending the FM transmitter driver again.
Sorry for this delay, but I had another things to give attention.

Anyway, after reading the API and re-writing the code I came up
with the following 7 patches. Three of them are in the v4l2 API.
The other 4 are for the si4713 device.

It is because of the first 3 patches that I'm sending this as a RFC.

The first and second patches, as suggested before, are creating another
v4l2 extended controls class, the V4L2_CTRL_CLASS_FMTX. At this
first interaction, I've put all si4713 device extra properties there.
But I think that some of the can be moved to private class (V4L2_CID_PRIVATE_BASE).
That's the case of the region related things. Comments are wellcome.

The third patch came *maybe* because I've misunderstood something. But
I realized that the v4l2-subdev helper functions for I2C devices assumes
that the bridge device will create an I2C adaptor. And in that case, only
I2C address and its type are suffient. But in this case, makes no sense
to me to create an adaptor for the si4713 platform device driver. This is
the case where the device (si4713) is connected to an existing adaptor.
That's why I've realized that currently there is no way to pass I2C board info
using the current v4l2 I2C helper functions. Other info like irq line and
platform data are not passed to subdevices. So, that's why I've created
that patch.

The remaining patches are the si4713 device driver itself. As suggested,
I've splited the driver into i2c driver and v4l2 radio driver. The first
one is exporting it self as a v4l2 subdev as well. Now it is composed by
the si4713.c and si4713-subdev.c. But in the future versions I think I'll
merge both and remove the si4713.c (by reducing lots of things), because
it was mainly designed to be used by the sysfs interface. I've also keeped
the sysfs interface (besides the extended control interface). The v4l2 radio
driver became a platform driver which is mainly a wrapper to the I2C subdevice.
Again here I've found some problem with the device remove. Because, as the
I2C helper function assumes the bridge device will create an adaptor, then
when the bridge removes the adaptor, its devices will be removed as well.
So, when re-inserting the driver, registration will be good. However, if
we use an existing adaptor, then we need to remove the i2c client manually.
Otherwise it will fail when re-inserting the device.

As I said before, comments are wellcome. I'm mostly to be misunderstanding something
from the API.

BR,

Eduardo Valentin (7):
  v4l2: video device: Add V4L2_CTRL_CLASS_FMTX controls
  v4l2: video device: Add FMTX controls default configurations
  v4l2_subdev i2c: Add i2c board info to v4l2_i2c_new_subdev
  FMTx: si4713: Add files to handle si4713 i2c device
  FMTx: si4713: Add files to add radio interface for si4713
  FMTx: si4713: Add Kconfig and Makefile entries
  FMTx: si4713: Add document file

 Documentation/video4linux/si4713.txt |  132 ++
 drivers/media/radio/Kconfig          |   22 +
 drivers/media/radio/Makefile         |    3 +
 drivers/media/radio/radio-si4713.c   |  345 ++++++
 drivers/media/radio/radio-si4713.h   |   48 +
 drivers/media/radio/si4713-subdev.c  | 1045 ++++++++++++++++
 drivers/media/radio/si4713.c         | 2250 ++++++++++++++++++++++++++++++++++
 drivers/media/radio/si4713.h         |  295 +++++
 drivers/media/video/v4l2-common.c    |   99 ++-
 include/linux/videodev2.h            |   45 +
 include/media/v4l2-common.h          |    6 +
 11 files changed, 4284 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/video4linux/si4713.txt
 create mode 100644 drivers/media/radio/radio-si4713.c
 create mode 100644 drivers/media/radio/radio-si4713.h
 create mode 100644 drivers/media/radio/si4713-subdev.c
 create mode 100644 drivers/media/radio/si4713.c
 create mode 100644 drivers/media/radio/si4713.h

