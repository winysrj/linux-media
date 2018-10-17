Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:33932 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727000AbeJQTA4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 15:00:56 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: add debug_phys_addr module option
Message-ID: <e6371c40-f004-d826-cda8-d4d131728920@xs4all.nl>
Date: Wed, 17 Oct 2018 13:05:41 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If debug_phys_addr is set, then CEC_CAP_PHYS_ADDR is added to the CEC
adapter capabilities.

This allows for testing CEC even if the physical address isn't set. This
makes it possible to connect two HDMI outputs together and still use CEC.
Very useful for testing CEC if you don't have access to an HDMI receiver
under linux.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index e4edc930d4ed..cc875dabd765 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -24,6 +24,10 @@ int cec_debug;
 module_param_named(debug, cec_debug, int, 0644);
 MODULE_PARM_DESC(debug, "debug level (0-2)");

+static bool debug_phys_addr;
+module_param(debug_phys_addr, bool, 0644);
+MODULE_PARM_DESC(debug_phys_addr, "add CEC_CAP_PHYS_ADDR if set");
+
 static dev_t cec_dev_t;

 /* Active devices */
@@ -270,6 +274,8 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 	adap->log_addrs.cec_version = CEC_OP_CEC_VERSION_2_0;
 	adap->log_addrs.vendor_id = CEC_VENDOR_ID_NONE;
 	adap->capabilities = caps;
+	if (debug_phys_addr)
+		adap->capabilities |= CEC_CAP_PHYS_ADDR;
 	adap->needs_hpd = caps & CEC_CAP_NEEDS_HPD;
 	adap->available_log_addrs = available_las;
 	adap->sequence = 0;
