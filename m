Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45551 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbaGUEqH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 00:46:07 -0400
Date: Mon, 21 Jul 2014 12:46:02 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [linuxtv-media:master 497/499] rtl2832_sdr.c:undefined reference to
 `__udivdi3'
Message-ID: <20140721044602.GB14600@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

The same error type has been reported, however these look easier to locate.

tree:   git://linuxtv.org/media_tree.git master
head:   2181d142707a2cf5df44840ac7112ac4568b03c9
commit: 0ba2aeb6dab80920edd9cf5b93b1ea4d6913b8f3 [497/499] [media] v4l2-ctrls: increase internal min/max/step/def to 64 bit
config: make ARCH=i386 allyesconfig

All error/warnings:

   drivers/built-in.o: In function `mt9m001_s_ctrl':
>> mt9m001.c:(.text+0x2424c6a): undefined reference to `__divdi3'
>> mt9m001.c:(.text+0x2424cfd): undefined reference to `__divdi3'
>> mt9m001.c:(.text+0x2424def): undefined reference to `__divdi3'
   drivers/built-in.o: In function `mt9t031_s_ctrl':
>> mt9t031.c:(.text+0x2427c91): undefined reference to `__divdi3'
>> mt9t031.c:(.text+0x2427d22): undefined reference to `__divdi3'
   drivers/built-in.o:mt9t031.c:(.text+0x2427e0f): more undefined references to `__divdi3' follow
   drivers/built-in.o: In function `validate_new':
   v4l2-ctrls.c:(.text+0x25a4452): undefined reference to `__udivdi3'
   v4l2-ctrls.c:(.text+0x25a44f8): undefined reference to `__udivdi3'
   v4l2-ctrls.c:(.text+0x25a4687): undefined reference to `__umoddi3'
   drivers/built-in.o: In function `gspca_coarse_grained_expo_autogain':
>> (.text+0x281c8b0): undefined reference to `__divdi3'
   drivers/built-in.o: In function `sd_s_ctrl':
>> pac7302.c:(.text+0x283d085): undefined reference to `__divdi3'
>> pac7302.c:(.text+0x283d0c4): undefined reference to `__divdi3'
>> pac7302.c:(.text+0x283d216): undefined reference to `__divdi3'
   drivers/built-in.o: In function `do_autogain':
>> sonixb.c:(.text+0x2846fd8): undefined reference to `__divdi3'
   drivers/built-in.o: In function `keene_s_ctrl':
>> radio-keene.c:(.text+0x294c621): undefined reference to `__udivdi3'
   drivers/built-in.o: In function `rtl2832_sdr_s_ctrl':
>> rtl2832_sdr.c:(.text+0x3079b82): undefined reference to `__udivdi3'

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
