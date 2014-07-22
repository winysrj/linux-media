Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:8013 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbaGVHCT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 03:02:19 -0400
Date: Tue, 22 Jul 2014 15:02:20 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 441/499] ERROR: "__aeabi_uldivmod"
 [drivers/media/dvb-frontends/rtl2832_sdr.ko] undefined!
Message-ID: <53ce0c7c.HHIfWDSrtQgLcJTo%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   a733291d6934d0663af9e7d9f2266ab87a2946cd
commit: 77bbb2b049c1c3e935f5bec510bec337d94ae8f8 [441/499] rtl2832_sdr: move from staging to media
config: make ARCH=arm allmodconfig

Note: the linuxtv-media/master HEAD a733291d6934d0663af9e7d9f2266ab87a2946cd builds fine.
      It only hurts bisectibility.

All error/warnings:

>> ERROR: "__aeabi_uldivmod" [drivers/media/dvb-frontends/rtl2832_sdr.ko] undefined!

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
