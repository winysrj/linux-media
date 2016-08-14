Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:54585 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900AbcHNNTl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 09:19:41 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C6641180492
	for <linux-media@vger.kernel.org>; Sun, 14 Aug 2016 15:18:50 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-core.rst: convert old cec.txt to sphinx.
Message-ID: <d9859156-fb5d-1829-c880-0d58c5d8680e@xs4all.nl>
Date: Sun, 14 Aug 2016 15:18:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the old ascii CEC kapi documentation to sphinx documentation.

No textual changes, just an initial conversion.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/{cec.txt => media/kapi/cec-core.rst} | 202 ++++++++++++---------
 Documentation/media/media_kapi.rst                 |   1 +
 MAINTAINERS                                        |   4 +-
 3 files changed, 119 insertions(+), 88 deletions(-)
 rename Documentation/{cec.txt => media/kapi/cec-core.rst} (53%)

diff --git a/Documentation/cec.txt b/Documentation/media/kapi/cec-core.rst
similarity index 53%
rename from Documentation/cec.txt
rename to Documentation/media/kapi/cec-core.rst
index 75155fe..b776a59 100644
--- a/Documentation/cec.txt
+++ b/Documentation/media/kapi/cec-core.rst
@@ -1,5 +1,5 @@
 CEC Kernel Support
-==================
+------------------

 The CEC framework provides a unified kernel interface for use with HDMI CEC
 hardware. It is designed to handle a multiple types of hardware (receivers,
@@ -10,7 +10,7 @@ feature into the kernel's remote control framework.


 The CEC Protocol
-----------------
+~~~~~~~~~~~~~~~~

 The CEC protocol enables consumer electronic devices to communicate with each
 other through the HDMI connection. The protocol uses logical addresses in the
@@ -28,62 +28,65 @@ http://www.microprocessor.org/HDMISpecification13a.pdf


 The Kernel Interface
-====================
+~~~~~~~~~~~~~~~~~~~~

 CEC Adapter
------------
+^^^^^^^^^^^

 The struct cec_adapter represents the CEC adapter hardware. It is created by
 calling cec_allocate_adapter() and deleted by calling cec_delete_adapter():

-struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
+..  code-block:: c
+
+    struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 	       void *priv, const char *name, u32 caps, u8 available_las,
 	       struct device *parent);
-void cec_delete_adapter(struct cec_adapter *adap);
+    void cec_delete_adapter(struct cec_adapter *adap);

 To create an adapter you need to pass the following information:

-ops: adapter operations which are called by the CEC framework and that you
-have to implement.
-
-priv: will be stored in adap->priv and can be used by the adapter ops.
-
-name: the name of the CEC adapter. Note: this name will be copied.
+- ``ops``: adapter operations which are called by the CEC framework and that you
+  have to implement.
+- ``priv``: will be stored in ``adap->priv`` and can be used by the adapter ops.
+- ``name``: the name of the CEC adapter. Note: this name will be copied.
+- ``caps``: capabilities of the CEC adapter. These capabilities determine the
+  capabilities of the hardware and which parts are to be handled
+  by userspace and which parts are handled by kernelspace. The
+  capabilities are returned by ``CEC_ADAP_G_CAPS``.
+- ``available_las``: the number of simultaneous logical addresses that this
+  adapter can handle. Must be 1 <= ``available_las`` <= ``CEC_MAX_LOG_ADDRS``.
+- ``parent``: the parent device.

-caps: capabilities of the CEC adapter. These capabilities determine the
-	capabilities of the hardware and which parts are to be handled
-	by userspace and which parts are handled by kernelspace. The
-	capabilities are returned by CEC_ADAP_G_CAPS.

-available_las: the number of simultaneous logical addresses that this
-	adapter can handle. Must be 1 <= available_las <= CEC_MAX_LOG_ADDRS.
+To register the ``/dev/cecX`` device node and the remote control device (if
+``CEC_CAP_RC`` is set) you call:

