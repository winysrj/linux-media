Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59636 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbaAYRR2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 12:17:28 -0500
Message-ID: <52E3F1A5.5060403@iki.fi>
Date: Sat, 25 Jan 2014 19:17:25 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [GIT PULL] SDR API
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 587d1b06e07b4a079453c74ba9edf17d21931049:

   [media] rc-core: reuse device numbers (2014-01-15 11:46:37 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git sdr_api

for you to fetch changes up to 3a95ad55cfa4c2b88a3f09509c6903a55dc9cce9:

   devices.txt: add video4linux device for Software Defined Radio 
(2014-01-25 19:02:06 +0200)

----------------------------------------------------------------
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

  Documentation/DocBook/media/v4l/compat.xml                 |  13 
+++++++++++++
  Documentation/DocBook/media/v4l/dev-sdr.xml                | 110 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  Documentation/DocBook/media/v4l/io.xml                     |   6 ++++++
  Documentation/DocBook/media/v4l/pixfmt.xml                 |   8 ++++++++
  Documentation/DocBook/media/v4l/v4l2.xml                   |   1 +
  Documentation/DocBook/media/v4l/vidioc-enum-freq-bands.xml |   8 +++++---
  Documentation/DocBook/media/v4l/vidioc-g-fmt.xml           |   7 +++++++
  Documentation/DocBook/media/v4l/vidioc-g-frequency.xml     |   5 +++--
  Documentation/DocBook/media/v4l/vidioc-g-modulator.xml     |   6 ++++--
  Documentation/DocBook/media/v4l/vidioc-g-tuner.xml         |  15 
++++++++++++---
  Documentation/DocBook/media/v4l/vidioc-querycap.xml        |   6 ++++++
  Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml  |   8 ++++++--
  Documentation/devices.txt                                  |   7 +++++++
  Documentation/video4linux/v4l2-framework.txt               |   1 +
  drivers/media/v4l2-core/v4l2-dev.c                         |  30 
++++++++++++++++++++++++++----
  drivers/media/v4l2-core/v4l2-ioctl.c                       |  75 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------
  include/media/v4l2-dev.h                                   |   3 ++-
  include/media/v4l2-ioctl.h                                 |   8 ++++++++
  include/trace/events/v4l2.h                                |   1 +
  include/uapi/linux/videodev2.h                             |  16 
++++++++++++++++
  20 files changed, 306 insertions(+), 28 deletions(-)
  create mode 100644 Documentation/DocBook/media/v4l/dev-sdr.xml



-- 
http://palosaari.fi/
