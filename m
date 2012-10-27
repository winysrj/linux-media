Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab2J0Ulz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:41:55 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKfsnb020409
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:41:55 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 24/68] [media] nuvoton-cir: carrier detect support is broken - remove it
Date: Sat, 27 Oct 2012 18:40:42 -0200
Message-Id: <1351370486-29040-25-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The carrier detect return value is never used on nuvoton driver:
drivers/media/rc/nuvoton-cir.c: In function 'nvt_process_rx_ir_data':
drivers/media/rc/nuvoton-cir.c:623:6: warning: variable 'carrier' set but not used [-Wunused-but-set-variable]
Also, this would be called only if a boolean variable is enabled,
but there's no condition that enables it inside the driver. So,
comment the carrier detection code, as it might be useful later,
and remove the unused glue code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/rc/nuvoton-cir.c | 7 ++-----
 drivers/media/rc/nuvoton-cir.h | 1 -
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 44ba834..e4ea89a 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -472,6 +472,7 @@ static void nvt_enable_wake(struct nvt_dev *nvt)
 	nvt_cir_wake_reg_write(nvt, 0, CIR_WAKE_IREN);
 }
 
+#if 0 /* Currently unused */
 /* rx carrier detect only works in learning mode, must be called w/nvt_lock */
 static u32 nvt_rx_carrier_detect(struct nvt_dev *nvt)
 {
@@ -504,7 +505,7 @@ static u32 nvt_rx_carrier_detect(struct nvt_dev *nvt)
 
 	return carrier;
 }
-
+#endif
 /*
  * set carrier frequency
  *
@@ -620,7 +621,6 @@ static void nvt_dump_rx_buf(struct nvt_dev *nvt)
 static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 {
 	DEFINE_IR_RAW_EVENT(rawir);
-	u32 carrier;
 	u8 sample;
 	int i;
 
@@ -629,9 +629,6 @@ static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 	if (debug)
 		nvt_dump_rx_buf(nvt);
 
-	if (nvt->carrier_detect_enabled)
-		carrier = nvt_rx_carrier_detect(nvt);
-
 	nvt_dbg_verbose("Processing buffer of len %d", nvt->pkts);
 
 	init_ir_raw_event(&rawir);
diff --git a/drivers/media/rc/nuvoton-cir.h b/drivers/media/rc/nuvoton-cir.h
index 0d5e087..7c3674f 100644
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -103,7 +103,6 @@ struct nvt_dev {
 
 	/* rx settings */
 	bool learning_enabled;
-	bool carrier_detect_enabled;
 
 	/* track cir wake state */
 	u8 wake_state;
-- 
1.7.11.7

