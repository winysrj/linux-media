Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1716 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757315AbaGXBty (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 21:49:54 -0400
Date: Thu, 24 Jul 2014 09:43:48 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 497/499]
 drivers/hid/hid-picolcd_cir.c:117:6: error: 'struct rc_dev' has no member
 named 'allowed_protos'
Message-ID: <53d064d4.uxPp5GgDNpAKanLo%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   1ee70cd7f5da2278445baf1634f7d30d514380f1
commit: 0dd0e92836cc6469e62600f981c289752ac42ac9 [497/499] [media] rc-core: remove protocol arrays
config: make ARCH=microblaze allyesconfig

All error/warnings:

   drivers/hid/hid-picolcd_cir.c: In function 'picolcd_init_cir':
>> drivers/hid/hid-picolcd_cir.c:117:6: error: 'struct rc_dev' has no member named 'allowed_protos'
     rdev->allowed_protos   = RC_BIT_ALL;
         ^

vim +117 drivers/hid/hid-picolcd_cir.c

   111		rdev = rc_allocate_device();
   112		if (!rdev)
   113			return -ENOMEM;
   114	
   115		rdev->priv             = data;
   116		rdev->driver_type      = RC_DRIVER_IR_RAW;
 > 117		rdev->allowed_protos   = RC_BIT_ALL;
   118		rdev->open             = picolcd_cir_open;
   119		rdev->close            = picolcd_cir_close;
   120		rdev->input_name       = data->hdev->name;

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
