Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:34522 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451AbcBJMwT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2016 07:52:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux@arm.linux.org.uk, Hans Verkuil <hansverk@cisco.com>,
	Kamil Debski <kamil@wypas.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv12 09/17] cec.txt: add CEC framework documentation
Date: Wed, 10 Feb 2016 13:51:43 +0100
Message-Id: <1455108711-29850-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1455108711-29850-1-git-send-email-hverkuil@xs4all.nl>
References: <1455108711-29850-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Document the new HDMI CEC framework.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
[k.debski@samsung.com: add DocBook documentation by Hans Verkuil, with
Signed-off-by: Kamil Debski <kamil@wypas.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/cec.txt | 359 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 359 insertions(+)
 create mode 100644 Documentation/cec.txt

diff --git a/Documentation/cec.txt b/Documentation/cec.txt
new file mode 100644
index 0000000..57fea4c
--- /dev/null
+++ b/Documentation/cec.txt
@@ -0,0 +1,359 @@
+CEC Kernel Support
+==================
+
+The CEC framework provides a unified kernel interface for use with HDMI CEC
+hardware. It is designed to handle a multiple types of hardware (receivers,
+transmitters, USB dongles). The framework also gives the option to decide
+what to do in the kernel driver and what should be handled by userspace
+applications. In addition it integrates the remote control passthrough
+feature into the kernel's remote control framework.
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
+The CEC framework described here is up to date with the CEC 2.0 specification.
+It is documented in the HDMI 1.4 specification with the new 2.0 bits documented
+in the HDMI 2.0 specification. But for most of the features the freely available
+HDMI 1.3a specification is sufficient:
+
+http://www.microprocessor.org/HDMISpecification13a.pdf
+
+
+The Kernel Interface
+====================
+
+CEC Adapter
+-----------
+
+The struct cec_adapter represents the CEC adapter hardware. It is created by
+calling cec_create_adapter() and deleted by calling cec_delete_adapter():
+
+struct cec_adapter *cec_create_adapter(const struct cec_adap_ops *ops,
+		       void *priv, const char *name, u32 caps,
+		       u8 ninputs, struct module *owner, struct device *parent);
+void cec_delete_adapter(struct cec_adapter *adap);
+
+To create an adapter you need to pass the following information:
+
+ops: adapter operations which are called by the CEC framework and that you
+have to implement.
+
+priv: will be stored in adap->priv and can be used by the adapter ops.
+
+name: the name of the CEC adapter. Note: this name will be copied.
+
+caps: capabilities of the CEC adapter. These capabilities determine the
+	capabilities of the hardware and which parts are to be handled
+	by userspace and which parts are handled by kernelspace. The
+	capabilities are returned by CEC_ADAP_G_CAPS.
+
+ninputs: the number of HDMI inputs of the device. This may be 0. This
+	is returned by CEC_ADAP_G_CAPS.
+
+owner: the module owner.
+
+parent: the parent device.
+
+
+After creating the adapter the driver can modify the following fields
+in struct cec_adapter:
+
+	u8 available_log_addrs;
+
+This determines the number of simultaneous logical addresses the hardware
+can program. Often this is 1, which is also the default.
+
+	u8 pwr_state;
+
+The CEC_MSG_GIVE_DEVICE_POWER_STATUS power state. By default this is
+CEC_OP_POWER_STATUS_ON (0). The driver can change this to signal power
+state transitions.
+
+	u16 phys_addr;
+
+By default this is 0xffff, but drivers can change this using the cec_set_phys_addr
+function. The phys_addr field must be set before the CEC adapter is enabled (see
+the adap_enable op below). While the CEC adapter remains enabled it cannot be
+changed. Drivers never set this if CEC_CAP_PHYS_ADDR is set.
+
+	u32 vendor_id;
+
+By default this is CEC_VENDOR_ID_NONE (0xffffffff). It should not be changed
+once the adapter is configured. Drivers never set this if CEC_CAP_VENDOR_ID
+is set.
+
+	u8 cec_version;
+
+The CEC version that the framework should support. By default this is the
+latest version, but it can be changed to an older version, causing attempts
+to use later extensions to fail. Obviously this should be set before the
+CEC adapter is enabled.
+
+To register the /dev/cecX device node and the remote control device (if
+CEC_CAP_RC is set) you call:
+
+int cec_register_adapter(struct cec_adapter *adap);
+
+To unregister the devices call:
+
+void cec_unregister_adapter(struct cec_adapter *adap);
+
+Note: if cec_register_adapter() fails, then call cec_delete_adapter() to
+clean up. But if cec_register_adapter() succeeded, then only call
+cec_unregister_adapter() to clean up, never cec_delete_adapter(). The
+unregister function will delete the adapter automatically once the last user
+of that /dev/cecX device has closed its file handle.
+
+
+Implementing the Low-Level CEC Adapter
+--------------------------------------
+
+The following low-level adapter operations have to be implemented in
+your driver:
+
+struct cec_adap_ops {
+	/* Low-level callbacks */
+	int (*adap_enable)(struct cec_adapter *adap, bool enable);
+	int (*adap_log_addr)(struct cec_adapter *adap, u8 logical_addr);
+	int (*adap_transmit)(struct cec_adapter *adap, u8 *retries,
+			     u32 signal_free_time_ms, struct cec_msg *msg);
+
+	/* High-level callbacks */
+	...
+};
+
+The three low-level ops deal with various aspects of controlling the CEC adapter
+hardware:
+
+To enable/disable the hardware:
+
+	int (*adap_enable)(struct cec_adapter *adap, bool enable);
+
+This callback enables or disables the CEC hardware. Enabling the CEC hardware
+means powering it up in a state where no logical addresses are claimed. This
+op assumes that the physical address (adap->phys_addr) is valid when enable is
+true and will not change while the CEC adapter remains enabled. The initial
+state of the CEC adapter after calling cec_create_adapter() is disabled.
+
+To program a new logical address:
+
+	int (*adap_log_addr)(struct cec_adapter *adap, u8 logical_addr);
+
+If logical_addr == CEC_LOG_ADDR_INVALID then all programmed logical addresses
+are to be erased. Otherwise the given logical address should be programmed.
+If the maximum number of available logical addresses is exceeded, then it
+should return -ENXIO. Once a logical address is programmed the CEC hardware
+can start receiving messages.
+
+To transmit a new message:
+
+	int (*adap_transmit)(struct cec_adapter *adap, u8 attempts,
+			     u32 signal_free_time_ms, struct cec_msg *msg);
+
+This transmits a new message. The attempts argument is the suggested number of
+attempts for the transmit.
+
+The signal_free_time_ms is the number of milliseconds that the adapter should
+wait when the line is free before attempting to send a message. This value
+depends on whether this transmit is a retry, a message from a new initiator or
+a new message for the same initiator. Most hardware will handle this
+automatically, but in some cases this information is needed.
+
+Your adapter driver will also have to react to events (typically interrupt
+driven) by calling into the framework in the following situations:
+
+When a transmit finished (successfully or otherwise):
+
+void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
+		       u8 nack_cnt, u8 low_drive_cnt, u8 error_cnt);
+
+The status can be one of:
+
+CEC_TX_STATUS_OK: the transmit was successful.
+CEC_TX_STATUS_ARB_LOST: arbitration was lost: another CEC initiator
+took control of the CEC line and you lost the arbitration.
+CEC_TX_STATUS_NACK: the message was nacked (for a directed message) or
+acked (for a broadcast message). A retransmission is needed.
+CEC_TX_STATUS_LOW_DRIVE: low drive was detected on the CEC bus. This
+indicates that a follower detected an error on the bus and requested a
+retransmission.
+CEC_TX_STATUS_ERROR: some unspecified error occurred: this can be one of
+the previous two if the hardware cannot differentiate or something else
+entirely.
+CEC_TX_STATUS_MAX_RETRIES: could not transmit the message after
+trying multiple times. Should only be set by the driver if it has hardware
+support for retrying messages. If set, then the framework assumes that it
+doesn't have to make another attempt to transmit the message since the
+hardware did that already.
+
+The *_cnt arguments are the number of error conditions that were seen.
+This may be 0 if no information is available. Drivers that do not support
+hardware retry can just set the counter corresponding to the transmit error
+to 1, if the hardware does support retry then either set these counters to
+0 if the hardware provides no feedback of which errors occurred and how many
+times, or fill in the correct values as reported by the hardware.
+
+When a CEC message was received:
+
+void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);
+
+Speaks for itself.
+
+When the number connected inputs changes:
+
+void cec_connected_inputs(struct cec_adapter *adap, u16 connected_inputs);
+
+The connected_inputs argument is a bit mask where bit 0 refers to HDMI input 0,
+etc. Only the first ninputs (see CEC_ADAP_G_CAPS) bits can be 1, the remainder
+are always 0. This function should be called when the HDMI receiver driver
+detects when a new device is connected or disconnected from a given input.
+
+The CEC framework will pass this information on to the user.
+
+Implementing the High-Level CEC Adapter
+---------------------------------------
+
+The low-level operations drive the hardware, the high-level operations are
+CEC protocol driven. The following high-level callbacks are available:
+
+struct cec_adap_ops {
+	/* Low-level callbacks */
+	...
+
+	/* High-level CEC message callback */
+	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
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
+};
+
+The received() callback allows the driver to optionally handle a newly
+received CEC message
+
+	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
+
+If the driver wants to process a CEC message, then it can implement this
+callback. If it doesn't want to handle this message, then it should return
+-ENOMSG, otherwise the CEC framework assumes it processed this message and
+it will not no anything with it.
+
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
+
+CEC framework functions
+-----------------------
+
+CEC Adapter drivers can call the following CEC framework functions:
+
+int cec_transmit_msg(struct cec_adapter *adap, struct cec_msg *msg,
+		     bool block);
+
+Transmit a CEC message. If block is true, then wait until the message has been
+transmitted, otherwise just queue it and return.
+
+void cec_set_phys_addr(struct cec_adapter *adap, u16 phys_addr);
+
+Change the physical address. This function will set adap->phys_addr and
+send an event if it has changed.
+
+int cec_claim_log_addrs(struct cec_adapter *adap,
+			struct cec_log_addrs *log_addrs, bool block);
+
+Claim the CEC logical addresses. Should never be called if CEC_CAP_LOG_ADDRS
+is set. If block is true, then wait until the logical addresses have been
+claimed, otherwise just queue it and return. To unconfigure all logical
+addresses call this function with log_addrs set to NULL or with
+log_addrs->num_log_addrs set to 0. The block argument is ignored when
+unconfiguring.
+
+int _cec_enable(struct cec_adapter *adap, bool enable);
+int cec_enable(struct cec_adapter *adap, bool enable);
+
+Enable or disable the CEC adapter. HDMI transmitters will typically disable
+the adapter when the hotplug signal goes down and enable it after it went up
+again and the EDID was read containing the new physical address. Should never
+be called if CEC_CAP_STATE is set. The _cec_enable is the unlocked variant and
+cec_enable takes the adap->lock mutex and calls _cec_enable.
+
+u8 cec_sink_cdc_hpd(struct cec_adapter *adap, u8 input_port, u8 cdc_hpd_state);
+
+If an HDMI receiver supports hotplug signalling over CDC (CEC_CAP_CDC_HPD is
+set), then the driver should call this function whenever the hotplug state
+changes for an input. This call will send an appropriate CDC message over
+the CEC line. It returns CEC_OP_HPD_ERROR_NONE on success, if the adapter
+is unconfigured it returns CEC_OP_HPD_ERROR_INITIATOR_WRONG_STATE and if
+the cec_transmit fails it returns CEC_OP_HPD_ERROR_OTHER.
+
+void cec_log_status(struct cec_adapter *adap);
+
+This logs the current CEC adapter status in the kernel log. Useful for
+debugging and implementing the V4L2 VIDIOC_LOG_STATUS ioctl.
-- 
2.7.0

