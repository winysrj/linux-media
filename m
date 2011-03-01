Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:23856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab1CAPiM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 10:38:12 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p21FcCkp023801
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 1 Mar 2011 10:38:12 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] nuvoton-cir: fix wake from suspend
Date: Tue,  1 Mar 2011 10:38:02 -0500
Message-Id: <1298993882-26778-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The CIR Wake FIFO is 67 bytes long, but the stock remote appears to only
populate 65 of them. Limit comparison to 65 bytes, and wake from suspend
works a whole lot better (it wasn't working at all for most folks).

Fix based on comparison with the old lirc_wb677 driver from Nuvoton,
debugging and testing done by Dave Treacy by way of the lirc mailing
list.

Reported-by: Dave Treacy <davetreacy@gmail.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/nuvoton-cir.c |    5 +++--
 drivers/media/rc/nuvoton-cir.h |    7 +++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 273d9d6..d4d6449 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -385,8 +385,9 @@ static void nvt_cir_regs_init(struct nvt_dev *nvt)
 
 static void nvt_cir_wake_regs_init(struct nvt_dev *nvt)
 {
-	/* set number of bytes needed for wake key comparison (default 67) */
-	nvt_cir_wake_reg_write(nvt, CIR_WAKE_FIFO_LEN, CIR_WAKE_FIFO_CMP_DEEP);
+	/* set number of bytes needed for wake from s3 (default 65) */
+	nvt_cir_wake_reg_write(nvt, CIR_WAKE_FIFO_CMP_BYTES,
+			       CIR_WAKE_FIFO_CMP_DEEP);
 
 	/* set tolerance/variance allowed per byte during wake compare */
 	nvt_cir_wake_reg_write(nvt, CIR_WAKE_CMP_TOLERANCE,
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index 1df8235..048135e 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -305,8 +305,11 @@ struct nvt_dev {
 #define CIR_WAKE_IRFIFOSTS_RX_EMPTY	0x20
 #define CIR_WAKE_IRFIFOSTS_RX_FULL	0x10
 
-/* CIR Wake FIFO buffer is 67 bytes long */
-#define CIR_WAKE_FIFO_LEN		67
+/*
+ * The CIR Wake FIFO buffer is 67 bytes long, but the stock remote wakes
+ * the system comparing only 65 bytes (fails with this set to 67)
+ */
+#define CIR_WAKE_FIFO_CMP_BYTES		65
 /* CIR Wake byte comparison tolerance */
 #define CIR_WAKE_CMP_TOLERANCE		5
 
-- 
1.7.1

