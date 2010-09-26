Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1812 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521Ab0IZMZJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Sep 2010 08:25:09 -0400
Received: from tschai.localnet (186.84-48-119.nextgentel.com [84.48.119.186])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id o8QCP6oq091549
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 26 Sep 2010 14:25:07 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37] Move V4L2 locking into the core framework
Date: Sun, 26 Sep 2010 14:25:00 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009261425.00146.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

These are the locking patches. It's based on my previous test tree, but with
more testing with em28xx and radio-mr800 and some small tweaks relating to
disconnect handling and video_is_registered().

I also removed the unused get_unmapped_area file op and I am now blocking
any further (unlocked_)ioctl calls after the device node is unregistered.
The only things an application can do legally after a disconnect is unmap()
and close().

This patch series also contains a small em28xx fix that I found while testing
the em28xx BKL removal patch.

Regards,

	Hans

The following changes since commit dace3857de7a16b83ae7d4e13c94de8e4b267d2a:
  Hans Verkuil (1):
        V4L/DVB: tvaudio: remove obsolete tda8425 initialization

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/v4l-dvb.git bkl

Hans Verkuil (10):
      v4l2-dev: after a disconnect any ioctl call will be blocked.
      v4l2-dev: remove get_unmapped_area
      v4l2: add core serialization lock.
      videobuf: prepare to make locking optional in videobuf
      videobuf: add ext_lock argument to the queue init functions
      videobuf: add queue argument to videobuf_waiton()
      vivi: remove BKL.
      em28xx: remove BKL.
      em28xx: the default std was not passed on to the subdevs
      radio-mr800: remove BKL

 Documentation/video4linux/v4l2-framework.txt  |   25 +++++-
 drivers/media/common/saa7146_fops.c           |    2 +-
 drivers/media/common/saa7146_vbi.c            |    2 +-
 drivers/media/common/saa7146_video.c          |    2 +-
 drivers/media/radio/radio-mr800.c             |   74 ++--------------
 drivers/media/video/au0828/au0828-video.c     |    4 +-
 drivers/media/video/bt8xx/bttv-driver.c       |    4 +-
 drivers/media/video/bt8xx/bttv-risc.c         |    2 +-
 drivers/media/video/cx231xx/cx231xx-video.c   |    6 +-
 drivers/media/video/cx23885/cx23885-417.c     |    2 +-
 drivers/media/video/cx23885/cx23885-core.c    |    2 +-
 drivers/media/video/cx23885/cx23885-dvb.c     |    2 +-
 drivers/media/video/cx23885/cx23885-video.c   |    2 +-
 drivers/media/video/cx88/cx88-blackbird.c     |    2 +-
 drivers/media/video/cx88/cx88-core.c          |    2 +-
 drivers/media/video/cx88/cx88-dvb.c           |    2 +-
 drivers/media/video/cx88/cx88-video.c         |    4 +-
 drivers/media/video/em28xx/em28xx-video.c     |   93 +++------------------
 drivers/media/video/fsl-viu.c                 |    2 +-
 drivers/media/video/mx1_camera.c              |    2 +-
 drivers/media/video/mx2_camera.c              |    2 +-
 drivers/media/video/mx3_camera.c              |    2 +-
 drivers/media/video/omap24xxcam.c             |    2 +-
 drivers/media/video/pxa_camera.c              |    2 +-
 drivers/media/video/s2255drv.c                |    2 +-
 drivers/media/video/saa7134/saa7134-core.c    |    2 +-
 drivers/media/video/saa7134/saa7134-dvb.c     |    2 +-
 drivers/media/video/saa7134/saa7134-empress.c |    2 +-
 drivers/media/video/saa7134/saa7134-video.c   |    4 +-
 drivers/media/video/sh_mobile_ceu_camera.c    |    2 +-
 drivers/media/video/sh_vou.c                  |    2 +-
 drivers/media/video/v4l2-dev.c                |  110 ++++++++++++++----------
 drivers/media/video/v4l2-event.c              |    9 ++-
 drivers/media/video/v4l2-mem2mem.c            |    8 +-
 drivers/media/video/videobuf-core.c           |  115 +++++++++++++++----------
 drivers/media/video/videobuf-dma-contig.c     |    9 +-
 drivers/media/video/videobuf-dma-sg.c         |    9 +-
 drivers/media/video/videobuf-dvb.c            |    2 +-
 drivers/media/video/videobuf-vmalloc.c        |    9 +-
 drivers/media/video/vivi.c                    |   17 ++--
 drivers/media/video/zr364xx.c                 |    2 +-
 drivers/staging/cx25821/cx25821-core.c        |    2 +-
 drivers/staging/cx25821/cx25821-video.c       |    2 +-
 drivers/staging/dt3155v4l/dt3155v4l.c         |    8 +-
 drivers/staging/tm6000/tm6000-video.c         |    2 +-
 include/media/v4l2-dev.h                      |    5 +-
 include/media/videobuf-core.h                 |   19 ++++-
 include/media/videobuf-dma-contig.h           |    3 +-
 include/media/videobuf-dma-sg.h               |    3 +-
 include/media/videobuf-vmalloc.h              |    3 +-
 50 files changed, 282 insertions(+), 315 deletions(-)
-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
