Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43234 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754944AbcHSNFP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 09:05:15 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kamil Debski <kamil@wypas.org>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 13/15] [media] cec-core: Convert it to ReST format
Date: Fri, 19 Aug 2016 10:05:03 -0300
Message-Id: <b85163fc1723bdb240ce3136552ac1683999051c.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some things there that aren't ok for ReST format.

Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/cec-core.rst | 145 ++++++++++++++++++++++------------
 1 file changed, 93 insertions(+), 52 deletions(-)

diff --git a/Documentation/media/kapi/cec-core.rst b/Documentation/media/kapi/cec-core.rst
index 75155fe37153..88c33b53ec13 100644
--- a/Documentation/media/kapi/cec-core.rst
+++ b/Documentation/media/kapi/cec-core.rst
@@ -36,39 +36,50 @@ CEC Adapter
 The struct cec_adapter represents the CEC adapter hardware. It is created by
 calling cec_allocate_adapter() and deleted by calling cec_delete_adapter():
 
-struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
+.. c:function::
+   struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 	       void *priv, const char *name, u32 caps, u8 available_las,
 	       struct device *parent);
-void cec_delete_adapter(struct cec_adapter *adap);
+
+.. c:function::
+   void cec_delete_adapter(struct cec_adapter *adap);
 
 To create an adapter you need to pass the following information:
 
-ops: adapter operations which are called by the CEC framework and that you
-have to implement.
+ops:
+	adapter operations which are called by the CEC framework and that you
+	have to implement.
 
-priv: will be stored in adap->priv and can be used by the adapter ops.
+priv:
+	will be stored in adap->priv and can be used by the adapter ops.
 
-name: the name of the CEC adapter. Note: this name will be copied.
+name:
+	the name of the CEC adapter. Note: this name will be copied.
 
-caps: capabilities of the CEC adapter. These capabilities determine the
+caps:
+	capabilities of the CEC adapter. These capabilities determine the
 	capabilities of the hardware and which parts are to be handled
 	by userspace and which parts are handled by kernelspace. The
 	capabilities are returned by CEC_ADAP_G_CAPS.
 
-available_las: the number of simultaneous logical addresses that this
+available_las:
+	the number of simultaneous logical addresses that this
 	adapter can handle. Must be 1 <= available_las <= CEC_MAX_LOG_ADDRS.
 
-parent: the parent device.
+parent:
+	the parent device.
 
 
 To register the /dev/cecX device node and the remote control device (if
 CEC_CAP_RC is set) you call:
 
-int cec_register_adapter(struct cec_adapter *adap);
+.. c:function::
+	int cec_register_adapter(struct cec_adapter \*adap);
 
 To unregister the devices call:
 
-void cec_unregister_adapter(struct cec_adapter *adap);
+.. c:function::
+	void cec_unregister_adapter(struct cec_adapter \*adap);
 
 Note: if cec_register_adapter() fails, then call cec_delete_adapter() to
 clean up. But if cec_register_adapter() succeeded, then only call
@@ -83,18 +94,23 @@ Implementing the Low-Level CEC Adapter
 The following low-level adapter operations have to be implemented in
 your driver:
 
-struct cec_adap_ops {
-	/* Low-level callbacks */
-	int (*adap_enable)(struct cec_adapter *adap, bool enable);
-	int (*adap_monitor_all_enable)(struct cec_adapter *adap, bool enable);
-	int (*adap_log_addr)(struct cec_adapter *adap, u8 logical_addr);
-	int (*adap_transmit)(struct cec_adapter *adap, u8 attempts,
-			     u32 signal_free_time, struct cec_msg *msg);
-	void (*adap_log_status)(struct cec_adapter *adap);
+.. c:type:: struct cec_adap_ops
 
-	/* High-level callbacks */
-	...
-};
+.. code-block:: none
+
+	struct cec_adap_ops
+	{
+		/* Low-level callbacks */
+		int (*adap_enable)(struct cec_adapter *adap, bool enable);
+		int (*adap_monitor_all_enable)(struct cec_adapter *adap, bool enable);
+		int (*adap_log_addr)(struct cec_adapter *adap, u8 logical_addr);
+		int (*adap_transmit)(struct cec_adapter *adap, u8 attempts,
+				      u32 signal_free_time, struct cec_msg *msg);
+		void (\*adap_log_status)(struct cec_adapter *adap);
+
+		/* High-level callbacks */
+		...
+	};
 
 The three low-level ops deal with various aspects of controlling the CEC adapter
 hardware:
@@ -102,6 +118,7 @@ hardware:
 
 To enable/disable the hardware:
 
+.. c:function::
 	int (*adap_enable)(struct cec_adapter *adap, bool enable);
 
 This callback enables or disables the CEC hardware. Enabling the CEC hardware
@@ -115,6 +132,7 @@ Note that adap_enable must return 0 if enable is false.
 
 To enable/disable the 'monitor all' mode:
 
+.. c:function::
 	int (*adap_monitor_all_enable)(struct cec_adapter *adap, bool enable);
 
 If enabled, then the adapter should be put in a mode to also monitor messages
@@ -127,6 +145,7 @@ Note that adap_monitor_all_enable must return 0 if enable is false.
 
 To program a new logical address:
 
+.. c:function::
 	int (*adap_log_addr)(struct cec_adapter *adap, u8 logical_addr);
 
 If logical_addr == CEC_LOG_ADDR_INVALID then all programmed logical addresses
