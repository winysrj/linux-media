Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34142 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3FGK0d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 06:26:33 -0400
Received: from avalon.localnet (unknown [91.178.217.139])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 87E8435A4D
	for <linux-media@vger.kernel.org>; Fri,  7 Jun 2013 12:26:27 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.11] Media controller patch
Date: Fri, 07 Jun 2013 12:26:37 +0200
Message-ID: <3227348.nlhECq6VuT@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 7eac97d7e714429f7ef1ba5d35f94c07f4c34f8e:

  [media] media: pci: remove duplicate checks for EPERM (2013-05-27 09:34:56 
-0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git v4l2/media

for you to fetch changes up to b2c4bdde53e6a842f51deca4ffe96a4c1b011c93:

  media: Rename media_entity_remote_source to media_entity_remote_pad 
(2013-06-04 04:57:27 +0200)

----------------------------------------------------------------
Andrzej Hajda (1):
      media: Rename media_entity_remote_source to media_entity_remote_pad

 Documentation/media-framework.txt                |  2 +-
 drivers/media/media-entity.c                     | 13 ++++++-------
 drivers/media/platform/exynos4-is/fimc-capture.c |  6 +++---
 drivers/media/platform/exynos4-is/fimc-lite.c    |  4 ++--
 drivers/media/platform/exynos4-is/media-dev.c    |  2 +-
 drivers/media/platform/omap3isp/isp.c            |  6 +++---
 drivers/media/platform/omap3isp/ispccdc.c        |  2 +-
 drivers/media/platform/omap3isp/ispccp2.c        |  2 +-
 drivers/media/platform/omap3isp/ispcsi2.c        |  2 +-
 drivers/media/platform/omap3isp/ispvideo.c       |  6 +++---
 drivers/media/platform/s3c-camif/camif-capture.c |  2 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c  | 12 ++++++------
 include/media/media-entity.h                     |  2 +-
 13 files changed, 30 insertions(+), 31 deletions(-)

-- 
Regards,

Laurent Pinchart

