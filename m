Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36396 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab2HQJTE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 05:19:04 -0400
Received: from avalon.localnet (unknown [91.178.48.16])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 7461035A85
	for <linux-media@vger.kernel.org>; Fri, 17 Aug 2012 11:19:03 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.7] Aptina sensor drivers patches
Date: Fri, 17 Aug 2012 11:19:20 +0200
Message-ID: <17030834.KrB3aWSoyU@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 88f8472c9fc6c08f5113887471f1f4aabf7b2929:

  [media] Fix some Makefile rules (2012-08-16 19:55:03 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3isp-sensors-next

Laurent Pinchart (4):
      v4l2-ctrls: Add v4l2_ctrl_[gs]_ctrl_int64()
      mt9v032: Provide link frequency control
      mt9v032: Export horizontal and vertical blanking as V4L2 controls
      mt9p031: Fix horizontal and vertical blanking configuration

Sakari Ailus (1):
      mt9v032: Provide pixel rate control

 drivers/media/i2c/mt9p031.c          |   12 ++--
 drivers/media/i2c/mt9v032.c          |  100 ++++++++++++++++++++++++-
 drivers/media/v4l2-core/v4l2-ctrls.c |  135 ++++++++++++++++++++-------------
 include/media/mt9v032.h              |    3 +
 include/media/v4l2-ctrls.h           |   23 ++++++
 5 files changed, 209 insertions(+), 64 deletions(-)

-- 
Regards,

Laurent Pinchart

