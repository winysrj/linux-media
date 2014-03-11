Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24037 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbaCKPeN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 11:34:13 -0400
Date: Tue, 11 Mar 2014 23:33:28 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:master 448/499] ERROR: "__divdi3"
 [drivers/media/dvb-frontends/drx39xyj/drx39xyj.ko] undefined!
Message-ID: <531f2cc8.YYePUKqT+nRWFDFk%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   7b802ce7e8c67510389fdbbe29edd87a75df3a93
commit: 03fdfbfd3b5944bfd210541a83c9b222e2c20920 [448/499] [media] drx-j: Prepare to use DVBv5 stats
config: make ARCH=m68k allmodconfig

Note: the linuxtv-media/master HEAD 7b802ce7e8c67510389fdbbe29edd87a75df3a93 builds fine.
      It only hurts bisectibility.

All error/warnings:

>> ERROR: "__divdi3" [drivers/media/dvb-frontends/drx39xyj/drx39xyj.ko] undefined!

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
