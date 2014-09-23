Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:7238 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186AbaIWXKM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 19:10:12 -0400
Date: Wed, 24 Sep 2014 06:59:24 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Guoxiong Yan <yanguoxiong@huawei.com>
Cc: Zhangfei Gao <zhangfei.gao@linaro.org>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:devel-3.17-rc6 489/499]
 drivers/media/rc/ir-hix5hd2.c:100:2: error: implicit declaration of
 function 'readl_relaxed'
Message-ID: <5421fb4c.SFjCtT1qIBEQWCDI%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git devel-3.17-rc6
head:   49310ed0ab8da344dece4a543bfcdd14490ccfa0
commit: a84fcdaa905862b09482544d190c94a8436e4334 [489/499] [media] rc: Introduce hix5hd2 IR transmitter driver
config: m68k-allmodconfig
reproduce:
  wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
  chmod +x ~/bin/make.cross
  git checkout a84fcdaa905862b09482544d190c94a8436e4334
  make.cross ARCH=m68k  allmodconfig
  make.cross ARCH=m68k 

All error/warnings:

   drivers/media/rc/ir-hix5hd2.c: In function 'hix5hd2_ir_config':
>> drivers/media/rc/ir-hix5hd2.c:100:2: error: implicit declaration of function 'readl_relaxed' [-Werror=implicit-function-declaration]
     while (readl_relaxed(priv->base + IR_BUSY)) {
     ^
   cc1: some warnings being treated as errors

vim +/readl_relaxed +100 drivers/media/rc/ir-hix5hd2.c

    94	static int hix5hd2_ir_config(struct hix5hd2_ir_priv *priv)
    95	{
    96		int timeout = 10000;
    97		u32 val, rate;
    98	
    99		writel_relaxed(0x01, priv->base + IR_ENABLE);
 > 100		while (readl_relaxed(priv->base + IR_BUSY)) {
   101			if (timeout--) {
   102				udelay(1);
   103			} else {

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
