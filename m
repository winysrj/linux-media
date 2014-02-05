Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:20864 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbaBELqi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Feb 2014 06:46:38 -0500
Date: Wed, 5 Feb 2014 19:46:35 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Sergio Aguirre <sergio.a.aguirre@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [linuxtv-media:master 89/499] WARNING: usleep_range should not use
 min == max args; see Documentation/timers/timers-howto.txt
Message-ID: <20140205114635.GA27786@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Sergio,

FYI, there are new warnings show up in

tree:   git://linuxtv.org/media_tree.git master
head:   9fd9330c2d0ae6c149ec817ec71797f943db98b4
commit: b4a0477c0b87c5b7a20a84df8cf81311d1efb226 [89/499] [media] v4l: omap4iss: Add support for OMAP4 camera interface - CSI receivers
:::::: branch date: 11 minutes ago
:::::: commit date: 9 weeks ago

scripts/checkpatch.pl 0001-media-v4l-omap4iss-Add-support-for-OMAP4-camera-inte.patch
# many are suggestions rather than must-fix

WARNING: usleep_range should not use min == max args; see Documentation/timers/timers-howto.txt
#548: drivers/staging/media/omap4iss/iss_csi2.c:516:
+			usleep_range(100, 100);

WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
#552: drivers/staging/media/omap4iss/iss_csi2.c:520:
+		printk(KERN_ERR "CSI2: Soft reset try count exceeded!\n");

WARNING: usleep_range should not use min == max args; see Documentation/timers/timers-howto.txt
#566: drivers/staging/media/omap4iss/iss_csi2.c:534:
+		usleep_range(100, 100);

WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
#570: drivers/staging/media/omap4iss/iss_csi2.c:538:
+		printk(KERN_ERR

WARNING: quoted string split across lines
#789: drivers/staging/media/omap4iss/iss_csi2.c:757:
+		dev_dbg(iss->dev, "CSI2: ComplexIO Error IRQ "
+			"%x\n", cpxio1_irqstatus);

WARNING: quoted string split across lines
#799: drivers/staging/media/omap4iss/iss_csi2.c:767:
+		dev_dbg(iss->dev, "CSI2 Err:"
+			" OCP:%d,"

WARNING: quoted string split across lines
#800: drivers/staging/media/omap4iss/iss_csi2.c:768:
+			" OCP:%d,"
+			" Short_pack:%d,"

WARNING: quoted string split across lines
#801: drivers/staging/media/omap4iss/iss_csi2.c:769:
+			" Short_pack:%d,"
+			" ECC:%d,"

WARNING: quoted string split across lines
#802: drivers/staging/media/omap4iss/iss_csi2.c:770:
+			" ECC:%d,"
+			" CPXIO:%d,"

WARNING: quoted string split across lines
#803: drivers/staging/media/omap4iss/iss_csi2.c:771:
+			" CPXIO:%d,"
+			" FIFO_OVF:%d,"

WARNING: quoted string split across lines
#804: drivers/staging/media/omap4iss/iss_csi2.c:772:
+			" FIFO_OVF:%d,"
+			"\n",

WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
#1649: drivers/staging/media/omap4iss/iss_csiphy.c:81:
+		printk(KERN_ERR "CSI2 CIO set power failed!\n");

WARNING: line over 80 characters
#1749: drivers/staging/media/omap4iss/iss_csiphy.c:181:
+		if (lanes->data[i].pol > 1 || lanes->data[i].pos > (csi2->phy->max_data_lanes + 1))

WARNING: line over 80 characters
#1759: drivers/staging/media/omap4iss/iss_csiphy.c:191:
+	if (lanes->clk.pol > 1 || lanes->clk.pos > (csi2->phy->max_data_lanes + 1))

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
