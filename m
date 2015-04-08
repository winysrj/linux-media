Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40588 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbbDHNpT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2015 09:45:19 -0400
Received: from avalon.localnet (unknown [91.178.157.161])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 85F73203A7
	for <linux-media@vger.kernel.org>; Wed,  8 Apr 2015 15:43:30 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.1] Misc UVC and OMAP3 ISP patches
Date: Wed, 08 Apr 2015 16:45:44 +0300
Message-ID: <4118945.r7iWBEYjLv@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

If there's still time to get fixes merged in v4.1, please pull the following 
changes.

The following changes since commit c8c7c44b7cf5ef7163e4bd6aedbdeb6f6031ee3e:

  [media] s5p-jpeg: Remove some unused functions (2015-04-07 08:15:15 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git v4l2/next

for you to fetch changes up to 7543cd6741b602eb47560130a5c9d32fa16f62a2:

  uvcvideo: add support for VIDIOC_QUERY_EXT_CTRL (2015-04-08 16:42:29 +0300)

----------------------------------------------------------------
Hans Verkuil (2):
      uvcvideo: fix cropcap v4l2-compliance failure
      uvcvideo: add support for VIDIOC_QUERY_EXT_CTRL

Russell King (1):
      media: omap3isp: remove unused clkdev

 drivers/media/platform/omap3isp/isp.c | 24 ----------------
 drivers/media/platform/omap3isp/isp.h |  1 -
 drivers/media/usb/uvc/uvc_v4l2.c      | 65 ++++++++++++++++++++++++++++------
 include/media/omap3isp.h              |  6 ----
 4 files changed, 53 insertions(+), 43 deletions(-)

-- 
Regards,

Laurent Pinchart

