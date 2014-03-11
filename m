Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:45744 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbaCKP5n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 11:57:43 -0400
Date: Tue, 11 Mar 2014 23:49:39 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:master 446/499] drxj.c:undefined reference to
 `__divdi3'
Message-ID: <531f3093.9Kj05aLSRFQ/cnCy%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   c3c2077d9579472b07581ecdaf6cc5a60b1700bc
commit: 03fdfbfd3b5944bfd210541a83c9b222e2c20920 [446/499] [media] drx-j: Prepare to use DVBv5 stats
config: make ARCH=i386 allyesconfig

Note: the linuxtv-media/master HEAD c3c2077d9579472b07581ecdaf6cc5a60b1700bc builds fine.
      It only hurts bisectibility.

All error/warnings:

   drivers/built-in.o: In function `drx39xxj_read_snr':
>> drxj.c:(.text+0x1277c0d): undefined reference to `__divdi3'

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
