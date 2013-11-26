Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46699 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983Ab3KZQYa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 11:24:30 -0500
Received: from avalon.localnet (unknown [109.134.93.159])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id A5C6335A49
	for <linux-media@vger.kernel.org>; Tue, 26 Nov 2013 17:23:44 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.14 v2] OMAP4 ISS driver
Date: Tue, 26 Nov 2013 17:24:32 +0100
Message-ID: <18475556.sszQoEAjFm@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here's a pull request for v3.14 that adds a driver for the OMAP4 ISS (camera 
interface). It supersedes the previous v3.14 pull request for the same driver.

The driver has been posted for review on the linux-media@vger.kernel.org 
mailing list. I believe I have addressed all the review comments, and all the 
patches have been acked by Hans Verkuil.

Compared to v1, the patches have been rebased on top of the current linuxtv 
master branch.

I'll work on cleaning up the code and getting the driver out of staging in the 
next couple of kernel versions.

The following changes since commit 258d2fbf874c87830664cb7ef41f9741c1abffac:

  Merge tag 'v3.13-rc1' into patchwork (2013-11-25 05:57:23 -0200)

are available in the git repository at:


  git://linuxtv.org/pinchartl/media.git omap4iss/next

for you to fetch changes up to 97e87df937a6555a1eb6dfe67a03a889625a6a37:

  v4l: omap4iss: Implement VIDIOC_S_INPUT (2013-11-26 17:01:53 +0100)

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
===
-- 
Regards,

Laurent Pinchart

