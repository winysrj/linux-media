Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab2HNCxV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 22:53:21 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7E2rKwC012891
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 13 Aug 2012 22:53:20 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] b2c2: frontends/tuners are not needed at the bridge binding
Date: Mon, 13 Aug 2012 23:53:16 -0300
Message-Id: <1344912796-9555-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The frontends/tuners are used inside the common part of the driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/b2c2/Makefile | 2 --
 drivers/media/usb/b2c2/Makefile | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/media/pci/b2c2/Makefile b/drivers/media/pci/b2c2/Makefile
index e90e236..aedcac1 100644
--- a/drivers/media/pci/b2c2/Makefile
+++ b/drivers/media/pci/b2c2/Makefile
@@ -6,6 +6,4 @@ b2c2-flexcop-pci-objs = flexcop-pci.o
 obj-$(CONFIG_DVB_B2C2_FLEXCOP_PCI) += b2c2-flexcop-pci.o
 
 ccflags-y += -Idrivers/media/dvb-core/
-ccflags-y += -Idrivers/media/dvb-frontends/
-ccflags-y += -Idrivers/media/common/tuners/
 ccflags-y += -Idrivers/media/common/b2c2/
diff --git a/drivers/media/usb/b2c2/Makefile b/drivers/media/usb/b2c2/Makefile
index 2f7ee5c..ace9d76 100644
--- a/drivers/media/usb/b2c2/Makefile
+++ b/drivers/media/usb/b2c2/Makefile
@@ -2,6 +2,4 @@ b2c2-flexcop-usb-objs = flexcop-usb.o
 obj-$(CONFIG_DVB_B2C2_FLEXCOP_USB) += b2c2-flexcop-usb.o
 
 ccflags-y += -Idrivers/media/dvb-core/
-ccflags-y += -Idrivers/media/dvb-frontends/
-ccflags-y += -Idrivers/media/tuners/
 ccflags-y += -Idrivers/media/common/b2c2/
-- 
1.7.11.2

