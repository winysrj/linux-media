Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1520 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab0I3Mev (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 08:34:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37] Fix videobuf_queue*init and move v4l2_find_nearest_format to v4l2-common.h
Date: Thu, 30 Sep 2010 14:34:27 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009301434.27534.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro,

Feel free to kick my ass next time I present a patch with compile errors like that.
I clearly did not do a careful grep on the sources, although I'd have sworn up and
down that I did :-(

Regards,

	Hans

The following changes since commit 5e26d8407d390b48cc7a4cf1af7bbd4a679308ff:
  Guennadi Liakhovetski (1):
        V4L/DVB: soc-camera: allow only one video queue per device

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/v4l-dvb.git bkl2

Hans Verkuil (2):
      V4L/DVB: videobuf: add ext_lock argument to the queue init functions (part 2)
      v4l2-common: Move v4l2_find_nearest_format from videodev2.h to v4l2-common.h

 drivers/media/video/davinci/vpfe_capture.c |    2 +-
 drivers/media/video/davinci/vpif_capture.c |    3 ++-
 drivers/media/video/davinci/vpif_display.c |    3 ++-
 drivers/media/video/fsl-viu.c              |    2 +-
 drivers/media/video/mx1_camera.c           |    2 +-
 drivers/media/video/mx2_camera.c           |    2 +-
 drivers/media/video/mx3_camera.c           |    3 ++-
 drivers/media/video/omap/omap_vout.c       |    2 +-
 drivers/media/video/omap24xxcam.c          |    2 +-
 drivers/media/video/pxa_camera.c           |    2 +-
 drivers/media/video/s5p-fimc/fimc-core.c   |    2 +-
 drivers/media/video/sh_mobile_ceu_camera.c |    2 +-
 drivers/media/video/sh_vou.c               |    3 ++-
 drivers/media/video/v4l2-common.c          |    7 ++++---
 include/linux/videodev2.h                  |    8 --------
 include/media/v4l2-common.h                |   10 ++++++++++
 16 files changed, 31 insertions(+), 24 deletions(-)

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
