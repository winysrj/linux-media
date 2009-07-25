Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:58636 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbZGYPIc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 11:08:32 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "ext Hans Verkuil" <hverkuil@xs4all.nl>,
	"ext Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv11 0/8] FM Transmitter (si4713) and another changes
Date: Sat, 25 Jul 2009 17:57:34 +0300
Message-Id: <1248533862-20860-1-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello guys,

 Here is the version 11 of FM transmitter work. It is basically
same thing of version 10 with minor fixes from previous comments,
which are:
- Do not use temp variable in v4l2_ctrl_is_pointer (v4l2-common.c).
- Report a string length accordingly to maximum allowed size (si4713-i2c.c).
- Add some comments explaining rds psname and radio text maximum sizes.
- Update si4713.txt with latest v4l2-ctl output (which was proper updated
for modulator devices).

Besides that, every thing is the same.

 Again, this series is based only on
http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-strctrl,
which contains the string support for our extended control api.

The problems with v4l2-ctl were solved by Hans. Now it can
properly set/get frequencies for modulators. Also the txsubchannels
are properly handled for RDS capable devices.

Thanks Hans.

BR,


Eduardo Valentin (8):
  v4l2-subdev.h: Add g_modulator callbacks to subdev api
  v4l2: video device: Add V4L2_CTRL_CLASS_FM_TX controls
  v4l2: video device: Add FM TX controls default configurations
  v4l2-spec: Add documentation description for FM TX extended control
    class
  FM TX: si4713: Add files to add radio interface for si4713
  FM TX: si4713: Add files to handle si4713 i2c device
  FM TX: si4713: Add Kconfig and Makefile entries
  FM TX: si4713: Add document file

 linux/Documentation/video4linux/si4713.txt |  176 +++
 linux/drivers/media/radio/Kconfig          |   22 +
 linux/drivers/media/radio/Makefile         |    2 +
 linux/drivers/media/radio/radio-si4713.c   |  367 +++++
 linux/drivers/media/radio/si4713-i2c.c     | 2034 ++++++++++++++++++++++++++++
 linux/drivers/media/radio/si4713-i2c.h     |  237 ++++
 linux/drivers/media/video/v4l2-common.c    |   58 +-
 linux/include/linux/videodev2.h            |   34 +
 linux/include/media/radio-si4713.h         |   30 +
 linux/include/media/si4713.h               |   49 +
 linux/include/media/v4l2-subdev.h          |    2 +
 v4l2-spec/Makefile                         |    1 +
 v4l2-spec/controls.sgml                    |  210 +++
 13 files changed, 3221 insertions(+), 1 deletions(-)
 create mode 100644 linux/Documentation/video4linux/si4713.txt
 create mode 100644 linux/drivers/media/radio/radio-si4713.c
 create mode 100644 linux/drivers/media/radio/si4713-i2c.c
 create mode 100644 linux/drivers/media/radio/si4713-i2c.h
 create mode 100644 linux/include/media/radio-si4713.h
 create mode 100644 linux/include/media/si4713.h

