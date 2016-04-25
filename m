Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:54907 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754582AbcDYMaW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 08:30:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux@arm.linux.org.uk, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv15 15/15] cec: add ARC and CDC support
Date: Mon, 25 Apr 2016 14:24:42 +0200
Message-Id: <1461587082-48041-16-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1461587082-48041-1-git-send-email-hverkuil@xs4all.nl>
References: <1461587082-48041-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Preliminary ARC and CDC support. Untested and experimental!

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/cec-ioc-adap-g-caps.xml      |  10 ++
 Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml |  36 ++++
 Documentation/cec.txt                              |  75 ++++++++
 drivers/staging/media/cec/cec.c                    | 198 ++++++++++++++++++++-
 include/linux/cec.h                                |   5 +
 include/media/cec.h                                |  12 ++
 6 files changed, 334 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml b/Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml
index b99ed22..65250b7 100644
--- a/Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml
+++ b/Documentation/DocBook/media/v4l/cec-ioc-adap-g-caps.xml
@@ -129,6 +129,16 @@
 	    <entry>The CEC hardware can monitor all messages, not just directed and
 	    broadcast messages.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>CEC_CAP_ARC</constant></entry>
+	    <entry>0x00000040</entry>
+	    <entry>This adapter supports the Audio Return Channel protocol.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_CAP_CDC_HPD</constant></entry>
+	    <entry>0x00000080</entry>
+	    <entry>This adapter supports the hotplug detect protocol over CDC.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml b/Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml
index 0cb1941..485e8b2 100644
--- a/Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml
+++ b/Documentation/DocBook/media/v4l/cec-ioc-g-mode.xml
@@ -187,6 +187,42 @@ The follower can of course always call &CEC-TRANSMIT;.</para>
 	&cs-def;
 	<tbody valign="top">
 	  <row>
+	    <entry><constant>CEC_MSG_INITIATE_ARC</constant></entry>
+	    <entry></entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MSG_TERMINATE_ARC</constant></entry>
+	    <entry></entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MSG_REQUEST_ARC_INITIATION</constant></entry>
+	    <entry></entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MSG_REQUEST_ARC_TERMINATION</constant></entry>
+	    <entry></entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MSG_REPORT_ARC_INITIATED</constant></entry>
+	    <entry></entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MSG_REPORT_ARC_TERMINATED</constant></entry>
+	    <entry>If <constant>CEC_CAP_ARC</constant> is not set, then just pass
+	    it on to userspace for processing. However, if <constant>CEC_CAP_ARC</constant> is
+	    set, then the core framework processes this message and userspace will
+	    not see it, not even in passthrough mode.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>CEC_MSG_CDC_MESSAGE</constant></entry>
+	    <entry>If <constant>CEC_CAP_CDC_HPD</constant> is not set, then just pass
+	    it on to userspace for processing. Do the same if the CDC command is not
+	    one of <constant>CEC_MSG_CDC_HPD_REPORT_STATE</constant> or
+	    <constant>CEC_MSG_CDC_HPD_SET_STATE</constant>. Else the core framework
+	    processes this message and userspace will not see it, not even in passthrough
+	    mode.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>CEC_MSG_GET_CEC_VERSION</constant></entry>
 	    <entry>When in passthrough mode this message has to be handled by userspace,
 	    otherwise the core will return the CEC version that was set with &CEC-ADAP-S-LOG-ADDRS;.</entry>
diff --git a/Documentation/cec.txt b/Documentation/cec.txt
index 75155fe..8a61819 100644
--- a/Documentation/cec.txt
+++ b/Documentation/cec.txt
@@ -216,6 +216,16 @@ struct cec_adap_ops {
 
 	/* High-level CEC message callback */
 	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
+
+	/* High-level CDC Hotplug Detect callbacks */
+	u8 (*source_cdc_hpd)(struct cec_adapter *adap, u8 cdc_hpd_state);
+	void (*sink_cdc_hpd)(struct cec_adapter *adap, u8 cdc_hpd_state, u8 cdc_hpd_error);
+
+	/* High-level Audio Return Channel callbacks */
+	int (*sink_initiate_arc)(struct cec_adapter *adap);
+	int (*sink_terminate_arc)(struct cec_adapter *adap);
+	int (*source_arc_initiated)(struct cec_adapter *adap);
+	int (*source_arc_terminated)(struct cec_adapter *adap);
 };
 
 The received() callback allows the driver to optionally handle a newly
