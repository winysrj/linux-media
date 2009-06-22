Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:58501 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbZFVQ2O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 12:28:14 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "ext Hans Verkuil" <hverkuil@xs4all.nl>,
	"ext Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	"ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv9 0/9] FM Transmitter (si4713) and another changes
Date: Mon, 22 Jun 2009 19:21:27 +0300
Message-Id: <1245687696-6730-1-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

  First of all, I'd like to thank you for the good review. The driver
is getting better and better. With this new API change, si4713 is looking
like a fm transmitter driver.

  So, I'm resending the FM transmitter driver and the proposed changes in
v4l2 api files in order to cover the fmtx extended controls class.

  Differences from version #8 are:
- Use of new modulator Capabilities
- Use of new RDS modulator Capabilities and usage of txsubchannel
- Proper definition of struct si4713_rssi. It was renamed also to si4713_rnl
  (which stands to received noise level)
- Updates for documentation

  Now this series is based on *three* of Hans' trees:
http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-subdev2.
http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-str.
http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-rds-enc.

  The first tree has refactoring of v4l2 i2c helper functions. The second
one has string support for extended controls, which is used in this driver.
And the last one is the proposed changes for RDS capable modulators/receivers.
As the ~hverkuil/v4l-dvb-rds-enc has already reference for EN50067, I didn't
touch the v4l2-spec/biblio.sgml.

  Here is simplified list of things included in this series:
- support for g/s_modulator into subdev api
- addition of fm tx extended controls and their proper documentation
- addition of fm tx extended controls in v4l2-ctl util
- addition of si4713: platform and i2c drivers and its documentation

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

 linux/Documentation/video4linux/si4713.txt |  175 +++
 linux/drivers/media/radio/Kconfig          |   22 +
 linux/drivers/media/radio/Makefile         |    2 +
 linux/drivers/media/radio/radio-si4713.c   |  366 +++++
 linux/drivers/media/radio/si4713-i2c.c     | 2011 ++++++++++++++++++++++++++++
 linux/drivers/media/radio/si4713-i2c.h     |  226 ++++
 linux/drivers/media/video/v4l2-common.c    |   48 +
 linux/include/linux/videodev2.h            |   33 +
 linux/include/media/radio-si4713.h         |   30 +
 linux/include/media/si4713.h               |   49 +
 linux/include/media/v4l2-subdev.h          |    2 +
 v4l2-apps/util/v4l2-ctl.cpp                |   36 +
 v4l2-spec/Makefile                         |    1 +
 v4l2-spec/controls.sgml                    |  200 +++
 14 files changed, 3201 insertions(+), 0 deletions(-)
 create mode 100644 linux/Documentation/video4linux/si4713.txt
 create mode 100644 linux/drivers/media/radio/radio-si4713.c
 create mode 100644 linux/drivers/media/radio/si4713-i2c.c
 create mode 100644 linux/drivers/media/radio/si4713-i2c.h
 create mode 100644 linux/include/media/radio-si4713.h
 create mode 100644 linux/include/media/si4713.h

