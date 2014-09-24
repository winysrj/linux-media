Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:62636 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbaIXBA0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 21:00:26 -0400
Date: Wed, 24 Sep 2014 08:59:57 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Akihiro Tsukada <tskd08@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:devel-3.17-rc6 492/499] ERROR: "__aeabi_ldivmod"
 [drivers/media/tuners/qm1d1c0042.ko] undefined!
Message-ID: <5422178d.oJU4Z5V14CMUtNSt%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git devel-3.17-rc6
head:   5b5560842a7ee002d208a20866f88fafd63198eb
commit: f5a98f37a535a43b3a27c6a63b07f23d248e4b31 [492/499] [media] pt3: add support for Earthsoft PT3 ISDB-S/T receiver card
config: arm-allmodconfig
reproduce:
  wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
  chmod +x ~/bin/make.cross
  git checkout f5a98f37a535a43b3a27c6a63b07f23d248e4b31
  make.cross ARCH=arm  allmodconfig
  make.cross ARCH=arm 

All error/warnings:

>> ERROR: "__aeabi_ldivmod" [drivers/media/tuners/qm1d1c0042.ko] undefined!
>> ERROR: "__aeabi_ldivmod" [drivers/media/dvb-frontends/tc90522.ko] undefined!

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
