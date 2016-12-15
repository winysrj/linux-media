Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:39015
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753860AbcLOTtZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 14:49:25 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] omap3 devm usage removal 
Date: Thu, 15 Dec 2016 12:40:06 -0700
Message-Id: <cover.1481829721.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series contains two patches. The first one removes
calls to media_entity_cleanup() after  media device has been
unregistered. The second one removes devm usage.

Shuah Khan (2):
  media: omap3isp fix media_entity_cleanup() after media device
    unregister
  media: omap3isp change to devm for resources

 drivers/media/platform/omap3isp/isp.c         | 71 +++++++++++++++++++--------
 drivers/media/platform/omap3isp/ispccdc.c     |  1 -
 drivers/media/platform/omap3isp/ispccp2.c     | 11 +++--
 drivers/media/platform/omap3isp/ispcsi2.c     |  1 -
 drivers/media/platform/omap3isp/isph3a_aewb.c | 21 +++++---
 drivers/media/platform/omap3isp/isph3a_af.c   | 21 +++++---
 drivers/media/platform/omap3isp/isphist.c     |  5 +-
 drivers/media/platform/omap3isp/isppreview.c  |  1 -
 drivers/media/platform/omap3isp/ispresizer.c  |  1 -
 drivers/media/platform/omap3isp/ispstat.c     |  1 -
 drivers/media/platform/omap3isp/ispvideo.c    |  1 -
 11 files changed, 92 insertions(+), 43 deletions(-)

-- 
2.7.4

