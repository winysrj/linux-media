Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26338 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356AbbEUKSI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 06:18:08 -0400
Date: Thu, 21 May 2015 18:16:36 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Jemma Denson <jdenson@gmail.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [linuxtv-media:master 1013/1029]
 drivers/media/dvb-frontends/cx24120.c:806:6: sparse: symbol
 'cx24120_calculate_ber_window' was not declared. Should it be static?
Message-ID: <201505211815.u8Tcv6qa%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   2a80f296422a01178d0a993479369e94f5830127
commit: ddcb252e41c15b360c0e9a172fbd29d3f0ed18cd [1013/1029] [media] cx24120: Add in dvbv5 stats for bit error rate
reproduce:
  # apt-get install sparse
  git checkout ddcb252e41c15b360c0e9a172fbd29d3f0ed18cd
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/dvb-frontends/cx24120.c:806:6: sparse: symbol 'cx24120_calculate_ber_window' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
