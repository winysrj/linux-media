Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17719 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbaBELrI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Feb 2014 06:47:08 -0500
Date: Wed, 5 Feb 2014 19:47:06 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [linuxtv-media:master 100/499] WARNING: usleep_range should not use
 min == max args; see Documentation/timers/timers-howto.txt
Message-ID: <20140205114706.GB27786@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Laurent,

FYI, there are new warnings show up in

tree:   git://linuxtv.org/media_tree.git master
head:   9fd9330c2d0ae6c149ec817ec71797f943db98b4
commit: ca6f19b1cf0fac0fdf1ef06d6bed0f07f8f37ae9 [100/499] [media] v4l: omap4iss: Replace udelay/msleep with usleep_range
:::::: branch date: 15 minutes ago
:::::: commit date: 9 weeks ago

scripts/checkpatch.pl 0001-media-v4l-omap4iss-Replace-udelay-msleep-with-usleep.patch
# many are suggestions rather than must-fix

WARNING: usleep_range should not use min == max args; see Documentation/timers/timers-howto.txt
#31: drivers/staging/media/omap4iss/iss.c:649:
+		usleep_range(10, 10);

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
