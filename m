Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43843 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759338AbaGXP26 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jul 2014 11:28:58 -0400
Date: Thu, 24 Jul 2014 23:27:59 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [next:master 7657/8702] drivers/media/platform/coda.c:3734:2:
 error: implicit declaration of function 'devm_reset_control_get'
Message-ID: <53d125ff.1T11dzM12ENQarQp%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   1a58d9909611972fd1c081bb04a9f7dc2571e612
commit: 8f45284c4ed758174d22342aca1bb7299f76b012 [7657/8702] [media] coda: add reset control support
config: make ARCH=arm imx_v4_v5_defconfig

All error/warnings:

   drivers/media/platform/coda.c: In function 'coda_probe':
>> drivers/media/platform/coda.c:3734:2: error: implicit declaration of function 'devm_reset_control_get' [-Werror=implicit-function-declaration]
     dev->rstc = devm_reset_control_get(&pdev->dev, NULL);
     ^
>> drivers/media/platform/coda.c:3734:12: warning: assignment makes pointer from integer without a cast
     dev->rstc = devm_reset_control_get(&pdev->dev, NULL);
               ^
   cc1: some warnings being treated as errors

vim +/devm_reset_control_get +3734 drivers/media/platform/coda.c

  3728		if (devm_request_threaded_irq(&pdev->dev, irq, NULL, coda_irq_handler,
  3729			IRQF_ONESHOT, dev_name(&pdev->dev), dev) < 0) {
  3730			dev_err(&pdev->dev, "failed to request irq\n");
  3731			return -ENOENT;
  3732		}
  3733	
> 3734		dev->rstc = devm_reset_control_get(&pdev->dev, NULL);
  3735		if (IS_ERR(dev->rstc)) {
  3736			ret = PTR_ERR(dev->rstc);
  3737			if (ret == -ENOENT) {

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
