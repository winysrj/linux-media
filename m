Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49084 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535AbbFEO2I (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 10:28:08 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 09/11] [media] rc: set IR_MAX_DURATION to 500 ms
Date: Fri,  5 Jun 2015 11:27:42 -0300
Message-Id: <daba23b4412adda18157ad00eb66d6a6a7fb5164.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current definition is weird, and produce lots of sparse
warnings:

	drivers/media/i2c/cx25840/cx25840-ir.c:448 txclk_tx_s_max_pulse_width() warn: impossible condition '(ns > 4294967295) => (0-u32max > u32max)'
	drivers/media/i2c/cx25840/cx25840-ir.c:461 rxclk_rx_s_max_pulse_width() warn: impossible condition '(ns > 4294967295) => (0-u32max > u32max)'
	drivers/media/i2c/cx25840/cx25840-ir.c:706 cx25840_ir_rx_read() warn: impossible condition '(v > 4294967295) => (0-u32max > u32max)'
	drivers/media/pci/ivtv/ivtv-queue.c:145 ivtv_queue_move() error: we previously assumed 'steal' could be null (see line 138)
	drivers/media/rc/streamzap.c:155 sz_push_full_pulse() warn: impossible condition '(rawir.duration > 4294967295) => (0-u32max > u32max)'
	drivers/media/rc/streamzap.c:169 sz_push_full_pulse() warn: impossible condition '(rawir.duration > 4294967295) => (0-u32max > u32max)'
	drivers/media/rc/redrat3.c:325 redrat3_us_to_len() warn: impossible condition '(microsec > 4294967295) => (0-u32max > u32max)'
	drivers/media/rc/redrat3.c:383 redrat3_process_ir_data() warn: impossible condition '(rawir.duration > 4294967295) => (0-u32max > u32max)'
	drivers/media/usb/pvrusb2/pvrusb2-hdw.c:3676 pvr2_send_request_ex() error: we previously assumed 'write_data' could be null (see line 3648)
	drivers/media/usb/pvrusb2/pvrusb2-hdw.c:3829 pvr2_send_request_ex() error: we previously assumed 'read_data' could be null (see line 3649)
	drivers/media/pci/cx23885/cx23888-ir.c:463 txclk_tx_s_max_pulse_width() warn: impossible condition '(ns > 4294967295) => (0-u32max > u32max)'
	drivers/media/pci/cx23885/cx23888-ir.c:476 rxclk_rx_s_max_pulse_width() warn: impossible condition '(ns > 4294967295) => (0-u32max > u32max)'
	drivers/media/pci/cx23885/cx23888-ir.c:696 cx23888_ir_rx_read() warn: impossible condition '(v > 4294967295) => (0-u32max > u32max)'

Use a more realistic value for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index f1cb9daba489..45534da57759 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -242,7 +242,7 @@ static inline void init_ir_raw_event(struct ir_raw_event *ev)
 	memset(ev, 0, sizeof(*ev));
 }
 
-#define IR_MAX_DURATION         0xFFFFFFFF      /* a bit more than 4 seconds */
+#define IR_MAX_DURATION         500000000	/* 500 ms */
 #define US_TO_NS(usec)		((usec) * 1000)
 #define MS_TO_US(msec)		((msec) * 1000)
 #define MS_TO_NS(msec)		((msec) * 1000 * 1000)
-- 
2.4.2

