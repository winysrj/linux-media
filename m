Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:25902 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbaAGMUP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jan 2014 07:20:15 -0500
Date: Tue, 07 Jan 2014 20:19:56 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:master 444/499] ERROR: "em28xx_release_resources"
 [drivers/media/usb/em28xx/em28xx-v4l.ko] undefined!
Message-ID: <52cbf0ec.rVoJq8EHONgZw51h%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   7f95c904b9d7a42c96893fddd48b7615f549c5ff
commit: 01c2819330b1e0ec6b53dcfac76ad75ff2c8ba4f [444/499] [media] em28xx: make em28xx-video to be a separate module
config: make ARCH=s390 allmodconfig

All error/warnings:

>> ERROR: "em28xx_release_resources" [drivers/media/usb/em28xx/em28xx-v4l.ko] undefined!

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
