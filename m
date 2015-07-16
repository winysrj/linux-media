Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37107 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbbGPHFb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 03:05:31 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 0/9] SDR transmitter API
Date: Thu, 16 Jul 2015 10:04:49 +0300
Message-Id: <1437030298-20944-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v2:
* Allow device open even another device node is active. This means you
could use transmitter device even receiver is active and other way
around, just streaming is blocked to single node.

* Removed V4L2_CID_RF_TUNER_RF_GAIN_AUTO control as it was not used.

* Changed RF gain documentation.

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

 Documentation/DocBook/media/v4l/compat.xml         |  20 +
 Documentation/DocBook/media/v4l/controls.xml       |  14 +
 Documentation/DocBook/media/v4l/dev-sdr.xml        |  32 +-
 Documentation/DocBook/media/v4l/io.xml             |  10 +-
 Documentation/DocBook/media/v4l/pixfmt.xml         |   2 +-
 Documentation/DocBook/media/v4l/v4l2.xml           |   9 +
 Documentation/DocBook/media/v4l/vidioc-g-fmt.xml   |   2 +-
 .../DocBook/media/v4l/vidioc-querycap.xml          |   6 +
 drivers/media/usb/hackrf/hackrf.c                  | 955 +++++++++++++++------
 drivers/media/v4l2-core/v4l2-ctrls.c               |   2 +
 drivers/media/v4l2-core/v4l2-dev.c                 |  14 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  31 +-
 drivers/media/v4l2-core/videobuf-core.c            |   4 +-
 include/media/v4l2-ioctl.h                         |   8 +
 include/trace/events/v4l2.h                        |   1 +
 include/uapi/linux/v4l2-controls.h                 |   1 +
 include/uapi/linux/videodev2.h                     |  10 +-
 17 files changed, 824 insertions(+), 297 deletions(-)

-- 
http://palosaari.fi/

