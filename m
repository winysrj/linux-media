Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40165 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbaBELsS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Feb 2014 06:48:18 -0500
Date: Wed, 5 Feb 2014 19:47:46 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Sergio Aguirre <sergio.a.aguirre@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [media:v4l_for_linus 91/499] WARNING: usleep_range should not use
 min == max args; see Documentation/timers/timers-howto.txt
Message-ID: <20140205114746.GB27938@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Sergio,

FYI, there are new warnings show up in

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
head:   6c3df5da67f1f53df78c7e20cd53a481dc28eade
commit: b4a0477c0b87c5b7a20a84df8cf81311d1efb226 [91/499] [media] v4l: omap4iss: Add support for OMAP4 camera interface - CSI receivers
:::::: branch date: 2 days ago
:::::: commit date: 8 weeks ago

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
