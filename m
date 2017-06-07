Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:36146 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751454AbdFGOqV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 10:46:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/9] cec: add cec_transmit_attempt_done helper function
Date: Wed,  7 Jun 2017 16:46:10 +0200
Message-Id: <20170607144616.15247-4-hverkuil@xs4all.nl>
In-Reply-To: <20170607144616.15247-1-hverkuil@xs4all.nl>
References: <20170607144616.15247-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A simpler variant of cec_transmit_done to be used where the HW does
just a single attempt at a transmit. So if the status indicates an
error, then the corresponding error count will always be 1 and this
function figures that out based on the status argument.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/kapi/cec-core.rst | 10 ++++++++++
 drivers/media/cec/cec-adap.c          | 26 ++++++++++++++++++++++++++
 include/media/cec.h                   |  6 ++++++
 3 files changed, 42 insertions(+)

diff --git a/Documentation/media/kapi/cec-core.rst b/Documentation/media/kapi/cec-core.rst
index 278b358b2f2e..8a65c69ed071 100644
--- a/Documentation/media/kapi/cec-core.rst
+++ b/Documentation/media/kapi/cec-core.rst
@@ -194,6 +194,11 @@ When a transmit finished (successfully or otherwise):
 	void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 		       u8 nack_cnt, u8 low_drive_cnt, u8 error_cnt);
 
+or:
+
+.. c:function::
+	void cec_transmit_attempt_done(struct cec_adapter *adap, u8 status);
+
 The status can be one of:
 
 CEC_TX_STATUS_OK:
@@ -231,6 +236,11 @@ to 1, if the hardware does support retry then either set these counters to
 0 if the hardware provides no feedback of which errors occurred and how many
 times, or fill in the correct values as reported by the hardware.
 
+The cec_transmit_attempt_done() function is a helper for cases where the
+hardware never retries, so the transmit is always for just a single
+attempt. It will call cec_transmit_done() in turn, filling in 1 for the
+count argument corresponding to the status. Or all 0 if the status was OK.
+
 When a CEC message was received:
 
 .. c:function::
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 61e39bbe3cf9..bd76c15ade4f 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -553,6 +553,32 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 }
 EXPORT_SYMBOL_GPL(cec_transmit_done);
 
+void cec_transmit_attempt_done(struct cec_adapter *adap, u8 status)
+{
+	switch (status) {
+	case CEC_TX_STATUS_OK:
+		cec_transmit_done(adap, status, 0, 0, 0, 0);
+		return;
+	case CEC_TX_STATUS_ARB_LOST:
+		cec_transmit_done(adap, status, 1, 0, 0, 0);
+		return;
+	case CEC_TX_STATUS_NACK:
+		cec_transmit_done(adap, status, 0, 1, 0, 0);
+		return;
+	case CEC_TX_STATUS_LOW_DRIVE:
+		cec_transmit_done(adap, status, 0, 0, 1, 0);
+		return;
+	case CEC_TX_STATUS_ERROR:
+		cec_transmit_done(adap, status, 0, 0, 0, 1);
+		return;
+	default:
+		/* Should never happen */
+		WARN(1, "cec-%s: invalid status 0x%02x\n", adap->name, status);
+		return;
+	}
+}
+EXPORT_SYMBOL_GPL(cec_transmit_attempt_done);
+
 /*
  * Called when waiting for a reply times out.
  */
diff --git a/include/media/cec.h b/include/media/cec.h
index 3ce73951591e..a2e184d1df00 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -227,6 +227,12 @@ int cec_transmit_msg(struct cec_adapter *adap, struct cec_msg *msg,
 /* Called by the adapter */
 void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 		       u8 nack_cnt, u8 low_drive_cnt, u8 error_cnt);
+/*
+ * Simplified version of cec_transmit_done for hardware that doesn't retry
+ * failed transmits. So this is always just one attempt in which case
+ * the status is sufficient.
+ */
+void cec_transmit_attempt_done(struct cec_adapter *adap, u8 status);
 void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);
 
 /**
-- 
2.11.0