-parent: the parent device.
+..  code-block:: c

-
-To register the /dev/cecX device node and the remote control device (if
-CEC_CAP_RC is set) you call:
-
-int cec_register_adapter(struct cec_adapter *adap);
+    int cec_register_adapter(struct cec_adapter *adap);

 To unregister the devices call:

-void cec_unregister_adapter(struct cec_adapter *adap);
+..  code-block:: c
+
+    void cec_unregister_adapter(struct cec_adapter *adap);

-Note: if cec_register_adapter() fails, then call cec_delete_adapter() to
-clean up. But if cec_register_adapter() succeeded, then only call
-cec_unregister_adapter() to clean up, never cec_delete_adapter(). The
+Note: if ``cec_register_adapter()`` fails, then call ``cec_delete_adapter()`` to
+clean up. But if ``cec_register_adapter()`` succeeded, then only call
+``cec_unregister_adapter()`` to clean up, never ``cec_delete_adapter()``. The
 unregister function will delete the adapter automatically once the last user
-of that /dev/cecX device has closed its file handle.
+of that ``/dev/cecX`` device has closed its file handle.


 Implementing the Low-Level CEC Adapter
---------------------------------------
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 The following low-level adapter operations have to be implemented in
 your driver:

-struct cec_adap_ops {
+..  code-block:: c
+
+    struct cec_adap_ops {
 	/* Low-level callbacks */
 	int (*adap_enable)(struct cec_adapter *adap, bool enable);
 	int (*adap_monitor_all_enable)(struct cec_adapter *adap, bool enable);
@@ -94,74 +97,87 @@ struct cec_adap_ops {

 	/* High-level callbacks */
 	...
-};
+    };

 The three low-level ops deal with various aspects of controlling the CEC adapter
-hardware:
-
+hardware.

 To enable/disable the hardware:

+..  code-block:: c
+
 	int (*adap_enable)(struct cec_adapter *adap, bool enable);

 This callback enables or disables the CEC hardware. Enabling the CEC hardware
 means powering it up in a state where no logical addresses are claimed. This
-op assumes that the physical address (adap->phys_addr) is valid when enable is
+op assumes that the physical address (``adap->phys_addr``) is valid when enable is
 true and will not change while the CEC adapter remains enabled. The initial
-state of the CEC adapter after calling cec_allocate_adapter() is disabled.
+state of the CEC adapter after calling ``cec_allocate_adapter()`` is disabled.

-Note that adap_enable must return 0 if enable is false.
+Note that ``adap_enable`` must return 0 if enable is false.


 To enable/disable the 'monitor all' mode:

+..  code-block:: c
+
 	int (*adap_monitor_all_enable)(struct cec_adapter *adap, bool enable);

 If enabled, then the adapter should be put in a mode to also monitor messages
 that not for us. Not all hardware supports this and this function is only
-called if the CEC_CAP_MONITOR_ALL capability is set. This callback is optional
+called if the ``CEC_CAP_MONITOR_ALL`` capability is set. This callback is optional
 (some hardware may always be in 'monitor all' mode).

-Note that adap_monitor_all_enable must return 0 if enable is false.
+Note that ``adap_monitor_all_enable`` must return 0 if enable is false.


 To program a new logical address:

+..  code-block:: c
+
 	int (*adap_log_addr)(struct cec_adapter *adap, u8 logical_addr);

-If logical_addr == CEC_LOG_ADDR_INVALID then all programmed logical addresses
+If ``logical_addr`` == ``CEC_LOG_ADDR_INVALID`` then all programmed logical addresses
 are to be erased. Otherwise the given logical address should be programmed.
 If the maximum number of available logical addresses is exceeded, then it
-should return -ENXIO. Once a logical address is programmed the CEC hardware
+should return ``-ENXIO``. Once a logical address is programmed the CEC hardware
 can receive directed messages to that address.

-Note that adap_log_addr must return 0 if logical_addr is CEC_LOG_ADDR_INVALID.
+Note that ``adap_log_addr`` must return 0 if logical_addr is ``CEC_LOG_ADDR_INVALID``.


 To transmit a new message:

+..  code-block:: c
+
 	int (*adap_transmit)(struct cec_adapter *adap, u8 attempts,
 			     u32 signal_free_time, struct cec_msg *msg);

-This transmits a new message. The attempts argument is the suggested number of
+This transmits a new message. The ``attempts`` argument is the suggested number of
 attempts for the transmit.

-The signal_free_time is the number of data bit periods that the adapter should
+The ``signal_free_time`` is the number of data bit periods that the adapter should
 wait when the line is free before attempting to send a message. This value
 depends on whether this transmit is a retry, a message from a new initiator or
 a new message for the same initiator. Most hardware will handle this
 automatically, but in some cases this information is needed.

-The CEC_FREE_TIME_TO_USEC macro can be used to convert signal_free_time to
+The ``CEC_FREE_TIME_TO_USEC`` macro can be used to convert ``signal_free_time`` to
 microseconds (one data bit period is 2.4 ms).


 To log the current CEC hardware status:

-	void (*adap_status)(struct cec_adapter *adap, struct seq_file *file);
+..  code-block:: c
+
+    void (*adap_status)(struct cec_adapter *adap, struct seq_file *file);

 This optional callback can be used to show the status of the CEC hardware.
-The status is available through debugfs: cat /sys/kernel/debug/cec/cecX/status
+The status is available through debugfs:
+
+..  code-block:: c
+
+    cat /sys/kernel/debug/cec/cecX/status


 Your adapter driver will also have to react to events (typically interrupt
@@ -169,29 +185,31 @@ driven) by calling into the framework in the following situations:

 When a transmit finished (successfully or otherwise):

-void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
+..  code-block:: c
+
+    void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
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
-
-The *_cnt arguments are the number of error conditions that were seen.
+- ``CEC_TX_STATUS_OK``: the transmit was successful.
+- ``CEC_TX_STATUS_ARB_LOST``: arbitration was lost: another CEC initiator
+  took control of the CEC line and you lost the arbitration.
+- ``CEC_TX_STATUS_NACK``: the message was nacked (for a directed message) or
+  acked (for a broadcast message). A retransmission is needed.
+- ``CEC_TX_STATUS_LOW_DRIVE``: low drive was detected on the CEC bus. This
+  indicates that a follower detected an error on the bus and requested a
+  retransmission.
+- ``CEC_TX_STATUS_ERROR``: some unspecified error occurred: this can be one of
+  the previous two if the hardware cannot differentiate or something else
+  entirely.
+- ``CEC_TX_STATUS_MAX_RETRIES``: could not transmit the message after
+  trying multiple times. Should only be set by the driver if it has hardware
+  support for retrying messages. If set, then the framework assumes that it
+  doesn't have to make another attempt to transmit the message since the
+  hardware did that already.
+
+The ``_cnt`` arguments are the number of error conditions that were seen.
 This may be 0 if no information is available. Drivers that do not support
 hardware retry can just set the counter corresponding to the transmit error
 to 1, if the hardware does support retry then either set these counters to
@@ -200,68 +218,80 @@ times, or fill in the correct values as reported by the hardware.

 When a CEC message was received:

-void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);
+..  code-block:: c
+
+    void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);

 Speaks for itself.

 Implementing the High-Level CEC Adapter