@@ -228,6 +238,62 @@ callback. If it doesn't want to handle this message, then it should return
 -ENOMSG, otherwise the CEC framework assumes it processed this message and
 it will not no anything with it.
 
+The other callbacks deal with two CEC features: CDC Hotplug Detect and
+Audio Return Channel. Here the framework takes care of handling these
+messages and it calls the callbacks to notify the driver when it needs
+to take action.
+
+CDC Hotplug Support
+-------------------
+
+A source received a hotplug state change message:
+
+	u8 (*source_cdc_hpd)(struct cec_adapter *adap, u8 cdc_hpd_state);
+
+A source received a CEC_MSG_CDC_HPD_SET_STATE message. The framework will
+reply with a CEC_MSG_CDC_HPD_REPORT_STATE message and this callback is used
+to fill in the HPD Error Code Operand of the REPORT_STATE message. In addition,
+the driver can act in this callback on the hotplug state change.
+
+Only implement if CEC_CAP_CDC_HPD is set.
+
+A sink received a hotplug report state message:
+
+	void (*sink_cdc_hpd)(struct cec_adapter *adap, u8 cdc_hpd_state, u8 cdc_hpd_error);
+
+A sink received a CEC_MSG_CDC_HPD_REPORT_STATE message. This callback will
+do anything necessary to implement this hotplug change. The two arguments
+are the HPD Error State and HPD Error Code Operands from the CEC_MSG_CDC_HPD_REPORT_STATE
+message.
+
+
+Audio Return Channel Support
+----------------------------
+
+Called if a CEC_MSG_INITIATE_ARC message is received by an HDMI sink.
+This callback should start sending audio over the audio return channel. If
+successful it should return 0.
+
+	int (*sink_initiate_arc)(struct cec_adapter *adap);
+
+Called if a CEC_MSG_TERMINATE_ARC message is received by an HDMI sink.
+This callback should stop sending audio over the audio return channel. If
+successful it should return 0.
+
+	void (*sink_terminate_arc)(struct cec_adapter *adap);
+
+Called if a CEC_MSG_REPORT_ARC_INITIATED message is received by an
+HDMI source. This callback can be used to enable receiving audio from
+the audio return channel.
+
+	void (*source_arc_initiated)(struct cec_adapter *adap);
+
+Called if a CEC_MSG_REPORT_ARC_TERMINATED message is received by an
+HDMI source. This callback can be used to disable receiving audio from
+the audio return channel.
+
+	void (*source_arc_terminated)(struct cec_adapter *adap);
+
 
 CEC framework functions
 -----------------------
@@ -265,3 +331,12 @@ log_addrs->num_log_addrs set to 0. The block argument is ignored when
 unconfiguring. This function will just return if the physical address is
 invalid. Once the physical address becomes valid, then the framework will
 attempt to claim these logical addresses.
+
+u8 cec_sink_cdc_hpd(struct cec_adapter *adap, u8 input_port, u8 cdc_hpd_state);
+
+If an HDMI receiver supports hotplug signalling over CDC (CEC_CAP_CDC_HPD is
+set), then the driver should call this function whenever the hotplug state
+changes for an input. This call will send an appropriate CDC message over
+the CEC line. It returns CEC_OP_HPD_ERROR_NONE on success, if the adapter
+is unconfigured it returns CEC_OP_HPD_ERROR_INITIATOR_WRONG_STATE and if
+the cec_transmit fails it returns CEC_OP_HPD_ERROR_OTHER.
diff --git a/drivers/staging/media/cec/cec.c b/drivers/staging/media/cec/cec.c
index 3c5f084..6e9b411 100644
--- a/drivers/staging/media/cec/cec.c
+++ b/drivers/staging/media/cec/cec.c
@@ -87,6 +87,42 @@ static inline struct cec_devnode *cec_devnode_data(struct file *filp)
 	return &fh->adap->devnode;
 }
 
