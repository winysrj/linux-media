Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43474 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbaHVA0I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 20:26:08 -0400
Date: Fri, 22 Aug 2014 08:25:22 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:devel 498/499] ERROR: "omapdss_compat_init"
 [drivers/media/platform/omap/omap-vout.ko] undefined!
Message-ID: <53f68df2.FMHNlJtoZwQGwn/b%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git devel
head:   2558eeda5cd75649a1159aadca530a990b81c4ee
commit: ace9078f1c07b94332e37a5017bb34097e082e54 [498/499] [media] enable COMPILE_TEST for OMAP2 vout
config: make ARCH=s390 allmodconfig

All error/warnings:

>> ERROR: "omapdss_compat_init" [drivers/media/platform/omap/omap-vout.ko] undefined!
>> ERROR: "omap_dss_get_overlay_manager" [drivers/media/platform/omap/omap-vout.ko] undefined!
>> ERROR: "omap_dss_get_num_overlay_managers" [drivers/media/platform/omap/omap-vout.ko] undefined!
>> ERROR: "omap_dss_get_overlay" [drivers/media/platform/omap/omap-vout.ko] undefined!
>> ERROR: "omapdss_is_initialized" [drivers/media/platform/omap/omap-vout.ko] undefined!
>> ERROR: "omap_dispc_register_isr" [drivers/media/platform/omap/omap-vout.ko] undefined!
>> ERROR: "omapdss_get_version" [drivers/media/platform/omap/omap-vout.ko] undefined!
>> ERROR: "omap_dss_put_device" [drivers/media/platform/omap/omap-vout.ko] undefined!
>> ERROR: "omap_dss_get_next_device" [drivers/media/platform/omap/omap-vout.ko] undefined!
>> ERROR: "omap_dispc_unregister_isr" [drivers/media/platform/omap/omap-vout.ko] undefined!
>> ERROR: "omapdss_compat_uninit" [drivers/media/platform/omap/omap-vout.ko] undefined!
>> ERROR: "omap_dss_get_device" [drivers/media/platform/omap/omap-vout.ko] undefined!
>> ERROR: "omap_dss_get_num_overlays" [drivers/media/platform/omap/omap-vout.ko] undefined!

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
