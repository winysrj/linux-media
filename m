Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27053 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbaHUWsH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 18:48:07 -0400
Date: Fri, 22 Aug 2014 06:47:12 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:devel 499/499] ERROR: "__bad_ndelay" undefined!
Message-ID: <53f676f0.P3aNjtNdkLtXRJXR%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git devel
head:   2558eeda5cd75649a1159aadca530a990b81c4ee
commit: 2558eeda5cd75649a1159aadca530a990b81c4ee [499/499] [media] enable COMPILE_TEST for media drivers
config: make ARCH=i386 allmodconfig

All error/warnings:

   ERROR: "omap_stop_dma" undefined!
   ERROR: "omap_start_dma" undefined!
   ERROR: "omap_dma_link_lch" undefined!
   ERROR: "omap_set_dma_dest_burst_mode" undefined!
   ERROR: "omap_set_dma_src_params" undefined!
   ERROR: "omap_request_dma" undefined!
   ERROR: "omap_set_dma_transfer_params" undefined!
   ERROR: "omap_set_dma_dest_params" undefined!
   ERROR: "omap_free_dma" undefined!
>> ERROR: "__bad_ndelay" undefined!
   ERROR: "omapdss_compat_init" undefined!
   ERROR: "omap_dss_get_overlay_manager" undefined!
   ERROR: "omap_dss_get_num_overlay_managers" undefined!
   ERROR: "omap_dss_get_overlay" undefined!
   ERROR: "omapdss_is_initialized" undefined!
   ERROR: "omap_dispc_register_isr" undefined!
   ERROR: "omapdss_get_version" undefined!
   ERROR: "omap_dss_put_device" undefined!
   ERROR: "omap_dss_get_next_device" undefined!
   ERROR: "omap_dispc_unregister_isr" undefined!
   ERROR: "omapdss_compat_uninit" undefined!
   ERROR: "omap_dss_get_device" undefined!
   ERROR: "omap_dss_get_num_overlays" undefined!
   ERROR: "vpif_lock" undefined!
   ERROR: "vpif_lock" undefined!

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
