Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38536 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444AbaIBWfs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Sep 2014 18:35:48 -0400
Date: Wed, 03 Sep 2014 06:34:46 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-media@vger.kernel.org,
	kbuild-all@01.org
Subject: [linux-devel:devel-lkp-ib04-smatch-201409030510 3/5] undefined
 reference to `__bad_ndelay'
Message-ID: <54064606.I1fka5JI7933y9Jy%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wu,

FYI, this happens on a merge commit, which indicates conflicting changes with one of the below merged branches.

cb3e62c Merge 'linuxtv-media/master' into devel-lkp-ib04-smatch-201409030510
62091c7 Merge 'net/master' into devel-lkp-ib04-smatch-201409030510
d26ff66 0day base guard for 'devel-lkp-ib04-smatch-201409030510'
69e273c Linux 3.17-rc3


tree:   git://internal_merge_and_test_tree devel-lkp-ib04-smatch-201409030510
head:   16c48c7d573c0aea12ea7f28fa4e5294d78789a7
commit: cb3e62cdd5fcf6a349f21b6dedf27684a20d2a7d [3/5] Merge 'linuxtv-media/master' into devel-lkp-ib04-smatch-201409030510
config: make ARCH=i386 allyesconfig

All error/warnings:

   drivers/built-in.o: In function `exynos4_jpeg_sw_reset':
>> (.text+0x26d1b40): undefined reference to `__bad_ndelay'
   drivers/built-in.o: In function `omap1_cam_remove':
>> omap1_camera.c:(.text+0x27184b2): undefined reference to `omap_free_dma'
   drivers/built-in.o: In function `set_dma_dest_params':
>> omap1_camera.c:(.text+0x2718e80): undefined reference to `omap_set_dma_dest_params'
>> omap1_camera.c:(.text+0x2718efb): undefined reference to `omap_set_dma_transfer_params'
   drivers/built-in.o: In function `start_capture':
>> omap1_camera.c:(.text+0x2719308): undefined reference to `omap_start_dma'
   drivers/built-in.o: In function `suspend_capture':
>> omap1_camera.c:(.text+0x2719ab3): undefined reference to `omap_stop_dma'
   drivers/built-in.o: In function `omap1_cam_probe':
>> omap1_camera.c:(.text+0x271b058): undefined reference to `omap_request_dma'
>> omap1_camera.c:(.text+0x271b0cd): undefined reference to `omap_set_dma_src_params'
>> omap1_camera.c:(.text+0x271b0eb): undefined reference to `omap_set_dma_dest_burst_mode'
>> omap1_camera.c:(.text+0x271b106): undefined reference to `omap_dma_link_lch'
>> omap1_camera.c:(.text+0x271b23f): undefined reference to `omap_free_dma'

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
