Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48708 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765AbcCDUdS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 15:33:18 -0500
Received: from avalon.localnet (unknown [64.88.227.140])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 4E1772005A
	for <linux-media@vger.kernel.org>; Fri,  4 Mar 2016 21:33:11 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.6] Media entity type
Date: Fri, 04 Mar 2016 22:33:09 +0200
Message-ID: <5378957.CgzCktXJZa@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 1e89f58499f3351a3b3c61dae8213fe3cd24a476:

  [media] v4l2-mc.h: fix yet more compiler errors (2016-03-04 07:56:43 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git v4l2/core

for you to fetch changes up to 593d5b581f409c8a93d47b1c8ac7787a440b584b:

  media: Rename is_media_entity_v4l2_io to is_media_entity_v4l2_video_device 
(2016-03-04 22:04:47 +0200)

----------------------------------------------------------------
Laurent Pinchart (4):
      v4l: vsp1: Check if an entity is a subdev with the right function
      v4l: exynos4-is: Drop unneeded check when setting up fimc-lite links
      media: Add type field to struct media_entity
      media: Rename is_media_entity_v4l2_io to 
is_media_entity_v4l2_video_device

 drivers/media/platform/exynos4-is/fimc-lite.c   | 12 +----
 drivers/media/platform/exynos4-is/media-dev.c   |  4 +-
 drivers/media/platform/omap3isp/ispvideo.c      |  2 +-
 drivers/media/platform/vsp1/vsp1_video.c        |  2 +-
 drivers/media/v4l2-core/v4l2-dev.c              |  1 +
 drivers/media/v4l2-core/v4l2-mc.c               |  2 +-
 drivers/media/v4l2-core/v4l2-subdev.c           |  1 +
 drivers/staging/media/davinci_vpfe/vpfe_video.c |  2 +-
 drivers/staging/media/omap4iss/iss_video.c      |  2 +-
 include/media/media-entity.h                    | 77 ++++++++++++------------
 10 files changed, 50 insertions(+), 55 deletions(-)

-- 
Regards,

Laurent Pinchart

