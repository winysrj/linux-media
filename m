Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35018 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726728AbeJJPxh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 11:53:37 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: rajmohan.mani@intel.com, yong.zhi@intel.com, bingbu.cao@intel.com,
        tian.shu.qiu@intel.com, jian.xu.zheng@intel.com
Subject: [PATCH 0/2] Trivial CIO2 patches
Date: Wed, 10 Oct 2018 11:32:29 +0300
Message-Id: <20181010083231.27492-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here are two simple cio2 patches. Slightly safer module removal plus a
cleanup.

Sakari Ailus (2):
  ipu3-cio2: Unregister device nodes first, then release resources
  ipu3-cio2: Use cio2_queues_exit

 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

-- 
2.11.0
