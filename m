Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52622 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752861AbcBURk2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 12:40:28 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com
Subject: [PATCH v3 0/4] Unify MC graph power management code
Date: Sun, 21 Feb 2016 18:25:07 +0200
Message-Id: <1456071911-3284-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This is the third version of the MC graph power management patches.

v2 can be found here:

<URL:http://www.spinics.net/lists/linux-media/msg96807.html>

since v2:

- Rebase on top of current media-tree.git master branch, including
  dropping the first patch from the set as it was already merged

- Document the added pm_count_walk field in KernelDoc

- Fix a compiler warning in patch "media: Always keep a graph walk large
  enough around" (a GCC bug related to struct value assignment in variable
  declaration)

-- 
Kind regards,
Sakari

