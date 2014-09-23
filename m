Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25245 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283AbaIWWRM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 18:17:12 -0400
Date: Wed, 24 Sep 2014 06:16:17 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Guoxiong Yan <yanguoxiong@huawei.com>
Cc: Zhangfei Gao <zhangfei.gao@linaro.org>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:devel-3.17-rc6-1 499/499]
 drivers/media/rc/ir-hix5hd2.c:94:2: error: implicit declaration of function 'writel_relaxed'
Message-ID: <5421f131.3CUmNezRckqaswAe%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git devel-3.17-rc6-1
head:   f4bbac39a84f72120579feeade95c0a7a9f0191b
commit: f4bbac39a84f72120579feeade95c0a7a9f0191b [499/499] [media] rc: Introduce hix5hd2 IR transmitter driver
config: ia64-allmodconfig
reproduce:
  wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
  chmod +x ~/bin/make.cross
  git checkout f4bbac39a84f72120579feeade95c0a7a9f0191b
  make.cross ARCH=ia64  allmodconfig
  make.cross ARCH=ia64 

All error/warnings:

   drivers/media/rc/ir-hix5hd2.c: In function 'hix5hd2_ir_config':
>> drivers/media/rc/ir-hix5hd2.c:94:2: error: implicit declaration of function 'writel_relaxed' [-Werror=implicit-function-declaration]
     writel_relaxed(0x01, priv->base + IR_ENABLE);
     ^
   drivers/media/rc/ir-hix5hd2.c: At top level:
   drivers/media/rc/ir-hix5hd2.c:293:12: warning: 'hix5hd2_ir_suspend' defined but not used [-Wunused-function]
    static int hix5hd2_ir_suspend(struct device *dev)
               ^
   drivers/media/rc/ir-hix5hd2.c:303:12: warning: 'hix5hd2_ir_resume' defined but not used [-Wunused-function]
    static int hix5hd2_ir_resume(struct device *dev)
               ^
   cc1: some warnings being treated as errors

vim +/writel_relaxed +94 drivers/media/rc/ir-hix5hd2.c

    88	
    89	static int hix5hd2_ir_config(struct hix5hd2_ir_priv *priv)
    90	{
    91		int timeout = 10000;
    92		u32 val, rate;
    93	
  > 94		writel_relaxed(0x01, priv->base + IR_ENABLE);
    95		while (readl_relaxed(priv->base + IR_BUSY)) {
    96			if (timeout--) {
    97				udelay(1);

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
