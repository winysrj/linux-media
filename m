Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40513 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642Ab3DDLHx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Apr 2013 07:07:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, Mike Turquette <mturquette@linaro.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 0/2] OMAP3 ISP common clock framework support
Date: Thu,  4 Apr 2013 13:08:37 +0200
Message-Id: <1365073719-8038-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

These two patches implement support for the common clock framework in the OMAP3
ISP and MT9P031 drivers. They finally get rid of the last isp_platform_callback
operation, and thus of the isp_platform_callback structure completely, as well
as the only platform callback from the mt9p031 driver.

The patches depend on Mike Turquette's common clock framework reentrancy
patches:

  clk: abstract locking out into helper functions
  clk: allow reentrant calls into the clk framework

v6 of those two patches has been posted to LKML and LAKML.

Mauro, how would you like to proceed with merging these ? Mike, will the above
two patches make it to v3.10 ? If so could you please provide a stable branch
that Mauro could merge ?

Laurent Pinchart (2):
  omap3isp: Use the common clock framework
  mt9p031: Use the common clock framework

 drivers/media/i2c/mt9p031.c           |  22 ++-
 drivers/media/platform/omap3isp/isp.c | 277 +++++++++++++++++++++++++---------
 drivers/media/platform/omap3isp/isp.h |  22 ++-
 include/media/mt9p031.h               |   2 -
 include/media/omap3isp.h              |  10 +-
 5 files changed, 240 insertions(+), 93 deletions(-)

-- 
Regards,

Laurent Pinchart

