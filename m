Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43151 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbbEZRIg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 13:08:36 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [ATTN 0/9] SDR transmitter API
Date: Tue, 26 May 2015 20:08:01 +0300
Message-Id: <1432660090-19574-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That patch set adds V4L2 API support for SDR transmitters, with real
life working example driver - HackRF.

It also contains small change for old SDR API as I decided to rename
tuner type from V4L2_TUNER_ADC to V4L2_TUNER_SDR. ADC is SDR receiver
and DAC is SDR transmitter, so I eventually though it is better to
rename ADC to common term than add new type for DAC. Old type works
of course, it is defined also in order to avoid API breakage.

Most of the V4L implementation stuff is pretty trivial, ~copy & paste
from the SDR receiver.

New capability flag V4L2_CAP_SDR_OUTPUT is added to indicate device
is SDR transmitter.

Old capability flag V4L2_CAP_MODULATOR is used to indicate there is
'tuner' to set radio frequency for transmitter. That capability flag
name is pretty misleading in a case of SDR as SDR does not have
hardware modulator at all - but as it is existing flag it is hard to
change anymore (V4L API uses term TUNER for radio receiver and
MODULATOR for radio transmitter).

New v4l2 buffer type V4L2_BUF_TYPE_SDR_OUTPUT.

Transmitter format is negotiated similarly than receiver.

regards
Antti


Antti Palosaari (9):
  v4l2: rename V4L2_TUNER_ADC to V4L2_TUNER_SDR
  v4l2: add RF gain control
  DocBook: document tuner RF gain control
  v4l2: add support for SDR transmitter
  DocBook: document SDR transmitter
  hackrf: add control for RF amplifier
  hackrf: switch to single function which configures everything
  hackrf: add support for transmitter
  hackrf: do not set human readable name for formats

 Documentation/DocBook/media/v4l/compat.xml         |   20 +
 Documentation/DocBook/media/v4l/controls.xml       |   19 +
 Documentation/DocBook/media/v4l/dev-sdr.xml        |   32 +-
 Documentation/DocBook/media/v4l/io.xml             |   10 +-
 Documentation/DocBook/media/v4l/pixfmt.xml         |    2 +-
 Documentation/DocBook/media/v4l/v4l2.xml           |    9 +
 Documentation/DocBook/media/v4l/vidioc-g-fmt.xml   |    2 +-
 .../DocBook/media/v4l/vidioc-querycap.xml          |    6 +
 drivers/media/usb/hackrf/hackrf.c                  | 1019 ++++++++++++++------
 drivers/media/v4l2-core/v4l2-ctrls.c               |    4 +
 drivers/media/v4l2-core/v4l2-dev.c                 |   14 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   31 +-
 drivers/media/v4l2-core/videobuf-core.c            |    4 +-
 include/media/v4l2-ioctl.h                         |    8 +
 include/trace/events/v4l2.h                        |    1 +
 include/uapi/linux/v4l2-controls.h                 |    2 +
 include/uapi/linux/videodev2.h                     |   10 +-
 17 files changed, 898 insertions(+), 295 deletions(-)

-- 
http://palosaari.fi/

