Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27564 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667AbaCNOcL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 10:32:11 -0400
Date: Fri, 14 Mar 2014 22:31:57 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 477/499] ERROR: "__umoddi3"
 [drivers/media/tuners/e4000.ko] undefined!
Message-ID: <532312dd.JNuz/2cNd5+lyAmK%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   ba35ca07080268af1badeb47de0f9eff28126339
commit: 0ed0b22dc594a533a959ed8995e69e2275af40d9 [477/499] [media] e4000: fix PLL calc to allow higher frequencies
config: make ARCH=m68k allmodconfig

All error/warnings:

>> ERROR: "__umoddi3" [drivers/media/tuners/e4000.ko] undefined!

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
