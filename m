Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40749 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758989Ab3DDLuq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Apr 2013 07:50:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, Mike Turquette <mturquette@linaro.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH v2 0/2] OMAP3 ISP common clock framework support
Date: Thu,  4 Apr 2013 13:51:39 +0200
Message-Id: <1365076301-6542-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here's the second version of the common clock framework support for the OMAP3
ISP and MT9P031 drivers. They finally get rid of the last isp_platform_callback
operation, and thus of the isp_platform_callback structure completely, as well
as the only platform callback from the mt9p031 driver.

As with v1 the patches depend on Mike Turquette's common clock framework
reentrancy patches:

  clk: abstract locking out into helper functions
  clk: allow reentrant calls into the clk framework

v6 of those two patches has been posted to LKML and LAKML.

Changes since v1 are:

- Remove the unusued isp_xclk_init_data structure
- Move a variable declaration inside a loop

Laurent Pinchart (2):
  omap3isp: Use the common clock framework
  mt9p031: Use the common clock framework

 drivers/media/i2c/mt9p031.c           |  22 ++-
 drivers/media/platform/omap3isp/isp.c | 270 ++++++++++++++++++++++++----------
 drivers/media/platform/omap3isp/isp.h |  22 ++-
 include/media/mt9p031.h               |   2 -
 include/media/omap3isp.h              |  10 +-
 5 files changed, 233 insertions(+), 93 deletions(-)

-- 
Regards,

Laurent Pinchart

