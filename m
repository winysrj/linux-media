Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:39432 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbZGXQsM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2009 12:48:12 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "ext Hans Verkuil" <hverkuil@xs4all.nl>,
	"ext Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv10 0/8] FM Transmitter (si4713) and another changes
Date: Fri, 24 Jul 2009 19:37:20 +0300
Message-Id: <1248453448-1668-1-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello guys,

 Here is the version 10 of fm transmitter work.

 The difference between previous version is that now it is
based only on http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-strctrl,
which contains the string support for our extended control api.

Also, I've added a new extended control on the fm tx class:
rds deviation. This control was missing from previous versions.
It used to be set to default value. But I believe it would be good
to have it configurable.

Another minor change is about s_frequency call back. In the
conversion from sysfs to extended control only interfaces,
I forgot to keep the range check. That was missing on version #9.
Now it is back.

I've removed the v4l2-ctl changes, as they are no longer needed
due to last re-factoring which happened there. All ext controls
seams to work with v4l2-ctl, including string ones.

I've also updated the documentation, including the new control
and the references for character encoding of ps name and radio text.

Besides that, every thing is the same.

There is a needed change in v4l2-ctl regarding set/get frequency.
Nowadays, v4l2-ctl queries only the tuner and forgets about modulators.
That I will send an initial proposal in a separated patch (I believe
it is not related to this series anymore).

BR,

Eduardo Valentin (8):
  v4l2-subdev.h: Add g_modulator callbacks to subdev api
  v4l2: video device: Add V4L2_CTRL_CLASS_FM_TX controls
  v4l2: video device: Add FM_TX controls default configurations
  v4l2-spec: Add documentation description for FM TX extended control
    class
  FMTx: si4713: Add files to add radio interface for si4713
  FMTx: si4713: Add files to handle si4713 i2c device
  FMTx: si4713: Add Kconfig and Makefile entries
  FMTx: si4713: Add document file

 linux/Documentation/video4linux/si4713.txt |  175 +++
 linux/drivers/media/radio/Kconfig          |   22 +
 linux/drivers/media/radio/Makefile         |    2 +
 linux/drivers/media/radio/radio-si4713.c   |  367 +++++
 linux/drivers/media/radio/si4713-i2c.c     | 2034 ++++++++++++++++++++++++++++
 linux/drivers/media/radio/si4713-i2c.h     |  228 ++++
 linux/drivers/media/video/v4l2-common.c    |   63 +-
 linux/include/linux/videodev2.h            |   34 +
 linux/include/media/radio-si4713.h         |   30 +
 linux/include/media/si4713.h               |   49 +
 linux/include/media/v4l2-subdev.h          |    2 +
 v4l2-spec/Makefile                         |    1 +
 v4l2-spec/controls.sgml                    |  210 +++
 13 files changed, 3216 insertions(+), 1 deletions(-)
 create mode 100644 linux/Documentation/video4linux/si4713.txt
 create mode 100644 linux/drivers/media/radio/radio-si4713.c
 create mode 100644 linux/drivers/media/radio/si4713-i2c.c
 create mode 100644 linux/drivers/media/radio/si4713-i2c.h
 create mode 100644 linux/include/media/radio-si4713.h
 create mode 100644 linux/include/media/si4713.h

