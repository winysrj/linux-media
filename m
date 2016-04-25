Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:44188 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754028AbcDYJOc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 05:14:32 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 8BBFE1804B5
	for <linux-media@vger.kernel.org>; Mon, 25 Apr 2016 11:14:27 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.7] Various fixes, remove most 'experimental'
 annotations
Message-ID: <571DDFF3.7050004@xs4all.nl>
Date: Mon, 25 Apr 2016 11:14:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are various fixes for 4.7.

Note that I chose to go with my tw686x patches instead of yours
(https://patchwork.linuxtv.org/patch/33991/).

Probably more interesting is the removal of old 'experimental' annotations in
videodev2.h and DocBook. APIs that have been around for several years now were
still marked as experimental, which makes no sense after so long a time.

Regards,

	Hans

The following changes since commit e07d46e7e0da86c146f199dae76f879096bc436a:

  [media] tpg: Export the tpg code from vivid as a module (2016-04-20 16:14:39 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.7c

for you to fetch changes up to 802d91c1804e3577984b6523e6428524b429035d:

  Documentation: video4linux: fix spelling mistakes (2016-04-25 11:04:39 +0200)

----------------------------------------------------------------
Dan Carpenter (1):
      cx231xx: silence uninitialized variable warning

Eric Engestrom (3):
      Documentation: dt: media: fix spelling mistake
      Documentation: DocBook: fix spelling mistake
      Documentation: video4linux: fix spelling mistakes

Hans Verkuil (8):
      tw686x: fix sparse warning
      tw686x-video: test for 60Hz instead of 50Hz
      videodev2.h: remove 'experimental' annotations.
      DocBook media: drop 'experimental' annotations
      adv7180: fix broken standards handling
      sta2x11_vip: fix s_std
      tc358743: drop bogus comment
      media/i2c/adv*: make controls inheritable instead of private

 Documentation/DocBook/media/dvb/net.xml                              |   2 +-
 Documentation/DocBook/media/v4l/compat.xml                           |  38 ----------
 Documentation/DocBook/media/v4l/controls.xml                         |  31 --------
 Documentation/DocBook/media/v4l/dev-sdr.xml                          |   6 --
 Documentation/DocBook/media/v4l/dev-subdev.xml                       |   6 --
 Documentation/DocBook/media/v4l/io.xml                               |   6 --
 Documentation/DocBook/media/v4l/selection-api.xml                    |   9 +--
 Documentation/DocBook/media/v4l/subdev-formats.xml                   |   6 --
 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml               |   6 --
 Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml            |   6 --
 Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml           |   6 --
 Documentation/DocBook/media/v4l/vidioc-enum-freq-bands.xml           |   6 --
 Documentation/DocBook/media/v4l/vidioc-expbuf.xml                    |   6 --
 Documentation/DocBook/media/v4l/vidioc-g-selection.xml               |   6 --
 Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml               |   6 --
 Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml          |   6 --
 .../DocBook/media/v4l/vidioc-subdev-enum-frame-interval.xml          |   6 --
 Documentation/DocBook/media/v4l/vidioc-subdev-enum-frame-size.xml    |   6 --
 Documentation/DocBook/media/v4l/vidioc-subdev-enum-mbus-code.xml     |   6 --
 Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml              |   6 --
 Documentation/DocBook/media/v4l/vidioc-subdev-g-frame-interval.xml   |   6 --
 Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml        |   6 --
 Documentation/devicetree/bindings/media/xilinx/video.txt             |   2 +-
 Documentation/video4linux/vivid.txt                                  |   6 +-
 drivers/media/i2c/ad9389b.c                                          |   8 ---
 drivers/media/i2c/adv7180.c                                          | 118 +++++++++++++++++++++----------
 drivers/media/i2c/adv7511.c                                          |   6 --
 drivers/media/i2c/adv7604.c                                          |   8 ---
 drivers/media/i2c/adv7842.c                                          |   6 --
 drivers/media/i2c/tc358743.c                                         |   1 -
 drivers/media/pci/sta2x11/sta2x11_vip.c                              |  26 +++----
 drivers/media/pci/tw686x/tw686x-video.c                              |  15 ++--
 drivers/media/usb/cx231xx/cx231xx-core.c                             |   3 +-
 include/uapi/linux/videodev2.h                                       |  38 +++-------
 34 files changed, 116 insertions(+), 309 deletions(-)
