Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:59144 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751180AbdFBHbb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Jun 2017 03:31:31 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Maling list - DRI developers
        <dri-devel@lists.freedesktop.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: add cec_transmit_attempt_done helper function
Message-ID: <e90b4d52-f88e-1dd3-dbf5-42821b580e8b@xs4all.nl>
Date: Fri, 2 Jun 2017 09:31:25 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A simpler variant of cec_transmit_done to be used where the HW does
just a single attempt at a transmit. So if the status indicates an
error, then the corresponding error count will always be 1 and this
function figures that out based on the status argument.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Russell, this should simplify things for you.
---
  Documentation/media/kapi/cec-core.rst | 10 ++++++++++
  drivers/media/cec/cec-adap.c          | 26 ++++++++++++++++++++++++++
  include/media/cec.h                   |  6 ++++++
  3 files changed, 42 insertions(+)

diff --git a/Documentation/media/kapi/cec-core.rst b/Documentation/media/kapi/cec-core.rst
index 7a04c5386dc8..25728545e4ec 100644
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
+hardware never retries, so the transmit was always for just a single
+attempt. It will call cec_transmit_done() in turn, filling in 1 for the
+count argument corresponding to the status. Or all 0 if the status was OK.
+
  When a CEC message was received:

  .. c:function::
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index f5fe01c9da8a..0f4621cd8748 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -544,6 +544,32 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
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
index b8eb895731d5..5582e1cac1b9 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -223,6 +223,12 @@ int cec_transmit_msg(struct cec_adapter *adap, struct cec_msg *msg,
  /* Called by the adapter */
  void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
  		       u8 nack_cnt, u8 low_drive_cnt, u8 error_cnt);
+/*
+ * Simplified version of cec_transmit_done for hardware that doesn't retry
+ * failed transmits. So this is was always just one attempt in which case
+ * the status is sufficient.
+ */
+void cec_transmit_attempt_done(struct cec_adapter *adap, u8 status);
  void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);

  /**
-- 
2.11.0
