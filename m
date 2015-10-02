Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19676 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbbJBBfJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Oct 2015 21:35:09 -0400
Date: Fri, 2 Oct 2015 09:34:25 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org
Subject: drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c:691:23-26:
 WARNING: Suspicious code. resource_size is maybe missing with res
Message-ID: <201510020918.lWcb9NHt%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   ccf70ddcbe9984cee406be2bacfedd5e4776919d
commit: 409e9eff727295b93a5dde51988a6f8646e5aa6b [media] c8sectpfe: Allow compiling it with COMPILE_TEST
date:   7 weeks ago


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c:691:23-26: WARNING: Suspicious code. resource_size is maybe missing with res

vim +691 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c

c5f5d0f9 Peter Griffin 2015-07-30  675  	if (!fei)
c5f5d0f9 Peter Griffin 2015-07-30  676  		return -ENOMEM;
c5f5d0f9 Peter Griffin 2015-07-30  677  
c5f5d0f9 Peter Griffin 2015-07-30  678  	fei->dev = dev;
c5f5d0f9 Peter Griffin 2015-07-30  679  
c5f5d0f9 Peter Griffin 2015-07-30  680  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "c8sectpfe");
c5f5d0f9 Peter Griffin 2015-07-30  681  	fei->io = devm_ioremap_resource(dev, res);
c5f5d0f9 Peter Griffin 2015-07-30  682  	if (IS_ERR(fei->io))
c5f5d0f9 Peter Griffin 2015-07-30  683  		return PTR_ERR(fei->io);
c5f5d0f9 Peter Griffin 2015-07-30  684  
c5f5d0f9 Peter Griffin 2015-07-30  685  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
c5f5d0f9 Peter Griffin 2015-07-30  686  					"c8sectpfe-ram");
c5f5d0f9 Peter Griffin 2015-07-30  687  	fei->sram = devm_ioremap_resource(dev, res);
c5f5d0f9 Peter Griffin 2015-07-30  688  	if (IS_ERR(fei->sram))
c5f5d0f9 Peter Griffin 2015-07-30  689  		return PTR_ERR(fei->sram);
c5f5d0f9 Peter Griffin 2015-07-30  690  
c5f5d0f9 Peter Griffin 2015-07-30 @691  	fei->sram_size = res->end - res->start;
c5f5d0f9 Peter Griffin 2015-07-30  692  
c5f5d0f9 Peter Griffin 2015-07-30  693  	fei->idle_irq = platform_get_irq_byname(pdev, "c8sectpfe-idle-irq");
c5f5d0f9 Peter Griffin 2015-07-30  694  	if (fei->idle_irq < 0) {
c5f5d0f9 Peter Griffin 2015-07-30  695  		dev_err(dev, "Can't get c8sectpfe-idle-irq\n");
c5f5d0f9 Peter Griffin 2015-07-30  696  		return fei->idle_irq;
c5f5d0f9 Peter Griffin 2015-07-30  697  	}
c5f5d0f9 Peter Griffin 2015-07-30  698  
c5f5d0f9 Peter Griffin 2015-07-30  699  	fei->error_irq = platform_get_irq_byname(pdev, "c8sectpfe-error-irq");

:::::: The code at line 691 was first introduced by commit
:::::: c5f5d0f99794cfb675ecacfe37a1b33b352b9752 [media] c8sectpfe: STiH407/10 Linux DVB demux support

:::::: TO: Peter Griffin <peter.griffin@linaro.org>
:::::: CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
