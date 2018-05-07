Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37966 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752274AbeEGMrZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 08:47:25 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@kernel.org
Subject: [PATCH 0/2] omap3isp cleanups
Date: Mon,  7 May 2018 15:47:21 +0300
Message-Id: <20180507124723.2153-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

These patches fix a useless check in ispstat as well as get rid of the
GFP_DMA.

Sakari Ailus (2):
  omap3isp: Remove useless NULL check in omap3isp_stat_config
  omap3isp: Don't use GFP_DMA

 drivers/media/platform/omap3isp/ispstat.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

-- 
2.11.0
