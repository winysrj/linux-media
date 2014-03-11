Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57307 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbaCKUTk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 16:19:40 -0400
Date: Wed, 12 Mar 2014 04:19:19 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:master 428/499] ERROR: "__divdi3" undefined!
Message-ID: <531f6fc7.C+hPdWlRiKG/fhU3%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   262912335c823a2bbcc87003ee55d62cc27f4e48
commit: 03fdfbfd3b5944bfd210541a83c9b222e2c20920 [428/499] [media] drx-j: Prepare to use DVBv5 stats
config: make ARCH=mips allmodconfig

Note: the linuxtv-media/master HEAD 262912335c823a2bbcc87003ee55d62cc27f4e48 builds fine.
      It only hurts bisectibility.

All error/warnings:

>> ERROR: "__divdi3" undefined!

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
