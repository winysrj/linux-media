Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34630 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab3KMOH6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Nov 2013 09:07:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sergio Aguirre <sergio.a.aguirre@gmail.com>
Subject: [GIT PULL FOR v3.14] OMAP4 ISS driver
Date: Wed, 13 Nov 2013 15:08:35 +0100
Message-ID: <10350088.RHxZQGJApS@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here's a pull request for v3.14 that adds a driver for the OMAP4 ISS (camera 
interface). It supersedes the v3.13 pull request for the same driver.

The driver has been posted for review on the linux-media@vger.kernel.org 
mailing list. I believe I have addressed all the review comments, and all the 
patches have been acked by Hans Verkuil.

I'll work on cleaning up the code and getting the driver out of staging in the 
next couple of kernel versions.

The following changes since commit 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52:

  Linux 3.12 (2013-11-03 15:41:51 -0800)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap4iss/next

for you to fetch changes up to ccd8ce12d77444e0e2ee092dd5d5e56c2bf928a1:

  v4l: omap4iss: Implement VIDIOC_S_INPUT (2013-11-04 14:19:43 +0100)

----------------------------------------------------------------
Laurent Pinchart (17):
      v4l: omap4iss: Add support for OMAP4 camera interface - Build system
      v4l: omap4iss: Don't use v4l2_g_ext_ctrls() internally
      v4l: omap4iss: Move common code out of switch...case
      v4l: omap4iss: Report device caps in response to VIDIOC_QUERYCAP
      v4l: omap4iss: Remove iss_video streaming field
      v4l: omap4iss: Set the vb2 timestamp type
      v4l: omap4iss: Remove duplicate video_is_registered() check
      v4l: omap4iss: Remove unneeded status variable
      v4l: omap4iss: Replace udelay/msleep with usleep_range
      v4l: omap4iss: Make omap4iss_isp_subclk_(en|dis)able() functions void
      v4l: omap4iss: Make loop counters unsigned where appropriate
      v4l: omap4iss: Don't initialize fields to 0 manually
      v4l: omap4iss: Simplify error paths
      v4l: omap4iss: Don't check for missing get_fmt op on remote subdev
      v4l: omap4iss: Translate -ENOIOCTLCMD to -ENOTTY
      v4l: omap4iss: Move code out of mutex-protected section
      v4l: omap4iss: Implement VIDIOC_S_INPUT

Sergio Aguirre (5):
      v4l: omap4iss: Add support for OMAP4 camera interface - Core
      v4l: omap4iss: Add support for OMAP4 camera interface - Video devices
      v4l: omap4iss: Add support for OMAP4 camera interface - CSI receivers
      v4l: omap4iss: Add support for OMAP4 camera interface - IPIPE(IF)
      v4l: omap4iss: Add support for OMAP4 camera interface - Resizer

 Documentation/video4linux/omap4_camera.txt   |   60 ++
 drivers/staging/media/Kconfig                |    2 +
 drivers/staging/media/Makefile               |    1 +
 drivers/staging/media/omap4iss/Kconfig       |   12 +
 drivers/staging/media/omap4iss/Makefile      |    6 +
 drivers/staging/media/omap4iss/TODO          |    4 +
 drivers/staging/media/omap4iss/iss.c         | 1462 +++++++++++++++++++++++++
 drivers/staging/media/omap4iss/iss.h         |  153 ++++
 drivers/staging/media/omap4iss/iss_csi2.c    | 1368 +++++++++++++++++++++++++
 drivers/staging/media/omap4iss/iss_csi2.h    |  156 ++++
 drivers/staging/media/omap4iss/iss_csiphy.c  |  278 +++++++
 drivers/staging/media/omap4iss/iss_csiphy.h  |   51 ++
 drivers/staging/media/omap4iss/iss_ipipe.c   |  581 ++++++++++++++
 drivers/staging/media/omap4iss/iss_ipipe.h   |   67 ++
 drivers/staging/media/omap4iss/iss_ipipeif.c |  847 ++++++++++++++++++++
 drivers/staging/media/omap4iss/iss_ipipeif.h |   92 +++
 drivers/staging/media/omap4iss/iss_regs.h    |  883 ++++++++++++++++++++
 drivers/staging/media/omap4iss/iss_resizer.c |  905 +++++++++++++++++++++
 drivers/staging/media/omap4iss/iss_resizer.h |   75 ++
 drivers/staging/media/omap4iss/iss_video.c   | 1128 +++++++++++++++++++++++++
 drivers/staging/media/omap4iss/iss_video.h   |  198 +++++
 include/media/omap4iss.h                     |   65 ++
 22 files changed, 8394 insertions(+)
 create mode 100644 Documentation/video4linux/omap4_camera.txt
 create mode 100644 drivers/staging/media/omap4iss/Kconfig
 create mode 100644 drivers/staging/media/omap4iss/Makefile
 create mode 100644 drivers/staging/media/omap4iss/TODO
 create mode 100644 drivers/staging/media/omap4iss/iss.c
 create mode 100644 drivers/staging/media/omap4iss/iss.h
 create mode 100644 drivers/staging/media/omap4iss/iss_csi2.c
 create mode 100644 drivers/staging/media/omap4iss/iss_csi2.h
 create mode 100644 drivers/staging/media/omap4iss/iss_csiphy.c
 create mode 100644 drivers/staging/media/omap4iss/iss_csiphy.h
 create mode 100644 drivers/staging/media/omap4iss/iss_ipipe.c
 create mode 100644 drivers/staging/media/omap4iss/iss_ipipe.h
 create mode 100644 drivers/staging/media/omap4iss/iss_ipipeif.c
 create mode 100644 drivers/staging/media/omap4iss/iss_ipipeif.h
 create mode 100644 drivers/staging/media/omap4iss/iss_regs.h
 create mode 100644 drivers/staging/media/omap4iss/iss_resizer.c
 create mode 100644 drivers/staging/media/omap4iss/iss_resizer.h
 create mode 100644 drivers/staging/media/omap4iss/iss_video.c
 create mode 100644 drivers/staging/media/omap4iss/iss_video.h
 create mode 100644 include/media/omap4iss.h

-- 
Regards,

Laurent Pinchart