----------------------------------------
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

 The low-level operations drive the hardware, the high-level operations are
 CEC protocol driven. The following high-level callbacks are available:

-struct cec_adap_ops {
+..  code-block:: c
+
+    struct cec_adap_ops {
 	/* Low-level callbacks */
 	...

 	/* High-level CEC message callback */
 	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);
-};
+    };

-The received() callback allows the driver to optionally handle a newly
+The ``received()`` callback allows the driver to optionally handle a newly
 received CEC message

+..  code-block:: c
+
 	int (*received)(struct cec_adapter *adap, struct cec_msg *msg);

 If the driver wants to process a CEC message, then it can implement this
 callback. If it doesn't want to handle this message, then it should return
--ENOMSG, otherwise the CEC framework assumes it processed this message and
+``-ENOMSG``, otherwise the CEC framework assumes it processed this message and
 it will not no anything with it.


 CEC framework functions
------------------------
+^^^^^^^^^^^^^^^^^^^^^^^

 CEC Adapter drivers can call the following CEC framework functions:

-int cec_transmit_msg(struct cec_adapter *adap, struct cec_msg *msg,
+..  code-block:: c
+
+    int cec_transmit_msg(struct cec_adapter *adap, struct cec_msg *msg,
 		     bool block);

-Transmit a CEC message. If block is true, then wait until the message has been
+Transmit a CEC message. If ``block`` is true, then wait until the message has been
 transmitted, otherwise just queue it and return.

-void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block);
+..  code-block:: c

