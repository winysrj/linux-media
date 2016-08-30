Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:32836 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751629AbcH3Mh1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Aug 2016 08:37:27 -0400
Received: by mail-lf0-f66.google.com with SMTP id f93so898015lfi.0
        for <linux-media@vger.kernel.org>; Tue, 30 Aug 2016 05:37:27 -0700 (PDT)
From: Johan Fjeldtvedt <jaffe1@gmail.com>
To: linux-media@vger.kernel.org
Cc: Johan Fjeldtvedt <jaffe1@gmail.com>
Subject: [PATCH 2/2] pulse8-cec: store logical address mask
Date: Tue, 30 Aug 2016 14:31:29 +0200
Message-Id: <20160830123129.24306-2-jaffe1@gmail.com>
In-Reply-To: <20160830123129.24306-1-jaffe1@gmail.com>
References: <20160830123129.24306-1-jaffe1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In addition to setting the ACK mask, also set the logical address mask
setting in the dongle. This is (and not the ACK mask) is persisted for
use in autonomous mode.

The logical address mask to use is deduced from the primary device type
in adap->log_addrs.

Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>
---
 drivers/staging/media/pulse8-cec/pulse8-cec.c | 34 +++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/staging/media/pulse8-cec/pulse8-cec.c b/drivers/staging/media/pulse8-cec/pulse8-cec.c
index 1158ba9..ede285a 100644
--- a/drivers/staging/media/pulse8-cec/pulse8-cec.c
+++ b/drivers/staging/media/pulse8-cec/pulse8-cec.c
@@ -498,6 +498,40 @@ static int pulse8_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
 	if (err)
 		goto unlock;
 
+	switch (adap->log_addrs.primary_device_type[0]) {
+	case CEC_OP_PRIM_DEVTYPE_TV:
+		mask = 0;
+		break;
+	case CEC_OP_PRIM_DEVTYPE_RECORD:
+		mask = 0x206;
+		break;
+	case CEC_OP_PRIM_DEVTYPE_TUNER:
+		mask = 0x4C8;
+		break;
+	case CEC_OP_PRIM_DEVTYPE_PLAYBACK:
+		mask = 0x910;
+		break;
+	case CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM:
+		mask = 0x20;
+		break;
+	case CEC_OP_PRIM_DEVTYPE_SWITCH:
+		mask = 0x8000;
+		break;
+	case CEC_OP_PRIM_DEVTYPE_PROCESSOR:
+		mask = 0x4000;
+		break;
+	default:
+		mask = 0;
+		break;
+	}
+	cmd[0] = MSGCODE_SET_LOGICAL_ADDRESS_MASK;
+	cmd[1] = mask >> 8;
+	cmd[2] = mask & 0xff;
+	err = pulse8_send_and_wait(pulse8, cmd, 3,
+				   MSGCODE_COMMAND_ACCEPTED, 0);
+	if (err)
+		goto unlock;
+
 	cmd[0] = MSGCODE_SET_DEFAULT_LOGICAL_ADDRESS;
 	cmd[1] = log_addr;
 	err = pulse8_send_and_wait(pulse8, cmd, 2,
-- 
2.9.3

