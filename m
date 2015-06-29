Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:43857 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbbF2KZ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 06:25:57 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org, Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv7 08/15] cec.txt: add CEC framework documentation
Date: Mon, 29 Jun 2015 12:14:53 +0200
Message-Id: <1435572900-56998-9-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <1435572900-56998-1-git-send-email-hans.verkuil@cisco.com>
References: <1435572900-56998-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Document the new HDMI CEC framework.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
[k.debski@samsung.com: add DocBook documentation by Hans Verkuil, with
Signed-off-by: Kamil Debski <kamil@wypas.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/cec.txt | 166 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 166 insertions(+)
 create mode 100644 Documentation/cec.txt

diff --git a/Documentation/cec.txt b/Documentation/cec.txt
new file mode 100644
index 0000000..b298249
--- /dev/null
+++ b/Documentation/cec.txt
@@ -0,0 +1,166 @@
+CEC Kernel Support
+==================
+
+The CEC framework provides a unified kernel interface for use with HDMI CEC
+hardware. It is designed to handle a multiple variants of hardware. Adding to
+the flexibility of the framework it enables to set which parts of the CEC
+protocol processing is handled by the hardware, by the driver and by the
+userspace application.
+
+
+The CEC Protocol
+----------------
+
+The CEC protocol enables consumer electronic devices to communicate with each
+other through the HDMI connection. The protocol uses logical addresses in the
+communication. The logical address is strictly connected with the functionality
+provided by the device. The TV acting as the communication hub is always
+assigned address 0. The physical address is determined by the physical
+connection between devices.
+
+The protocol enables control of compatible devices with a single remote.
+Synchronous power on/standby, instant playback with changing the content source
+on the TV.
+
+The Kernel Interface
+====================
+
+CEC Adapter
+-----------
+
+#define CEC_LOG_ADDR_INVALID 0xff
+
+/* The maximum number of logical addresses one device can be assigned to.
+ * The CEC 2.0 spec allows for only 2 logical addresses at the moment. The
+ * Analog Devices CEC hardware supports 3. So let's go wild and go for 4. */
+#define CEC_MAX_LOG_ADDRS 4
+
+/* The "Primary Device Type" */
+#define CEC_OP_PRIM_DEVTYPE_TV		0
+#define CEC_OP_PRIM_DEVTYPE_RECORD		1
+#define CEC_OP_PRIM_DEVTYPE_TUNER		3
+#define CEC_OP_PRIM_DEVTYPE_PLAYBACK		4
+#define CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM	5
+#define CEC_OP_PRIM_DEVTYPE_SWITCH		6
+#define CEC_OP_PRIM_DEVTYPE_VIDEOPROC	7
+
+/* The "All Device Types" flags (CEC 2.0) */
+#define CEC_OP_ALL_DEVTYPE_TV		(1 << 7)
+#define CEC_OP_ALL_DEVTYPE_RECORD	(1 << 6)
+#define CEC_OP_ALL_DEVTYPE_TUNER	(1 << 5)
+#define CEC_OP_ALL_DEVTYPE_PLAYBACK	(1 << 4)
+#define CEC_OP_ALL_DEVTYPE_AUDIOSYSTEM	(1 << 3)
+#define CEC_OP_ALL_DEVTYPE_SWITCH	(1 << 2)
+/* And if you wondering what happened to VIDEOPROC devices: those should
+ * be mapped to a SWITCH. */
+
+/* The logical address types that the CEC device wants to claim */
+#define CEC_LOG_ADDR_TYPE_TV		0
+#define CEC_LOG_ADDR_TYPE_RECORD	1
+#define CEC_LOG_ADDR_TYPE_TUNER		2
+#define CEC_LOG_ADDR_TYPE_PLAYBACK	3
+#define CEC_LOG_ADDR_TYPE_AUDIOSYSTEM	4
+#define CEC_LOG_ADDR_TYPE_SPECIFIC	5
+#define CEC_LOG_ADDR_TYPE_UNREGISTERED	6
+/* Switches should use UNREGISTERED.
+ * Video processors should use SPECIFIC. */
+
+/* The CEC version */
+#define CEC_OP_CEC_VERSION_1_3A		4
+#define CEC_OP_CEC_VERSION_1_4		5
+#define CEC_OP_CEC_VERSION_2_0		6
+
+struct cec_adapter {
+	/* internal fields removed */
+
+	u16 phys_addr;
+	u32 capabilities;
+	u8 version;
+	u8 num_log_addrs;
+	u8 prim_device[CEC_MAX_LOG_ADDRS];
+	u8 log_addr_type[CEC_MAX_LOG_ADDRS];
+	u8 log_addr[CEC_MAX_LOG_ADDRS];
+
+	int (*adap_enable)(struct cec_adapter *adap, bool enable);
+	int (*adap_log_addr)(struct cec_adapter *adap, u8 logical_addr);
+	int (*adap_transmit)(struct cec_adapter *adap, struct cec_msg *msg);
+	void (*adap_transmit_timed_out)(struct cec_adapter *adap);
+
+	void (*claimed_log_addr)(struct cec_adapter *adap, u8 idx);
+	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
+};
+
+int cec_create_adapter(struct cec_adapter *adap, u32 caps);
+void cec_delete_adapter(struct cec_adapter *adap);
+int cec_transmit_msg(struct cec_adapter *adap, struct cec_data *data, bool block);
+
+/* Called by the adapter */
+void cec_transmit_done(struct cec_adapter *adap, u32 status);
+void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);
+
+int cec_receive_msg(struct cec_adapter *adap, struct cec_msg *msg, bool block);
+int cec_claim_log_addrs(struct cec_adapter *adap, struct cec_log_addrs *log_addrs, bool block);
+
+The device type defines are defined by the CEC standard.
+
+The cec_adapter structure represents the adapter. It has a number of
+operations that have to be implemented in the driver: adap_enable() enables
+or disables the physical adapter, adap_log_addr() tells the driver which
+logical address should be configured. This may be called multiple times
+to configure multiple logical addresses. Calling adap_enable(false) or
+adap_log_addr(CEC_LOG_ADDR_INVALID) will clear all configured logical
+addresses.
+
+The adap_transmit op will setup the hardware to send out the given CEC message.
+This will return without waiting for the transmission to finish. The
+adap_transmit_timed_out() function is called when the current transmission timed
+out and the hardware needs to be informed of this (the hardware should go back
+from transmitter to receiver mode).
+
+The adapter driver will also call into the adapter: it should call
+cec_transmit_done() when a cec transfer was finalized and cec_received_msg()
+when a new message was received.
+
+When a message is received the received() op is called.
+
+The driver has to call cec_create_adapter to initialize the structure. If
+the 'caps' argument is non-zero, then it will also create a /dev/cecX
+device node to allow userspace to interact with the CEC device. Userspace
+can request those capabilities with the CEC_G_CAPS ioctl.
+
+In order for a CEC adapter to be configured it needs a physical address.
+This is normally assigned by the driver. It is either 0.0.0.0 for a TV (aka
+video receiver) or it is derived from the EDID that the source received
+from the sink. This is normally set by the driver before enabling the CEC
+adapter, or it is set from userspace in the case of CEC USB dongles (although
+embedded systems might also want to set this manually).
+
+After enabling the CEC adapter it has to be configured.
+
+The userspace has to inform the CEC adapter of which type of device it requests
+the adapter to identify itself. After this information is set by userspace, the
+CEC framework will attempt to to find and claim a logical addresses matching the
+requested device type. If none are found, then it will fall back to logical
+address Unregistered (15). To clear the logical addresses list from the list the
+userspace application should set the num_log_addrs field of struct cec_log_addr
+to 0.
+
+The type of device is set from the userspace with the CEC_S_ADAP_LOG_ADDRS. In
+addition, claiming logical addresses can be initiated from the kernel side by
+calling the cec_claim_log_addrs function.
+
+Before the addresses are claimed it is possible to send and receive messages.
+Sending all messages is possible as it is up to the userspace to the source
+and destination addresses in the message payload. However, only broadcast
+messages can be received until a regular logical address is claimed.
+
+When a CEC message is received the CEC framework will take care of the CEC
+core messages CEC_MSG_GET_CEC_VERSION, CEC_MSG_GIVE_PHYS_ADDR and CEC_MSG_ABORT.
+Then it will call the received() op (if set), and finally it will queue it
+for handling by userspace if create_devnode was true, or send back
+FEATURE_ABORT if create_devnode was false.
+
+Drivers can also use the cec_transmit_msg() call to transmit a message. This
+can either be fire-and-forget (the CEC framework will queue up messages in a
+transmit queue), or a blocking wait until there is either an error or a
+reply to the message.
-- 
2.1.4

