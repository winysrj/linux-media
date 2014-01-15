Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39156 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbaAOVus (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 16:50:48 -0500
Date: Thu, 16 Jan 2014 05:50:26 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [linuxtv-media:master 498/499]
 drivers/media/usb/em28xx/em28xx-cards.c:69:1: sparse: symbol
 'em28xx_devused' was not declared. Should it be static?
Message-ID: <52d702a2.3xNe6Vk+dVOUjrR9%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_52d702a2.W1/cTnI+DgpmO1guwC1+aHEuUQ9pLWVxTEBqFEKNUtLu1Y58"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--=_52d702a2.W1/cTnI+DgpmO1guwC1+aHEuUQ9pLWVxTEBqFEKNUtLu1Y58
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

tree:   git://linuxtv.org/media_tree.git master
head:   587d1b06e07b4a079453c74ba9edf17d21931049
commit: c3aed262186841bf01feb9603885671ea567ebd9 [498/499] [media] em28xx-cards: properly initialize the device bitmap
reproduce: make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/usb/em28xx/em28xx-cards.c:69:1: sparse: symbol 'em28xx_devused' was not declared. Should it be static?
   drivers/media/usb/em28xx/em28xx-cards.c:2163:36: sparse: cannot size expression

Please consider folding the attached diff :-)

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

--=_52d702a2.W1/cTnI+DgpmO1guwC1+aHEuUQ9pLWVxTEBqFEKNUtLu1Y58
Content-Type: text/x-diff;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="make-it-static-c3aed262186841bf01feb9603885671ea567ebd9.diff"

From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH linuxtv-media] em28xx-cards: em28xx_devused can be static
TO: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
CC: linux-media@vger.kernel.org 
CC: linux-kernel@vger.kernel.org 

CC: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 em28xx-cards.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 4d97a76..eb39903 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -66,7 +66,7 @@ MODULE_PARM_DESC(usb_xfer_mode,
 
 
 /* Bitmask marking allocated devices from 0 to EM28XX_MAXBOARDS - 1 */
-DECLARE_BITMAP(em28xx_devused, EM28XX_MAXBOARDS);
+static DECLARE_BITMAP(em28xx_devused, EM28XX_MAXBOARDS);
 
 struct em28xx_hash_table {
 	unsigned long hash;

--=_52d702a2.W1/cTnI+DgpmO1guwC1+aHEuUQ9pLWVxTEBqFEKNUtLu1Y58--
