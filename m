Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20305 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbaIWXZN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 19:25:13 -0400
Date: Wed, 24 Sep 2014 07:24:50 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Akihiro Tsukada <tskd08@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:devel-3.17-rc6 497/499] qm1d1c0042.c:undefined
 reference to `__divdi3'
Message-ID: <54220142.tA7qDiv8B+WKhZGx%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git devel-3.17-rc6
head:   49310ed0ab8da344dece4a543bfcdd14490ccfa0
commit: f5a98f37a535a43b3a27c6a63b07f23d248e4b31 [497/499] [media] pt3: add support for Earthsoft PT3 ISDB-S/T receiver card
config: i386-allyesconfig
reproduce:
  git checkout f5a98f37a535a43b3a27c6a63b07f23d248e4b31
  make ARCH=i386  allyesconfig
  make ARCH=i386 

All error/warnings:

   drivers/built-in.o: In function `qm1d1c0042_set_params':
>> qm1d1c0042.c:(.text+0x2519730): undefined reference to `__divdi3'
   drivers/built-in.o: In function `tc90522t_get_frontend':
>> tc90522.c:(.text+0x260b64c): undefined reference to `__divdi3'
>> tc90522.c:(.text+0x260b685): undefined reference to `__divdi3'
>> tc90522.c:(.text+0x260b6bb): undefined reference to `__divdi3'
>> tc90522.c:(.text+0x260b713): undefined reference to `__divdi3'
   drivers/built-in.o:tc90522.c:(.text+0x260bb64): more undefined references to `__divdi3' follow

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
