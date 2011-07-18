Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab1GRTyu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 15:54:50 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6IJsoX1008912
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 18 Jul 2011 15:54:50 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH v2 4/9] [media] mceusb: issue device resume cmd when needed
Date: Mon, 18 Jul 2011 15:54:24 -0400
Message-Id: <1311018869-22794-5-git-send-email-jarod@redhat.com>
In-Reply-To: <1310681394-3530-1-git-send-email-jarod@redhat.com>
References: <1310681394-3530-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to MS docs, the device firmware may halt after receiving an
unknown instruction, but that it should be possible to tell the firmware
to continue running by simply sending a device resume command. So lets
do that.

v2: use msleep instead of mdelay per Mauro's suggestion

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index ab074a3..f1fc11d 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -436,6 +436,8 @@ struct mceusb_dev {
 	char name[128];
 	char phys[64];
 	enum mceusb_model_type model;
+
+	bool need_reset;	/* flag to issue a device resume cmd */
 };
 
 /* MCE Device Command Strings, generally a port and command pair */
@@ -735,6 +737,14 @@ static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
 
 static void mce_async_out(struct mceusb_dev *ir, unsigned char *data, int size)
 {
+	int rsize = sizeof(DEVICE_RESUME);
+
+	if (ir->need_reset) {
+		ir->need_reset = false;
+		mce_request_packet(ir, DEVICE_RESUME, rsize, MCEUSB_TX);
+		msleep(10);
+	}
+
 	mce_request_packet(ir, data, size, MCEUSB_TX);
 	msleep(10);
 }
@@ -911,6 +921,9 @@ static void mceusb_handle_command(struct mceusb_dev *ir, int index)
 	case MCE_RSP_EQIRRXPORTEN:
 		ir->learning_enabled = ((hi & 0x02) == 0x02);
 		break;
+	case MCE_RSP_CMD_ILLEGAL:
+		ir->need_reset = true;
+		break;
 	default:
 		break;
 	}
-- 
1.7.1

