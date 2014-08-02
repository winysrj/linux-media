Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53564 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbaHBDtO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Aug 2014 23:49:14 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/5] ddbridge: disable driver building
Date: Sat,  2 Aug 2014 06:48:52 +0300
Message-Id: <1406951335-24026-3-git-send-email-crope@iki.fi>
In-Reply-To: <1406951335-24026-1-git-send-email-crope@iki.fi>
References: <1406951335-24026-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Disable building that driver for a wile. We do massive driver
update from latest vendor driver and this is to avoid Kernel
compilation breakage.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/pci/ddbridge/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/Makefile b/drivers/media/pci/ddbridge/Makefile
index 7446c8b..39e922c 100644
--- a/drivers/media/pci/ddbridge/Makefile
+++ b/drivers/media/pci/ddbridge/Makefile
@@ -4,7 +4,8 @@
 
 ddbridge-objs := ddbridge-core.o
 
-obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
+#obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
+obj-$() += ddbridge.o
 
 ccflags-y += -Idrivers/media/dvb-core/
 ccflags-y += -Idrivers/media/dvb-frontends/
-- 
http://palosaari.fi/

