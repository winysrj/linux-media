Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48138 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbaB0AWU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 19:22:20 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 00/13] SDR API - V4L API stuff itself
Date: Thu, 27 Feb 2014 02:21:55 +0200
Message-Id: <1393460528-11684-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Controls, stream formats and documentation for those.
That is all API stuff.

Antti

Antti Palosaari (13):
  v4l: add RF tuner gain controls
  v4l: add RF tuner channel bandwidth control
  v4l: reorganize RF tuner control ID numbers
  v4l: uapi: add SDR formats CU8 and CU16LE
  v4l: add enum_freq_bands support to tuner sub-device
  v4l: add control for RF tuner PLL lock flag
  DocBook: V4L: add V4L2_SDR_FMT_CU8 - 'CU08'
  DocBook: V4L: add V4L2_SDR_FMT_CU16LE - 'CU16'
  DocBook: document RF tuner gain controls
  DocBook: media: document V4L2_CTRL_CLASS_RF_TUNER
  DocBook: document RF tuner bandwidth controls
  DocBook: media: document PLL lock control
  DocBook: media: add some general info about RF tuners

 Documentation/DocBook/media/v4l/controls.xml       | 138 +++++++++++++++++++++
 .../DocBook/media/v4l/pixfmt-sdr-cu08.xml          |  44 +++++++
 .../DocBook/media/v4l/pixfmt-sdr-cu16le.xml        |  46 +++++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |   3 +
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   7 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  24 ++++
 include/media/v4l2-subdev.h                        |   1 +
 include/uapi/linux/v4l2-controls.h                 |  14 +++
 include/uapi/linux/videodev2.h                     |   4 +
 9 files changed, 280 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu16le.xml

-- 
1.8.5.3

