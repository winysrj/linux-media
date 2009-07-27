Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:31534 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbZG0PX0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2009 11:23:26 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "ext Hans Verkuil" <hverkuil@xs4all.nl>,
	"ext Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv14 0/8] FM Transmitter (si4713) and another changes
Date: Mon, 27 Jul 2009 18:12:02 +0300
Message-Id: <1248707530-4068-1-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hello guys,

This is version 14 of this series.

More polishing this time: removal of few unused variables and
some reorganization to reduce stack size. A tiny fix on specs text as well.
Code looks nicer.

Comments, as usual, are appreciated.

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

 linux/Documentation/video4linux/si4713.txt      |  176 ++
 linux/drivers/media/radio/Kconfig               |   22 +
 linux/drivers/media/radio/Makefile              |    2 +
 linux/drivers/media/radio/radio-si4713.c        |  367 ++++
 linux/drivers/media/radio/si4713-i2c.c          | 2042 +++++++++++++++++++++++
 linux/drivers/media/radio/si4713-i2c.h          |  237 +++
 linux/drivers/media/video/v4l2-common.c         |   50 +
 linux/drivers/media/video/v4l2-compat-ioctl32.c |    8 +-
 linux/include/linux/videodev2.h                 |   34 +
 linux/include/media/radio-si4713.h              |   30 +
 linux/include/media/si4713.h                    |   49 +
 linux/include/media/v4l2-subdev.h               |    2 +
 v4l2-spec/Makefile                              |    1 +
 v4l2-spec/controls.sgml                         |  215 +++
 14 files changed, 3234 insertions(+), 1 deletions(-)
 create mode 100644 linux/Documentation/video4linux/si4713.txt
 create mode 100644 linux/drivers/media/radio/radio-si4713.c
 create mode 100644 linux/drivers/media/radio/si4713-i2c.c
 create mode 100644 linux/drivers/media/radio/si4713-i2c.h
 create mode 100644 linux/include/media/radio-si4713.h
 create mode 100644 linux/include/media/si4713.h

