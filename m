Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7575 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbaAOWnA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 17:43:00 -0500
Date: Thu, 16 Jan 2014 06:42:57 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:master 499/499] drivers/media/rc/rc-main.c:27:1:
 sparse: symbol 'ir_core_dev_number' was not declared. Should it be static?
Message-ID: <52d70ef1./3C2AzKcF1I5bc+f%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_52d70ef1.isB3MDpG7394T4xCfNF6Uk6yaHyyYcScdDX7z6IZ/41pLniP"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--=_52d70ef1.isB3MDpG7394T4xCfNF6Uk6yaHyyYcScdDX7z6IZ/41pLniP
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

tree:   git://linuxtv.org/media_tree.git master
head:   587d1b06e07b4a079453c74ba9edf17d21931049
commit: 587d1b06e07b4a079453c74ba9edf17d21931049 [499/499] [media] rc-core: reuse device numbers
reproduce: make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/rc/rc-main.c:27:1: sparse: symbol 'ir_core_dev_number' was not declared. Should it be static?

Please consider folding the attached diff :-)

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

--=_52d70ef1.isB3MDpG7394T4xCfNF6Uk6yaHyyYcScdDX7z6IZ/41pLniP
Content-Type: text/x-diff;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="make-it-static-587d1b06e07b4a079453c74ba9edf17d21931049.diff"

From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH linuxtv-media] rc-core: ir_core_dev_number can be static
TO: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
CC: linux-media@vger.kernel.org 
CC: linux-kernel@vger.kernel.org 

CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 rc-main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 02e2f38..399eef4 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -24,7 +24,7 @@
 
 /* Bitmap to store allocated device numbers from 0 to IRRCV_NUM_DEVICES - 1 */
 #define IRRCV_NUM_DEVICES      256
-DECLARE_BITMAP(ir_core_dev_number, IRRCV_NUM_DEVICES);
+static DECLARE_BITMAP(ir_core_dev_number, IRRCV_NUM_DEVICES);
 
 /* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
 #define IR_TAB_MIN_SIZE	256

--=_52d70ef1.isB3MDpG7394T4xCfNF6Uk6yaHyyYcScdDX7z6IZ/41pLniP--
