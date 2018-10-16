Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:38083 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726729AbeJPPdd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Oct 2018 11:33:33 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: report Vendor ID after initialization
Message-ID: <57c68b43-b6d0-ee7b-ed90-169851303199@xs4all.nl>
Date: Tue, 16 Oct 2018 09:44:20 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CEC specification requires that the Vendor ID (if any) is reported after
a logical address was claimed.

This was never done, so add support for this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 31d1f4ab915e..ee4decc1cd64 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1405,6 +1405,13 @@ static int cec_config_thread_func(void *arg)
 			las->log_addr[i],
 			cec_phys_addr_exp(adap->phys_addr));
 		cec_transmit_msg_fh(adap, &msg, NULL, false);
+
+		/* Report Vendor ID */
+		if (adap->log_addrs.vendor_id != CEC_VENDOR_ID_NONE) {
+			cec_msg_device_vendor_id(&msg,
+						 adap->log_addrs.vendor_id);
+			cec_transmit_msg_fh(adap, &msg, NULL, false);
+		}
 	}
 	adap->kthread_config = NULL;
 	complete(&adap->config_completion);
