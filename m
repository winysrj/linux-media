Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:57497 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210AbZENLwY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 07:52:24 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCH v3 0/7] [RFC] FM Transmitter (si4713) and another changes
Date: Thu, 14 May 2009 14:46:54 +0300
Message-Id: <1242301622-29672-1-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

  I'm resending the FM transmitter driver and the proposed changes in
v4l2 api files in order to cover the fmtx extended controls class.

  It is basically the same series of version #2. However I rewrote it
to add the following comments:

  * Get rid of the region settings thing. That was done for the
changes of FMTX Extended controls class as well as from the si4713
driver (also the sysfs nodes for region were removed). If any
settings for region is required, that will be left for user land.

  * Define preemphasis enumeration constants so that values are increasing.

  * Removed also the code from the platform driver which manually
unregister the i2c client (this is now done in the v4l2 i2c helper
functions).

  * The last patch now adds documentation for fmtx extended controls
class into v4l2 docs.

  Note that only the last patch is against v4l-dvb hg repo. The other 7
are against normal linux tree.

  From top of my mind, what is still open is the i2c board info issue.
I still don't know how to configure the irq line for i2c v4l2 subdev
devices with current v4l2 subdev i2c helper functions (same thing
for platform data). So, that's why I'm resending the patch
which modifies the api to add a way to pass i2c board info to
subdevice while registering.

  Again, comments are welcome.

BR,

---
Eduardo Valentin (7):
  v4l2: video device: Add V4L2_CTRL_CLASS_FMTX controls
  v4l2: video device: Add FMTX controls default configurations
  v4l2_subdev i2c: Add i2c board info to v4l2_i2c_new_subdev
  FMTx: si4713: Add files to handle si4713 i2c device
  FMTx: si4713: Add files to add radio interface for si4713
  FMTx: si4713: Add Kconfig and Makefile entries
  FMTx: si4713: Add document file

 Documentation/video4linux/si4713.txt |  133 +++
 drivers/media/radio/Kconfig          |   22 +
 drivers/media/radio/Makefile         |    3 +
 drivers/media/radio/radio-si4713.c   |  332 ++++++
 drivers/media/radio/radio-si4713.h   |   48 +
 drivers/media/radio/si4713-subdev.c  | 1008 ++++++++++++++++
 drivers/media/radio/si4713.c         | 2100 ++++++++++++++++++++++++++++++++++
 drivers/media/radio/si4713.h         |  282 +++++
 drivers/media/video/v4l2-common.c    |   79 ++-
 include/linux/videodev2.h            |   34 +
 include/media/v4l2-common.h          |    6 +
 11 files changed, 4041 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/video4linux/si4713.txt
 create mode 100644 drivers/media/radio/radio-si4713.c
 create mode 100644 drivers/media/radio/radio-si4713.h
 create mode 100644 drivers/media/radio/si4713-subdev.c
 create mode 100644 drivers/media/radio/si4713.c
 create mode 100644 drivers/media/radio/si4713.h

