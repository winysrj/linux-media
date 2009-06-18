Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:32945 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763904AbZFROD5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 10:03:57 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "ext Hans Verkuil" <hverkuil@xs4all.nl>,
	"ext Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	"ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv8  0/9] FM Transmitter (si4713) and another changes
Date: Thu, 18 Jun 2009 16:55:42 +0300
Message-Id: <1245333351-28157-1-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

  First of all, I'd like to thank you for the good review. The driver
is getting better and better. With this new API change, si4713 is looking
like a fm transmitter driver.

  So, I'm resending the FM transmitter driver and the proposed changes in
v4l2 api files in order to cover the fmtx extended controls class.

  Difference from version #7 is that now I've added added lots of comments
made by Hans. Here is a list of changes:
- A few renames of constant definitions
- Updates in proposed documentation
- Split of platform data info into 2 header, one for platform driver and
  other to i2c driver
- Use of v4l2_* family of logging/debugging instead of dev_*
- Improvement of debug messages
- Fix in the use of string controls
- Fix in the use of txsubchans
- Creation of private ioctl to read rssi
- Minor fixes all around the code
- Remotion of get/set style of function, previously used for the sysfs interface

As before, this series is based on two of Hans' trees:
http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-subdev2.
http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-str.

The first tree has refactoring of v4l2 i2c helper functions. The second
one has string support for extended controls, which is used in this driver.

  So, now the series includes changes to add the new v4l2
FMTX extended controls (and its documetation) and si4713 i2c and platform
drivers (and its documentation as well). Besides that, there is also
a patch to add g_modulator to v4l2-subdev and a patch to add support
for fm tx class in v4l2-ctl util.

BR,

Eduardo Valentin (9):
  v4l2-subdev.h: Add g_modulator callbacks to subdev api
  v4l2: video device: Add V4L2_CTRL_CLASS_FM_TX controls
  v4l2: video device: Add FM_TX controls default configurations
  v4l2-ctl: Add support for FM TX controls
  v4l2-spec: Add documentation description for FM TX extended control
    class
  FMTx: si4713: Add files to add radio interface for si4713
  FMTx: si4713: Add files to handle si4713 i2c device
  FMTx: si4713: Add Kconfig and Makefile entries
  FMTx: si4713: Add document file

 linux/Documentation/video4linux/si4713.txt |  169 +++
 linux/drivers/media/radio/Kconfig          |   22 +
 linux/drivers/media/radio/Makefile         |    2 +
 linux/drivers/media/radio/radio-si4713.c   |  367 +++++
 linux/drivers/media/radio/si4713-i2c.c     | 2015 ++++++++++++++++++++++++++++
 linux/drivers/media/radio/si4713-i2c.h     |  226 ++++
 linux/drivers/media/video/v4l2-common.c    |   50 +
 linux/include/linux/videodev2.h            |   34 +
 linux/include/media/radio-si4713.h         |   30 +
 linux/include/media/si4713.h               |   40 +
 linux/include/media/v4l2-subdev.h          |    2 +
 v4l2-apps/util/v4l2-ctl.cpp                |   36 +
 v4l2-spec/Makefile                         |    1 +
 v4l2-spec/biblio.sgml                      |   10 +
 v4l2-spec/controls.sgml                    |  206 +++
 15 files changed, 3210 insertions(+), 0 deletions(-)
 create mode 100644 linux/Documentation/video4linux/si4713.txt
 create mode 100644 linux/drivers/media/radio/radio-si4713.c
 create mode 100644 linux/drivers/media/radio/si4713-i2c.c
 create mode 100644 linux/drivers/media/radio/si4713-i2c.h
 create mode 100644 linux/include/media/radio-si4713.h
 create mode 100644 linux/include/media/si4713.h

