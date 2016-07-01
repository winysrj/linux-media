Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:43005 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbcGAOqC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 10:46:02 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 7D771180106
	for <linux-media@vger.kernel.org>; Fri,  1 Jul 2016 16:45:51 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] Various fixes/improvements
Message-ID: <319a2666-50e5-29ff-b5bf-b47d26723d7a@xs4all.nl>
Date: Fri, 1 Jul 2016 16:45:51 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is my yield of one day of patch processing. On Monday I plan to do another round,
then for patches that are not directly my core activity. Although there are one or two
dvb patches in this pull request as well.

Regards,

	Hans

The following changes since commit ab46f6d24bf57ddac0f5abe2f546a78af57b476c:

  [media] videodev2.h: Fix V4L2_PIX_FMT_YUV411P description (2016-06-28 11:54:52 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8d

for you to fetch changes up to 0fcfba86e6bc9c6aae17bbe5bd9444698a37992e:

  tw686x: make const structs static (2016-07-01 16:37:27 +0200)

----------------------------------------------------------------
Alexander Shiyan (1):
      media: coda: Fix probe() if reset controller is missing

Alexey Khoroshilov (1):
      bt8xx: remove needless module refcounting

Amitoj Kaur Chawla (2):
      saa7164: Replace if and BUG with BUG_ON
      ddbridge: Replace vmalloc with vzalloc

Arnd Bergmann (1):
      dvb: use ktime_t for internal timeout

Dragos Bogdan (1):
      adv7604: Add support for hardware reset

Florian Echtler (3):
      sur40: properly report a single frame rate of 60 FPS
      sur40: lower poll interval to fix occasional FPS drops to ~56 FPS
      sur40: fix occasional oopses on device close

Guennadi Liakhovetski (1):
      V4L: fix the Z16 format definition

Hans Verkuil (4):
      v4l2-tpg: ignore V4L2_DV_RGB_RANGE setting for YUV formats
      rc-main: fix kernel oops after unloading keymap module
      sur40: drop unnecessary format description
      tw686x: make const structs static

Javier Martinez Canillas (2):
      DocBook: add dmabuf as streaming I/O in VIDIOC_REQBUFS description
      DocBook: mention the memory type to be set for all streaming I/O

Lubomir Rintel (2):
      usbtv: clarify the licensing
      usbtv: improve a comment

Ricardo Ribalda Delgado (4):
      vb2: V4L2_BUF_FLAG_DONE is set after DQBUF
      vb2: Merge vb2_internal_dqbuf and vb2_dqbuf
      vb2: Merge vb2_internal_qbuf and vb2_qbuf
      vb2: Fix comment

 Documentation/DocBook/media/v4l/io.xml             |  4 ++--
 Documentation/DocBook/media/v4l/pixfmt-z16.xml     |  2 +-
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |  2 +-
 drivers/input/touchscreen/sur40.c                  | 26 +++++++++++++++++-----
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |  4 ++--
 drivers/media/dvb-core/demux.h                     |  2 +-
 drivers/media/dvb-core/dmxdev.c                    |  2 +-
 drivers/media/dvb-core/dvb_demux.c                 | 17 +++++----------
 drivers/media/dvb-core/dvb_demux.h                 |  4 ++--
 drivers/media/dvb-core/dvb_net.c                   |  2 +-
 drivers/media/i2c/adv7604.c                        | 20 +++++++++++++++++
 drivers/media/pci/bt8xx/dst_ca.c                   |  2 --
 drivers/media/pci/ddbridge/ddbridge-core.c         |  3 +--
 drivers/media/pci/saa7164/saa7164-encoder.c        |  6 ++---
 drivers/media/pci/tw686x/tw686x-video.c            |  6 ++---
 drivers/media/platform/coda/coda-common.c          |  2 +-
 drivers/media/rc/rc-main.c                         | 10 +++++++--
 drivers/media/usb/usbtv/usbtv-audio.c              | 28 ++++++++++++++++++------
 drivers/media/usb/usbtv/usbtv-core.c               | 40 +++++++++++++++++++++++-----------
 drivers/media/usb/usbtv/usbtv-video.c              | 59 +++++++++++++++++++++++++++++++++++++-------------
 drivers/media/usb/usbtv/usbtv.h                    | 22 +++++++++++++++----
 drivers/media/v4l2-core/videobuf2-core.c           |  2 +-
 drivers/media/v4l2-core/videobuf2-v4l2.c           | 47 +++++++++++++++++++---------------------
 23 files changed, 206 insertions(+), 106 deletions(-)
