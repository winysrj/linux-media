Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:56126 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756965Ab1KORuK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 12:50:10 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 0/9] as3645a: set of fixes up
Date: Tue, 15 Nov 2011 19:49:52 +0200
Message-Id: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <1321374065-20063-3-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1321374065-20063-3-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series incorporates Sakari's comments and couple of fixes from my version
of the driver.

Andy Shevchenko (9):
  as3645a: mention lm3555 as a clone of that chip
  as3645a: print vendor and revision of the chip
  as3645a: remove unused code
  as3645a: No error, no message.
  as3645a: move limits to the platform_data
  as3645a: free resources in case of error properly
  as3645a: use struct dev_pm_ops
  as3645a: use pr_err macro instead of printk KERN_ERR
  as3645a: use the same timeout for hw and sw strobes

 drivers/media/video/as3645a.c |   76 ++++++++++++++++++-----------------------
 include/media/as3645a.h       |   32 +++++++----------
 2 files changed, 46 insertions(+), 62 deletions(-)

-- 
1.7.7.1

