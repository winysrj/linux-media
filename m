Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:6491 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbaAMXNt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 18:13:49 -0500
Date: Tue, 14 Jan 2014 07:13:42 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Tim Mester <ttmesterr@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 491/499]
 drivers/media/usb/au0828/au0828-dvb.c:36:5: sparse: symbol
 'preallocate_big_buffers' was not declared. Should it be static?
Message-ID: <52d47326.DQmGlI++pFiabc8n%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_52d47326.GkSoG8vb8o6GDz26CRiKyzPN/7Ex5gs1GyeFKcw04NvnzWNE"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--=_52d47326.GkSoG8vb8o6GDz26CRiKyzPN/7Ex5gs1GyeFKcw04NvnzWNE
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

tree:   git://linuxtv.org/media_tree.git master
head:   eab924d0e2bdfd53c902162b0b499b8464c1fb4a
commit: f251b3e78cc57411627d825eae3c911da77b4035 [491/499] [media] au0828: Add option to preallocate digital transfer buffers
reproduce: make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/usb/au0828/au0828-dvb.c:36:5: sparse: symbol 'preallocate_big_buffers' was not declared. Should it be static?

Please consider folding the attached diff :-)

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

--=_52d47326.GkSoG8vb8o6GDz26CRiKyzPN/7Ex5gs1GyeFKcw04NvnzWNE
Content-Type: text/x-diff;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="make-it-static-f251b3e78cc57411627d825eae3c911da77b4035.diff"

From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH linuxtv-media] au0828: preallocate_big_buffers can be static
TO: Tim Mester <ttmesterr@gmail.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
CC: linux-media@vger.kernel.org 
CC: linux-kernel@vger.kernel.org 

CC: Tim Mester <ttmesterr@gmail.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 au0828-dvb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index 19fe049..4ae8b10 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -33,7 +33,7 @@
 #include "mxl5007t.h"
 #include "tda18271.h"
 
-int preallocate_big_buffers;
+static int preallocate_big_buffers;
 module_param_named(preallocate_big_buffers, preallocate_big_buffers, int, 0644);
 MODULE_PARM_DESC(preallocate_big_buffers, "Preallocate the larger transfer buffers at module load time");
 

--=_52d47326.GkSoG8vb8o6GDz26CRiKyzPN/7Ex5gs1GyeFKcw04NvnzWNE--
