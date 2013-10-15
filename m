Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45284 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759113Ab3JOQMs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 12:12:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: devel@driverdev.osuosl.org
Cc: Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	linux-media@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [GIT PULL FOR v3.13] OMAP4 ISS driver
Date: Tue, 15 Oct 2013 18:13:04 +0200
Message-ID: <25127151.1ba0aYdzI6@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here's a pull request for v3.13 that adds a driver for the OMAP4 ISS (camera 
interface).

The driver has been posted for review on the devel@driverdev.osuosl.org and 
linux-media@vger.kernel.org mailing lists. A couple of review comments were 
received (thanks to the reviewers). I've decided to address them as follow-up 
patches in order to keep the original code, well, original and credit Sergio 
Aguirre for his great work.

I'll work on addressing the comments, cleaning up the code and getting the 
driver out of staging in the next couple of kernel versions.

The following changes since commit 61e6cfa80de5760bbe406f4e815b7739205754d2:

  Linux 3.12-rc5 (2013-10-13 15:41:28 -0700)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap4iss/next

for you to fetch changes up to 8255f7e6fc15f238c40d1244863433bea0436956:

  v4l: omap4iss: Add support for OMAP4 camera interface - Build system 
(2013-10-15 17:56:15 +0200)

----------------------------------------------------------------
Laurent Pinchart (1):
      v4l: omap4iss: Add support for OMAP4 camera interface - Build system

Sergio Aguirre (5):
      v4l: omap4iss: Add support for OMAP4 camera interface - Core
      v4l: omap4iss: Add support for OMAP4 camera interface - Video devices
      v4l: omap4iss: Add support for OMAP4 camera interface - CSI receivers
      v4l: omap4iss: Add support for OMAP4 camera interface - IPIPE(IF)
      v4l: omap4iss: Add support for OMAP4 camera interface - Resizer

 Documentation/video4linux/omap4_camera.txt   |   63 ++
 drivers/staging/media/Kconfig                |    2 +
 drivers/staging/media/Makefile               |    1 +
 drivers/staging/media/omap4iss/Kconfig       |   12 +
 drivers/staging/media/omap4iss/Makefile      |    6 +
 drivers/staging/media/omap4iss/TODO          |    4 +
 drivers/staging/media/omap4iss/iss.c         | 1477 +++++++++++++++++++++++++
 drivers/staging/media/omap4iss/iss.h         |  153 ++++
 drivers/staging/media/omap4iss/iss_csi2.c    | 1368 +++++++++++++++++++++++++
 drivers/staging/media/omap4iss/iss_csi2.h    |  156 ++++
 drivers/staging/media/omap4iss/iss_csiphy.c  |  278 +++++++
 drivers/staging/media/omap4iss/iss_csiphy.h  |   51 ++
 drivers/staging/media/omap4iss/iss_ipipe.c   |  581 +++++++++++++
 drivers/staging/media/omap4iss/iss_ipipe.h   |   67 ++
 drivers/staging/media/omap4iss/iss_ipipeif.c |  847 +++++++++++++++++++
 drivers/staging/media/omap4iss/iss_ipipeif.h |   92 +++
 drivers/staging/media/omap4iss/iss_regs.h    |  883 ++++++++++++++++++++
 drivers/staging/media/omap4iss/iss_resizer.c |  905 +++++++++++++++++++++
 drivers/staging/media/omap4iss/iss_resizer.h |   75 ++
 drivers/staging/media/omap4iss/iss_video.c   | 1129 +++++++++++++++++++++++++
 drivers/staging/media/omap4iss/iss_video.h   |  201 +++++
 include/media/omap4iss.h                     |   65 ++
 22 files changed, 8416 insertions(+)
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