-Change the physical address. This function will set adap->phys_addr and
-send an event if it has changed. If cec_s_log_addrs() has been called and
+    void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block);
+
+Change the physical address. This function will set ``adap->phys_addr`` and
+send an event if it has changed. If ``cec_s_log_addrs()`` has been called and
 the physical address has become valid, then the CEC framework will start
-claiming the logical addresses. If block is true, then this function won't
+claiming the logical addresses. If ``block`` is true, then this function won't
 return until this process has finished.

 When the physical address is set to a valid value the CEC adapter will
-be enabled (see the adap_enable op). When it is set to CEC_PHYS_ADDR_INVALID,
+be enabled (see the ``adap_enable`` op). When it is set to ``CEC_PHYS_ADDR_INVALID``,
 then the CEC adapter will be disabled. If you change a valid physical address
 to another valid physical address, then this function will first set the
-address to CEC_PHYS_ADDR_INVALID before enabling the new physical address.
+address to ``CEC_PHYS_ADDR_INVALID`` before enabling the new physical address.
+
+..  code-block:: c

-int cec_s_log_addrs(struct cec_adapter *adap,
+    int cec_s_log_addrs(struct cec_adapter *adap,
 		    struct cec_log_addrs *log_addrs, bool block);

-Claim the CEC logical addresses. Should never be called if CEC_CAP_LOG_ADDRS
-is set. If block is true, then wait until the logical addresses have been
+Claim the CEC logical addresses. Should never be called if ``CEC_CAP_LOG_ADDRS``
+is set. If ``block`` is true, then wait until the logical addresses have been
 claimed, otherwise just queue it and return. To unconfigure all logical
-addresses call this function with log_addrs set to NULL or with
-log_addrs->num_log_addrs set to 0. The block argument is ignored when
+addresses call this function with ``log_addrs`` set to ``NULL`` or with
+``log_addrs->num_log_addrs`` set to 0. The ``block`` argument is ignored when
 unconfiguring. This function will just return if the physical address is
 invalid. Once the physical address becomes valid, then the framework will
 attempt to claim these logical addresses.
diff --git a/Documentation/media/media_kapi.rst b/Documentation/media/media_kapi.rst
index b71e8e8..f282ca2 100644
--- a/Documentation/media/media_kapi.rst
+++ b/Documentation/media/media_kapi.rst
@@ -32,3 +32,4 @@ For more details see the file COPYING in the source distribution of Linux.
     kapi/dtv-core
     kapi/rc-core
     kapi/mc-core
+    kapi/cec-core
diff --git a/MAINTAINERS b/MAINTAINERS
index 20bb1d0..b1081c6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2901,8 +2901,8 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
 S:	Supported
-F:	Documentation/cec.txt
-F:	Documentation/DocBook/media/v4l/cec*
+F:	Documentation/media/kapi/cec-core.rst
+F:	Documentation/media/uapi/cec/
 F:	drivers/staging/media/cec/
 F:	drivers/media/cec-edid.c
 F:	drivers/media/rc/keymaps/rc-cec.c
-- 
2.8.1