+/*
+ * Two physical addresses are adjacent if they have a direct link.
+ * So 0.0.0.0 and 1.0.0.0 are adjacent, but not 0.0.0.0 and 1.1.0.0.
+ * And 2.3.0.0 and 2.3.1.0 are adjacent, but not 2.3.0.0 and 2.4.0.0.
+ *
+ * In other words, the two addresses share the same prefix, but then
+ * one has a zero and the other has a non-zero value. And the remaining
+ * components are all zero for both.
+ */
+static bool cec_pa_are_adjacent(const struct cec_adapter *adap, u16 pa1, u16 pa2)
+{
+	u16 mask = 0xf000;
+	int i;
+
+	if (pa1 == CEC_PHYS_ADDR_INVALID || pa2 == CEC_PHYS_ADDR_INVALID)
+		return false;
+	for (i = 0; i < 3; i++) {
+		if ((pa1 & mask) != (pa2 & mask))
+			break;
+		mask = (mask >> 4) | 0xf000;
+	}
+	if ((pa1 & ~mask) || (pa2 & ~mask))
+		return false;
+	if (!(pa1 & mask) ^ !(pa2 & mask))
+		return true;
+	return false;
+}
+
+static bool cec_la_are_adjacent(const struct cec_adapter *adap, u8 la1, u8 la2)
+{
+	u16 pa1 = adap->phys_addrs[la1];
+	u16 pa2 = adap->phys_addrs[la2];
+
+	return cec_pa_are_adjacent(adap, pa1, pa2);
+}
+
 static int cec_log_addr2idx(const struct cec_adapter *adap, u8 log_addr)
 {
 	int i;
@@ -960,7 +996,9 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 	int la_idx = cec_log_addr2idx(adap, dest_laddr);
 	bool is_directed = la_idx >= 0;
 	bool from_unregistered = init_laddr == 0xf;
+	u16 cdc_phys_addr;
 	struct cec_msg tx_cec_msg = { };
+	u8 *tx_msg = tx_cec_msg.msg;
 
 	dprintk(1, "cec_receive_notify: %*ph\n", msg->len, msg->msg);
 
@@ -971,12 +1009,57 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 	}
 
 	/*
-	 * REPORT_PHYSICAL_ADDR, CEC_MSG_USER_CONTROL_PRESSED and
+	 * ARC, CDC and REPORT_PHYSICAL_ADDR, CEC_MSG_USER_CONTROL_PRESSED and
 	 * CEC_MSG_USER_CONTROL_RELEASED messages always have to be
 	 * handled by the CEC core, even if the passthrough mode is on.
-	 * The others are just ignored if passthrough mode is on.
+	 * ARC and CDC messages will never be seen even if passthrough is
+	 * on, but the others are just passed on normally after we processed
+	 * them.
 	 */
 	switch (msg->msg[1]) {
+	case CEC_MSG_INITIATE_ARC:
+	case CEC_MSG_TERMINATE_ARC:
+	case CEC_MSG_REQUEST_ARC_INITIATION:
+	case CEC_MSG_REQUEST_ARC_TERMINATION:
+	case CEC_MSG_REPORT_ARC_INITIATED:
+	case CEC_MSG_REPORT_ARC_TERMINATED:
+		/* ARC messages are never passed through if CAP_ARC is set */
+
+		/* Abort/ignore if ARC is not supported */
+		if (!(adap->capabilities & CEC_CAP_ARC)) {
+			/* Just abort if nobody is listening */
+			if (is_directed && !is_reply && !adap->cec_follower &&
+			    !adap->follower_cnt)
+				return cec_feature_abort(adap, msg);
+			goto skip_processing;
+		}
+		/* Ignore if addressing is wrong */
+		if (is_broadcast || from_unregistered)
+			return 0;
+		break;
+
+	case CEC_MSG_CDC_MESSAGE:
+		switch (msg->msg[4]) {
+		case CEC_MSG_CDC_HPD_REPORT_STATE:
+		case CEC_MSG_CDC_HPD_SET_STATE:
+			/*
+			 * CDC_HPD messages are never passed through if
+			 * CAP_CDC_HPD is set
+			 */
+
+			/* Ignore if CDC_HPD is not supported */
+			if (!(adap->capabilities & CEC_CAP_CDC_HPD))
+				goto skip_processing;
+			/* or the addressing is wrong */
+			if (!is_broadcast)
+				return 0;
+			break;
+		default:
+			/* Other CDC messages are ignored */
+			goto skip_processing;
+		}
+		break;
+
 	case CEC_MSG_GET_CEC_VERSION:
 	case CEC_MSG_GIVE_DEVICE_VENDOR_ID:
 	case CEC_MSG_ABORT:
@@ -1112,6 +1195,97 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 			return cec_report_features(adap, la_idx);
 		return 0;
 
+	case CEC_MSG_REQUEST_ARC_INITIATION:
+		if (cec_is_sink(adap) ||
+		    !cec_la_are_adjacent(adap, dest_laddr, init_laddr))
+			return cec_feature_refused(adap, msg);
+		cec_msg_initiate_arc(&tx_cec_msg, false);
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
+
+	case CEC_MSG_REQUEST_ARC_TERMINATION:
+		if (cec_is_sink(adap) ||
+		    !cec_la_are_adjacent(adap, dest_laddr, init_laddr))
+			return cec_feature_refused(adap, msg);
+		cec_msg_terminate_arc(&tx_cec_msg, false);
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
+
+	case CEC_MSG_INITIATE_ARC:
+		if (!cec_is_sink(adap) ||
+		    !cec_la_are_adjacent(adap, dest_laddr, init_laddr))
+			return cec_feature_refused(adap, msg);
+		if (call_op(adap, sink_initiate_arc))
+			return 0;
+		cec_msg_report_arc_initiated(&tx_cec_msg);
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
+
+	case CEC_MSG_TERMINATE_ARC:
+		if (!cec_is_sink(adap) ||
+		    !cec_la_are_adjacent(adap, dest_laddr, init_laddr))
+			return cec_feature_refused(adap, msg);
+		call_void_op(adap, sink_terminate_arc);
+		cec_msg_report_arc_terminated(&tx_cec_msg);
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
+
+	case CEC_MSG_REPORT_ARC_INITIATED:
+		if (cec_is_sink(adap) ||
+		    !cec_la_are_adjacent(adap, dest_laddr, init_laddr))
+			return cec_feature_refused(adap, msg);
+		call_void_op(adap, source_arc_initiated);
+		return 0;
+
+	case CEC_MSG_REPORT_ARC_TERMINATED:
+		if (cec_is_sink(adap) ||
+		    !cec_la_are_adjacent(adap, dest_laddr, init_laddr))
+			return cec_feature_refused(adap, msg);
+		call_void_op(adap, source_arc_terminated);
+		return 0;
+
+	case CEC_MSG_CDC_MESSAGE: {
+		unsigned int shift;
+		unsigned int input_port;
+
+		cdc_phys_addr = (msg->msg[2] << 8) | msg->msg[3];
+		if (!cec_pa_are_adjacent(adap, cdc_phys_addr, adap->phys_addr))
+			return 0;
+
+		switch (msg->msg[4]) {
+		case CEC_MSG_CDC_HPD_REPORT_STATE:
+			/*
+			 * Ignore if we're not a sink or the message comes from
+			 * an upstream device.
+			 */
+			if (!cec_is_sink(adap) || cdc_phys_addr <= adap->phys_addr)
+				return 0;
+			adap->ops->sink_cdc_hpd(adap, msg->msg[5] >> 4, msg->msg[5] & 0xf);
+			return 0;
+		case CEC_MSG_CDC_HPD_SET_STATE:
+			/* Ignore if we're not a source */
+			if (cec_is_sink(adap))
+				return 0;
+			break;
+		default:
+			return 0;
+		}
+
+		input_port = msg->msg[5] >> 4;
+		for (shift = 0; shift < 16; shift += 4) {
+			if (cdc_phys_addr & (0xf000 >> shift))
+				continue;
+			cdc_phys_addr |= input_port << (12 - shift);
+			break;
+		}
+		if (cdc_phys_addr != adap->phys_addr)
+			return 0;
+
+		tx_cec_msg.len = 6;
+		/* broadcast reply */
+		tx_msg[0] = (adap->log_addrs.log_addr[0] << 4) | 0xf;
+		cec_msg_cdc_hpd_report_state(&tx_cec_msg,
+			     msg->msg[5] & 0xf,
+			     adap->ops->source_cdc_hpd(adap, msg->msg[5] & 0xf));
+		return cec_transmit_msg(adap, &tx_cec_msg, false);
+	}
+
 	default:
 		/*
 		 * Unprocessed messages are aborted if userspace isn't doing
@@ -1618,6 +1792,26 @@ static int cec_status(struct seq_file *file, void *priv)
 	return 0;
 }
 
+/*
+ * Called by drivers to update the CDC HPD state of an input port.
+ */
+u8 cec_sink_cdc_hpd(struct cec_adapter *adap, u8 input_port, u8 cdc_hpd_state)
+{
+	struct cec_msg msg = { };
+	int err;
+
+	if (!adap->is_configured)
+		return CEC_OP_HPD_ERROR_INITIATOR_WRONG_STATE;
+
+	msg.msg[0] = (adap->log_addrs.log_addr[0] << 4) | 0xf;
+	cec_msg_cdc_hpd_set_state(&msg, input_port, cdc_hpd_state);
+	err = cec_transmit_msg(adap, &msg, false);
+	if (err)
+		return CEC_OP_HPD_ERROR_OTHER;
+	return CEC_OP_HPD_ERROR_NONE;
+}
+EXPORT_SYMBOL_GPL(cec_sink_cdc_hpd);
+
 
 /* CEC file operations */
 
diff --git a/include/linux/cec.h b/include/linux/cec.h
index 521b07cb..bf984a0 100644
--- a/include/linux/cec.h
+++ b/include/linux/cec.h
@@ -305,12 +305,17 @@ static inline bool cec_is_unconfigured(__u16 log_addr_mask)
 #define CEC_CAP_TRANSMIT	(1 << 2)
 /*
  * Passthrough all messages instead of processing them.
+ * Note: ARC and CDC messages are always processed.
  */
 #define CEC_CAP_PASSTHROUGH	(1 << 3)
 /* Supports remote control */
 #define CEC_CAP_RC		(1 << 4)
 /* Hardware can monitor all messages, not just directed and broadcast. */
 #define CEC_CAP_MONITOR_ALL	(1 << 5)
+/* Supports ARC */
+#define CEC_CAP_ARC		(1 << 6)
+/* Supports CDC HPD */
+#define CEC_CAP_CDC_HPD		(1 << 7)
 
 /**
  * struct cec_caps - CEC capabilities structure.
diff --git a/include/media/cec.h b/include/media/cec.h
index 2dcd838..9260489 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -126,6 +126,16 @@ struct cec_adap_ops {
 
 	/* High-level CEC message callback */
 	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
+
+	/* High-level CDC Hotplug Detect callbacks */
+	u8 (*source_cdc_hpd)(struct cec_adapter *adap, u8 cdc_hpd_state);
+	void (*sink_cdc_hpd)(struct cec_adapter *adap, u8 cdc_hpd_state, u8 cdc_hpd_error);
+
+	/* High-level Audio Return Channel callbacks */
+	int (*sink_initiate_arc)(struct cec_adapter *adap);
+	void (*sink_terminate_arc)(struct cec_adapter *adap);
+	void (*source_arc_initiated)(struct cec_adapter *adap);
+	void (*source_arc_terminated)(struct cec_adapter *adap);
 };
 
 /*
@@ -206,6 +216,8 @@ void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr,
 int cec_transmit_msg(struct cec_adapter *adap, struct cec_msg *msg,
 		     bool block);
 
+u8 cec_sink_cdc_hpd(struct cec_adapter *adap, u8 input_port, u8 cdc_hpd_state);
+
 /* Called by the adapter */
 void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 		       u8 nack_cnt, u8 low_drive_cnt, u8 error_cnt);
-- 
2.8.1

