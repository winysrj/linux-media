Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56929 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbbGaCLK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 22:11:10 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCHv3 00/13] SDR transmitter API
Date: Fri, 31 Jul 2015 05:10:37 +0300
Message-Id: <1438308650-2702-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v3:
* some documentation addons

* added type field to v4l2 modulator struct

* hackrf: fix querycap capabilities

* hackrf: remove another v4l2_device struct

* hackrf: fix / moved RX/TX busy check to start streaming

* hackrf: some other minor changes

Those fixes were the ones Hans pointed out, thanks. Some documentation is still TODO.

Passes v4l2-compliance otherwise than new modulator type field.

Output ioctls:
fail: v4l2-test-input-output.cpp(576): non-zero reserved fields
fail: v4l2-test-input-output.cpp(640): invalid modulator 0
test VIDIOC_G/S_MODULATOR: FAIL
fail: v4l2-test-input-output.cpp(729): could get frequency for invalid modulator 0
test VIDIOC_G/S_FREQUENCY: FAIL


v2:
* Allow device open even another device node is active. This means you
could use transmitter device even receiver is active and other way
around, just streaming is blocked to single node.

* Removed V4L2_CID_RF_TUNER_RF_GAIN_AUTO control as it was not used.

* Changed RF gain documentation.


Antti Palosaari (13):
  v4l2: rename V4L2_TUNER_ADC to V4L2_TUNER_SDR
  v4l2: add RF gain control
  DocBook: document tuner RF gain control
  v4l2: add support for SDR transmitter
  DocBook: document SDR transmitter
  v4l: add type field to v4l2_modulator struct
  DocBook: add modulator type field
  hackrf: add control for RF amplifier
  hackrf: switch to single function which configures everything
  hackrf: add support for transmitter
  hackrf: do not set human readable name for formats
  DocBook: fix S_FREQUENCY => G_FREQUENCY
  DocBook: add tuner types SDR and RF for G_TUNER / S_TUNER

 Documentation/DocBook/media/v4l/common.xml         |    2 +-
 Documentation/DocBook/media/v4l/compat.xml         |   20 +
 Documentation/DocBook/media/v4l/controls.xml       |   14 +
 Documentation/DocBook/media/v4l/dev-sdr.xml        |   32 +-
 Documentation/DocBook/media/v4l/io.xml             |   10 +-
 Documentation/DocBook/media/v4l/pixfmt.xml         |    2 +-
 Documentation/DocBook/media/v4l/v4l2.xml           |    9 +
 Documentation/DocBook/media/v4l/vidioc-g-fmt.xml   |    2 +-
 .../DocBook/media/v4l/vidioc-g-modulator.xml       |    8 +-
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |   10 +
 .../DocBook/media/v4l/vidioc-querycap.xml          |    6 +
 drivers/media/usb/hackrf/hackrf.c                  | 1062 ++++++++++++++------
 drivers/media/v4l2-core/v4l2-ctrls.c               |    2 +
 drivers/media/v4l2-core/v4l2-dev.c                 |   14 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   49 +-
 drivers/media/v4l2-core/videobuf-core.c            |    4 +-
 include/media/v4l2-ioctl.h                         |    8 +
 include/trace/events/v4l2.h                        |    1 +
 include/uapi/linux/v4l2-controls.h                 |    1 +
 include/uapi/linux/videodev2.h                     |   13 +-
 20 files changed, 916 insertions(+), 353 deletions(-)

-- 
http://palosaari.fi/

