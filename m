Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46460 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751204AbdGMPXw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 11:23:52 -0400
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1001])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 38DD8600C3
        for <linux-media@vger.kernel.org>; Thu, 13 Jul 2017 18:23:48 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 0/6] Media controller and omap3isp cleanups
Date: Thu, 13 Jul 2017 18:23:43 +0300
Message-Id: <20170713152349.14480-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

These patches prepare for media device refcounting but do not bring those
changes yet. They're worthwhile on their own merits.

since v1:

- Use IS_ERR_OR_NULL() check in error handling for omap3isp_hist_init()
  instead of IS_ERR() --- the argument may be NULL as well.

Sakari Ailus (6):
  omap3isp: Don't rely on devm for memory resource management
  omap3isp: Call video_unregister_device() unconditionally
  omap3isp: Remove misleading comment
  omap3isp: Disable streaming at driver unbind time
  media: Remove useless curly braces and parentheses
  media: devnode: Rename mdev argument as devnode

 drivers/media/media-device.c                  |  9 ++++-----
 drivers/media/platform/omap3isp/isp.c         | 18 ++++++++++++------
 drivers/media/platform/omap3isp/isph3a_aewb.c | 24 +++++++++++++++++-------
 drivers/media/platform/omap3isp/isph3a_af.c   | 24 +++++++++++++++++-------
 drivers/media/platform/omap3isp/isphist.c     | 11 +++++++----
 drivers/media/platform/omap3isp/ispstat.c     |  2 ++
 drivers/media/platform/omap3isp/ispvideo.c    | 27 ++++++++++++++++-----------
 7 files changed, 75 insertions(+), 40 deletions(-)

-- 
2.11.0
