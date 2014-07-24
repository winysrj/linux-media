Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16370 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758482AbaGXDbr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 23:31:47 -0400
Date: Thu, 24 Jul 2014 11:31:56 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 496/499] drivers/media/rc/st_rc.c:290:6:
 error: 'struct rc_dev' has no member named 'allowed_protos'
Message-ID: <53d07e2c.208vUXtur83Hznkw%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   488046c237f3b78f91046d45662b318cd2415f64
commit: 0dd0e92836cc6469e62600f981c289752ac42ac9 [496/499] [media] rc-core: remove protocol arrays
config: make ARCH=arm allmodconfig

Note: the linuxtv-media/master HEAD 488046c237f3b78f91046d45662b318cd2415f64 builds fine.
      It only hurts bisectibility.

All error/warnings:

   drivers/media/rc/st_rc.c: In function 'st_rc_probe':
>> drivers/media/rc/st_rc.c:290:6: error: 'struct rc_dev' has no member named 'allowed_protos'
     rdev->allowed_protos = RC_BIT_ALL;
         ^
--
   drivers/media/rc/sunxi-cir.c: In function 'sunxi_ir_probe':
>> drivers/media/rc/sunxi-cir.c:213:2: error: called object is not a function or function pointer
     ir->rc->allowed_protocols(ir->rc, RC_BIT_ALL);
     ^

vim +290 drivers/media/rc/st_rc.c

   284	
   285		rc_dev->dev = dev;
   286		platform_set_drvdata(pdev, rc_dev);
   287		st_rc_hardware_init(rc_dev);
   288	
   289		rdev->driver_type = RC_DRIVER_IR_RAW;
 > 290		rdev->allowed_protos = RC_BIT_ALL;
   291		/* rx sampling rate is 10Mhz */
   292		rdev->rx_resolution = 100;
   293		rdev->timeout = US_TO_NS(MAX_SYMB_TIME);

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
