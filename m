Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19173 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbaGRCuw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 22:50:52 -0400
Date: Fri, 18 Jul 2014 10:50:27 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 470/499] ERROR: "__aeabi_uldivmod"
 [drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.ko] undefined!
Message-ID: <53c88b73.EUNyETlXK5NV9LSY%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   0ca1ba2aac5f6b26672099b13040c5b40db93486
commit: 3ed1a0023c48db707db537ef8aeb21445db637a6 [470/499] [media] v4l: omap4iss: tighten omap4iss dependencies
config: make ARCH=arm allmodconfig

All error/warnings:

>> ERROR: "__aeabi_uldivmod" [drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.ko] undefined!

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