@@ -140,6 +159,7 @@ Note that adap_log_addr must return 0 if logical_addr is CEC_LOG_ADDR_INVALID.
 
 To transmit a new message:
 
+.. c:function::
 	int (*adap_transmit)(struct cec_adapter *adap, u8 attempts,
 			     u32 signal_free_time, struct cec_msg *msg);
 
@@ -158,6 +178,7 @@ microseconds (one data bit period is 2.4 ms).
 
 To log the current CEC hardware status:
 
+.. c:function::
 	void (*adap_status)(struct cec_adapter *adap, struct seq_file *file);
 
 This optional callback can be used to show the status of the CEC hardware.
@@ -169,29 +190,41 @@ driven) by calling into the framework in the following situations:
 
 When a transmit finished (successfully or otherwise):
 
-void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
+.. c:function::
+	void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 		       u8 nack_cnt, u8 low_drive_cnt, u8 error_cnt);
 
 The status can be one of:
 
-CEC_TX_STATUS_OK: the transmit was successful.
-CEC_TX_STATUS_ARB_LOST: arbitration was lost: another CEC initiator
-took control of the CEC line and you lost the arbitration.
-CEC_TX_STATUS_NACK: the message was nacked (for a directed message) or
-acked (for a broadcast message). A retransmission is needed.
-CEC_TX_STATUS_LOW_DRIVE: low drive was detected on the CEC bus. This
-indicates that a follower detected an error on the bus and requested a
-retransmission.
-CEC_TX_STATUS_ERROR: some unspecified error occurred: this can be one of
-the previous two if the hardware cannot differentiate or something else
-entirely.
-CEC_TX_STATUS_MAX_RETRIES: could not transmit the message after
-trying multiple times. Should only be set by the driver if it has hardware
-support for retrying messages. If set, then the framework assumes that it
-doesn't have to make another attempt to transmit the message since the
-hardware did that already.
+CEC_TX_STATUS_OK:
+	the transmit was successful.
 
-The *_cnt arguments are the number of error conditions that were seen.
+CEC_TX_STATUS_ARB_LOST:
+	arbitration was lost: another CEC initiator
+	took control of the CEC line and you lost the arbitration.
+
+CEC_TX_STATUS_NACK:
+	the message was nacked (for a directed message) or
+	acked (for a broadcast message). A retransmission is needed.
+
+CEC_TX_STATUS_LOW_DRIVE:
+	low drive was detected on the CEC bus. This indicates that
+	a follower detected an error on the bus and requested a
+	retransmission.
+
+CEC_TX_STATUS_ERROR:
+	some unspecified error occurred: this can be one of
+	the previous two if the hardware cannot differentiate or something
+	else entirely.
+
+CEC_TX_STATUS_MAX_RETRIES:
+	could not transmit the message after trying multiple times.
+	Should only be set by the driver if it has hardware support for
+	retrying messages. If set, then the framework assumes that it
+	doesn't have to make another attempt to transmit the message
+	since the hardware did that already.
+
+The \*_cnt arguments are the number of error conditions that were seen.
 This may be 0 if no information is available. Drivers that do not support
 hardware retry can just set the counter corresponding to the transmit error
 to 1, if the hardware does support retry then either set these counters to
@@ -200,7 +233,8 @@ times, or fill in the correct values as reported by the hardware.
 
 When a CEC message was received:
 
-void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);
+.. c:function::
+	void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);
 
 Speaks for itself.
 
@@ -210,17 +244,20 @@ Implementing the High-Level CEC Adapter
 The low-level operations drive the hardware, the high-level operations are
 CEC protocol driven. The following high-level callbacks are available:
 
-struct cec_adap_ops {
-	/* Low-level callbacks */
-	...
+.. code-block:: none
 
-	/* High-level CEC message callback */
-	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
-};
+	struct cec_adap_ops {
+		/\* Low-level callbacks \*/
+		...
+
+		/\* High-level CEC message callback \*/
+		int (\*received)(struct cec_adapter \*adap, struct cec_msg \*msg);
+	};
 
 The received() callback allows the driver to optionally handle a newly
 received CEC message
 
+.. c:function::
 	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
 
 If the driver wants to process a CEC message, then it can implement this
@@ -234,13 +271,16 @@ CEC framework functions
 
 CEC Adapter drivers can call the following CEC framework functions:
 
-int cec_transmit_msg(struct cec_adapter *adap, struct cec_msg *msg,
-		     bool block);
+.. c:function::
+	int cec_transmit_msg(struct cec_adapter *adap, struct cec_msg *msg,
+			     bool block);
 
 Transmit a CEC message. If block is true, then wait until the message has been
 transmitted, otherwise just queue it and return.
 
-void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block);
+.. c:function::
+	void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr,
+			     bool block);
 
 Change the physical address. This function will set adap->phys_addr and
 send an event if it has changed. If cec_s_log_addrs() has been called and
@@ -254,8 +294,9 @@ then the CEC adapter will be disabled. If you change a valid physical address
 to another valid physical address, then this function will first set the
 address to CEC_PHYS_ADDR_INVALID before enabling the new physical address.
 
-int cec_s_log_addrs(struct cec_adapter *adap,
-		    struct cec_log_addrs *log_addrs, bool block);
+.. c:function::
+	int cec_s_log_addrs(struct cec_adapter *adap,
+			    struct cec_log_addrs *log_addrs, bool block);
 
 Claim the CEC logical addresses. Should never be called if CEC_CAP_LOG_ADDRS
 is set. If block is true, then wait until the logical addresses have been
-- 
2.7.4


