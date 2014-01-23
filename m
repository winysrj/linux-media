Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54574 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbaAWVJK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jan 2014 16:09:10 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 00/13] SDR API
Date: Thu, 23 Jan 2014 23:08:40 +0200
Message-Id: <1390511333-25837-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think it is ready enough. PULL request will follow in next days...


The next step I	am going to add SDR API is tuner gain controls.

Modern silicon RF tuners used nowadays has many controllable gains
on signal path. Usually there is at least 3 amplifiers:
1) LNA gain. That is first amplifier just after antenna input pins.
2) Mixer gain. Quite middle of the signal path, where RF signal is
down-converted to IF/BB.
3) IF gain. That is last gain in order to adjust output signal
level to optimal level of demodulator.

Each gain controls could be often manual or automatic mode (AGC).
Total gain is something like sum of all gains. My plan is to implement
these 3 gains with manual/auto switch and group all those to one
master/total gain.

Antti

Antti Palosaari (12):
  v4l: add device type for Software Defined Radio
  v4l: add new tuner types for SDR
  v4l: 1 Hz resolution flag for tuners
  v4l: add stream format for SDR receiver
  v4l: define own IOCTL ops for SDR FMT
  v4l: enable some IOCTLs for SDR receiver
  v4l: add device capability flag for SDR receiver
  DocBook: document 1 Hz flag
  DocBook: Software Defined Radio Interface
  DocBook: mark SDR API as Experimental
  v4l2-framework.txt: add SDR device type
  devices.txt: add video4linux device for Software Defined Radio

Hans Verkuil (1):
  v4l: do not allow modulator ioctls for non-radio devices

 Documentation/DocBook/media/v4l/compat.xml         |  13 +++
 Documentation/DocBook/media/v4l/dev-sdr.xml        | 110 +++++++++++++++++++++
 Documentation/DocBook/media/v4l/io.xml             |   6 ++
 Documentation/DocBook/media/v4l/pixfmt.xml         |   8 ++
 Documentation/DocBook/media/v4l/v4l2.xml           |   1 +
 .../DocBook/media/v4l/vidioc-enum-freq-bands.xml   |   8 +-
 Documentation/DocBook/media/v4l/vidioc-g-fmt.xml   |   7 ++
 .../DocBook/media/v4l/vidioc-g-frequency.xml       |   5 +-
 .../DocBook/media/v4l/vidioc-g-modulator.xml       |   6 +-
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |  15 ++-
 .../DocBook/media/v4l/vidioc-querycap.xml          |   6 ++
 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |   8 +-
 Documentation/devices.txt                          |   7 ++
 Documentation/video4linux/v4l2-framework.txt       |   1 +
 drivers/media/v4l2-core/v4l2-dev.c                 |  30 +++++-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  75 +++++++++++---
 include/media/v4l2-dev.h                           |   3 +-
 include/media/v4l2-ioctl.h                         |   8 ++
 include/trace/events/v4l2.h                        |   1 +
 include/uapi/linux/videodev2.h                     |  16 +++
 20 files changed, 306 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/dev-sdr.xml

-- 
1.8.5.3

