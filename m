Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36389 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab3LTFuN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 00:50:13 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC v5 00/12] SDR API with documentation
Date: Fri, 20 Dec 2013 07:49:42 +0200
Message-Id: <1387518594-11609-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now with documentation and changes from Hans.

Antti Palosaari (11):
  v4l: add device type for Software Defined Radio
  v4l: add new tuner types for SDR
  v4l: 1 Hz resolution flag for tuners
  v4l: add stream format for SDR receiver
  v4l: define own IOCTL ops for SDR FMT
  v4l: enable some IOCTLs for SDR receiver
  v4l: add device capability flag for SDR receiver
  DocBook: fix wait.c location
  DocBook: document 1 Hz flag
  DocBook: Software Defined Radio Interface
  v4l2-framework.txt: add SDR device type

Hans Verkuil (1):
  v4l: do not allow modulator ioctls for non-radio devices

 Documentation/DocBook/device-drivers.tmpl          |  2 +-
 Documentation/DocBook/media/v4l/compat.xml         | 10 +++
 Documentation/DocBook/media/v4l/dev-sdr.xml        | 99 ++++++++++++++++++++++
 Documentation/DocBook/media/v4l/io.xml             |  6 ++
 Documentation/DocBook/media/v4l/v4l2.xml           |  1 +
 .../DocBook/media/v4l/vidioc-enum-freq-bands.xml   |  8 +-
 Documentation/DocBook/media/v4l/vidioc-g-fmt.xml   |  6 ++
 .../DocBook/media/v4l/vidioc-g-frequency.xml       |  3 +-
 .../DocBook/media/v4l/vidioc-g-modulator.xml       |  6 +-
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml | 15 +++-
 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |  8 +-
 Documentation/video4linux/v4l2-framework.txt       |  1 +
 drivers/media/v4l2-core/v4l2-dev.c                 | 30 ++++++-
 drivers/media/v4l2-core/v4l2-ioctl.c               | 75 +++++++++++++---
 include/media/v4l2-dev.h                           |  3 +-
 include/media/v4l2-ioctl.h                         |  8 ++
 include/trace/events/v4l2.h                        |  1 +
 include/uapi/linux/videodev2.h                     | 16 ++++
 18 files changed, 270 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/dev-sdr.xml

-- 
1.8.4.2

