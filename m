Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:60588 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752509AbcKBMqi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Nov 2016 08:46:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 02/11] cec rst: convert tables and drop the 'row' comments
Date: Wed,  2 Nov 2016 13:46:26 +0100
Message-Id: <20161102124635.11989-3-hverkuil@xs4all.nl>
In-Reply-To: <20161102124635.11989-1-hverkuil@xs4all.nl>
References: <20161102124635.11989-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This uses Laurent's python script to convert all tables, dropping
the useless 'row' comments.

See commit c2b66cafdf02 ("[media] v4l: doc: Remove row numbers from tables")
for the script that was used.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         | 156 +++----
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    | 475 ++++++++-------------
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   | 182 +++-----
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    | 317 ++++++--------
 Documentation/media/uapi/cec/cec-ioc-receive.rst   | 394 +++++++----------
 5 files changed, 579 insertions(+), 945 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index a35dca2..2b0ddb1 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -48,41 +48,21 @@ returns the information to the application. The ioctl never fails.
     :stub-columns: 0
     :widths:       1 1 16
 
-
-    -  .. row 1
-
-       -  char
-
-       -  ``driver[32]``
-
-       -  The name of the cec adapter driver.
-
-    -  .. row 2
-
-       -  char
-
-       -  ``name[32]``
-
-       -  The name of this CEC adapter. The combination ``driver`` and
-	  ``name`` must be unique.
-
-    -  .. row 3
-
-       -  __u32
-
-       -  ``capabilities``
-
-       -  The capabilities of the CEC adapter, see
-	  :ref:`cec-capabilities`.
-
-    -  .. row 4
-
-       -  __u32
-
-       -  ``version``
-
-       -  CEC Framework API version, formatted with the ``KERNEL_VERSION()``
-	  macro.
+    * - char
+      - ``driver[32]``
+      - The name of the cec adapter driver.
+    * - char
+      - ``name[32]``
+      - The name of this CEC adapter. The combination ``driver`` and
+	``name`` must be unique.
+    * - __u32
+      - ``capabilities``
+      - The capabilities of the CEC adapter, see
+	:ref:`cec-capabilities`.
+    * - __u32
+      - ``version``
+      - CEC Framework API version, formatted with the ``KERNEL_VERSION()``
+	macro.
 
 
 .. tabularcolumns:: |p{4.4cm}|p{2.5cm}|p{10.6cm}|
@@ -94,68 +74,50 @@ returns the information to the application. The ioctl never fails.
     :stub-columns: 0
     :widths:       3 1 8
 
-
-    -  .. _`CEC-CAP-PHYS-ADDR`:
-
-       -  ``CEC_CAP_PHYS_ADDR``
-
-       -  0x00000001
-
-       -  Userspace has to configure the physical address by calling
-	  :ref:`ioctl CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>`. If
-	  this capability isn't set, then setting the physical address is
-	  handled by the kernel whenever the EDID is set (for an HDMI
-	  receiver) or read (for an HDMI transmitter).
-
-    -  .. _`CEC-CAP-LOG-ADDRS`:
-
-       -  ``CEC_CAP_LOG_ADDRS``
-
-       -  0x00000002
-
-       -  Userspace has to configure the logical addresses by calling
-	  :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`. If
-	  this capability isn't set, then the kernel will have configured
-	  this.
-
-    -  .. _`CEC-CAP-TRANSMIT`:
-
-       -  ``CEC_CAP_TRANSMIT``
-
-       -  0x00000004
-
-       -  Userspace can transmit CEC messages by calling
-	  :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>`. This implies that
-	  userspace can be a follower as well, since being able to transmit
-	  messages is a prerequisite of becoming a follower. If this
-	  capability isn't set, then the kernel will handle all CEC
-	  transmits and process all CEC messages it receives.
-
-    -  .. _`CEC-CAP-PASSTHROUGH`:
-
-       -  ``CEC_CAP_PASSTHROUGH``
-
-       -  0x00000008
-
-       -  Userspace can use the passthrough mode by calling
-	  :ref:`ioctl CEC_S_MODE <CEC_S_MODE>`.
-
-    -  .. _`CEC-CAP-RC`:
-
-       -  ``CEC_CAP_RC``
-
-       -  0x00000010
-
-       -  This adapter supports the remote control protocol.
-
-    -  .. _`CEC-CAP-MONITOR-ALL`:
-
-       -  ``CEC_CAP_MONITOR_ALL``
-
-       -  0x00000020
-
-       -  The CEC hardware can monitor all messages, not just directed and
-	  broadcast messages.
+    * .. _`CEC-CAP-PHYS-ADDR`:
+
+      - ``CEC_CAP_PHYS_ADDR``
+      - 0x00000001
+      - Userspace has to configure the physical address by calling
+	:ref:`ioctl CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>`. If
+	this capability isn't set, then setting the physical address is
+	handled by the kernel whenever the EDID is set (for an HDMI
+	receiver) or read (for an HDMI transmitter).
+    * .. _`CEC-CAP-LOG-ADDRS`:
+
+      - ``CEC_CAP_LOG_ADDRS``
+      - 0x00000002
+      - Userspace has to configure the logical addresses by calling
+	:ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`. If
+	this capability isn't set, then the kernel will have configured
+	this.
+    * .. _`CEC-CAP-TRANSMIT`:
+
+      - ``CEC_CAP_TRANSMIT``
+      - 0x00000004
+      - Userspace can transmit CEC messages by calling
+	:ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>`. This implies that
+	userspace can be a follower as well, since being able to transmit
+	messages is a prerequisite of becoming a follower. If this
+	capability isn't set, then the kernel will handle all CEC
+	transmits and process all CEC messages it receives.
+    * .. _`CEC-CAP-PASSTHROUGH`:
+
+      - ``CEC_CAP_PASSTHROUGH``
+      - 0x00000008
+      - Userspace can use the passthrough mode by calling
+	:ref:`ioctl CEC_S_MODE <CEC_S_MODE>`.
+    * .. _`CEC-CAP-RC`:
+
+      - ``CEC_CAP_RC``
+      - 0x00000010
+      - This adapter supports the remote control protocol.
+    * .. _`CEC-CAP-MONITOR-ALL`:
+
+      - ``CEC_CAP_MONITOR_ALL``
+      - 0x00000020
+      - The CEC hardware can monitor all messages, not just directed and
+	broadcast messages.
 
 
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 940a16d..af35f71 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -77,134 +77,79 @@ logical address types are already defined will return with error ``EBUSY``.
     :stub-columns: 0
     :widths:       1 1 16
 
-
-    -  .. row 1
-
-       -  __u8
-
-       -  ``log_addr[CEC_MAX_LOG_ADDRS]``
-
-       -  The actual logical addresses that were claimed. This is set by the
-	  driver. If no logical address could be claimed, then it is set to
-	  ``CEC_LOG_ADDR_INVALID``. If this adapter is Unregistered, then
-	  ``log_addr[0]`` is set to 0xf and all others to
-	  ``CEC_LOG_ADDR_INVALID``.
-
-    -  .. row 2
-
-       -  __u16
-
-       -  ``log_addr_mask``
-
-       -  The bitmask of all logical addresses this adapter has claimed. If
-	  this adapter is Unregistered then ``log_addr_mask`` sets bit 15
-	  and clears all other bits. If this adapter is not configured at
-	  all, then ``log_addr_mask`` is set to 0. Set by the driver.
-
-    -  .. row 3
-
-       -  __u8
-
-       -  ``cec_version``
-
-       -  The CEC version that this adapter shall use. See
-	  :ref:`cec-versions`. Used to implement the
-	  ``CEC_MSG_CEC_VERSION`` and ``CEC_MSG_REPORT_FEATURES`` messages.
-	  Note that :ref:`CEC_OP_CEC_VERSION_1_3A <CEC-OP-CEC-VERSION-1-3A>` is not allowed by the CEC
-	  framework.
-
-    -  .. row 4
-
-       -  __u8
-
-       -  ``num_log_addrs``
-
-       -  Number of logical addresses to set up. Must be ≤
-	  ``available_log_addrs`` as returned by
-	  :ref:`CEC_ADAP_G_CAPS`. All arrays in
-	  this structure are only filled up to index
-	  ``available_log_addrs``-1. The remaining array elements will be
-	  ignored. Note that the CEC 2.0 standard allows for a maximum of 2
-	  logical addresses, although some hardware has support for more.
-	  ``CEC_MAX_LOG_ADDRS`` is 4. The driver will return the actual
-	  number of logical addresses it could claim, which may be less than
-	  what was requested. If this field is set to 0, then the CEC
-	  adapter shall clear all claimed logical addresses and all other
-	  fields will be ignored.
-
-    -  .. row 5
-
-       -  __u32
-
-       -  ``vendor_id``
-
-       -  The vendor ID is a 24-bit number that identifies the specific
-	  vendor or entity. Based on this ID vendor specific commands may be
-	  defined. If you do not want a vendor ID then set it to
-	  ``CEC_VENDOR_ID_NONE``.
-
-    -  .. row 6
-
-       -  __u32
-
-       -  ``flags``
-
-       -  Flags. See :ref:`cec-log-addrs-flags` for a list of available flags.
-
-    -  .. row 7
-
-       -  char
-
-       -  ``osd_name[15]``
-
-       -  The On-Screen Display name as is returned by the
-	  ``CEC_MSG_SET_OSD_NAME`` message.
-
-    -  .. row 8
-
-       -  __u8
-
-       -  ``primary_device_type[CEC_MAX_LOG_ADDRS]``
-
-       -  Primary device type for each logical address. See
-	  :ref:`cec-prim-dev-types` for possible types.
-
-    -  .. row 9
-
-       -  __u8
-
-       -  ``log_addr_type[CEC_MAX_LOG_ADDRS]``
-
-       -  Logical address types. See :ref:`cec-log-addr-types` for
-	  possible types. The driver will update this with the actual
-	  logical address type that it claimed (e.g. it may have to fallback
-	  to :ref:`CEC_LOG_ADDR_TYPE_UNREGISTERED <CEC-LOG-ADDR-TYPE-UNREGISTERED>`).
-
-    -  .. row 10
-
-       -  __u8
-
-       -  ``all_device_types[CEC_MAX_LOG_ADDRS]``
-
-       -  CEC 2.0 specific: the bit mask of all device types. See
-	  :ref:`cec-all-dev-types-flags`. It is used in the CEC 2.0
-	  ``CEC_MSG_REPORT_FEATURES`` message. For CEC 1.4 you can either leave
-	  this field to 0, or fill it in according to the CEC 2.0 guidelines to
-	  give the CEC framework more information about the device type, even
-	  though the framework won't use it directly in the CEC message.
-
-    -  .. row 11
-
-       -  __u8
-
-       -  ``features[CEC_MAX_LOG_ADDRS][12]``
-
-       -  Features for each logical address. It is used in the CEC 2.0
-	  ``CEC_MSG_REPORT_FEATURES`` message. The 12 bytes include both the
-	  RC Profile and the Device Features. For CEC 1.4 you can either leave
-          this field to all 0, or fill it in according to the CEC 2.0 guidelines to
-          give the CEC framework more information about the device type, even
-          though the framework won't use it directly in the CEC message.
+    * - __u8
+      - ``log_addr[CEC_MAX_LOG_ADDRS]``
+      - The actual logical addresses that were claimed. This is set by the
+	driver. If no logical address could be claimed, then it is set to
+	``CEC_LOG_ADDR_INVALID``. If this adapter is Unregistered, then
+	``log_addr[0]`` is set to 0xf and all others to
+	``CEC_LOG_ADDR_INVALID``.
+    * - __u16
+      - ``log_addr_mask``
+      - The bitmask of all logical addresses this adapter has claimed. If
+	this adapter is Unregistered then ``log_addr_mask`` sets bit 15
+	and clears all other bits. If this adapter is not configured at
+	all, then ``log_addr_mask`` is set to 0. Set by the driver.
+    * - __u8
+      - ``cec_version``
+      - The CEC version that this adapter shall use. See
+	:ref:`cec-versions`. Used to implement the
+	``CEC_MSG_CEC_VERSION`` and ``CEC_MSG_REPORT_FEATURES`` messages.
+	Note that :ref:`CEC_OP_CEC_VERSION_1_3A <CEC-OP-CEC-VERSION-1-3A>` is not allowed by the CEC
+	framework.
+    * - __u8
+      - ``num_log_addrs``
+      - Number of logical addresses to set up. Must be ≤
+	``available_log_addrs`` as returned by
+	:ref:`CEC_ADAP_G_CAPS`. All arrays in
+	this structure are only filled up to index
+	``available_log_addrs``-1. The remaining array elements will be
+	ignored. Note that the CEC 2.0 standard allows for a maximum of 2
+	logical addresses, although some hardware has support for more.
+	``CEC_MAX_LOG_ADDRS`` is 4. The driver will return the actual
+	number of logical addresses it could claim, which may be less than
+	what was requested. If this field is set to 0, then the CEC
+	adapter shall clear all claimed logical addresses and all other
+	fields will be ignored.
+    * - __u32
+      - ``vendor_id``
+      - The vendor ID is a 24-bit number that identifies the specific
+	vendor or entity. Based on this ID vendor specific commands may be
+	defined. If you do not want a vendor ID then set it to
+	``CEC_VENDOR_ID_NONE``.
+    * - __u32
+      - ``flags``
+      - Flags. See :ref:`cec-log-addrs-flags` for a list of available flags.
+    * - char
+      - ``osd_name[15]``
+      - The On-Screen Display name as is returned by the
+	``CEC_MSG_SET_OSD_NAME`` message.
+    * - __u8
+      - ``primary_device_type[CEC_MAX_LOG_ADDRS]``
+      - Primary device type for each logical address. See
+	:ref:`cec-prim-dev-types` for possible types.
+    * - __u8
+      - ``log_addr_type[CEC_MAX_LOG_ADDRS]``
+      - Logical address types. See :ref:`cec-log-addr-types` for
+	possible types. The driver will update this with the actual
+	logical address type that it claimed (e.g. it may have to fallback
+	to :ref:`CEC_LOG_ADDR_TYPE_UNREGISTERED <CEC-LOG-ADDR-TYPE-UNREGISTERED>`).
+    * - __u8
+      - ``all_device_types[CEC_MAX_LOG_ADDRS]``
+      - CEC 2.0 specific: the bit mask of all device types. See
+	:ref:`cec-all-dev-types-flags`. It is used in the CEC 2.0
+	``CEC_MSG_REPORT_FEATURES`` message. For CEC 1.4 you can either leave
+	this field to 0, or fill it in according to the CEC 2.0 guidelines to
+	give the CEC framework more information about the device type, even
+	though the framework won't use it directly in the CEC message.
+    * - __u8
+      - ``features[CEC_MAX_LOG_ADDRS][12]``
+      - Features for each logical address. It is used in the CEC 2.0
+	``CEC_MSG_REPORT_FEATURES`` message. The 12 bytes include both the
+	RC Profile and the Device Features. For CEC 1.4 you can either leave
+        this field to all 0, or fill it in according to the CEC 2.0 guidelines to
+        give the CEC framework more information about the device type, even
+        though the framework won't use it directly in the CEC message.
 
 .. _cec-log-addrs-flags:
 
@@ -213,17 +158,14 @@ logical address types are already defined will return with error ``EBUSY``.
     :stub-columns: 0
     :widths:       3 1 4
 
+    * .. _`CEC-LOG-ADDRS-FL-ALLOW-UNREG-FALLBACK`:
 
-    -  .. _`CEC-LOG-ADDRS-FL-ALLOW-UNREG-FALLBACK`:
-
-       -  ``CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK``
-
-       -  1
-
-       -  By default if no logical address of the requested type can be claimed, then
-	  it will go back to the unconfigured state. If this flag is set, then it will
-	  fallback to the Unregistered logical address. Note that if the Unregistered
-	  logical address was explicitly requested, then this flag has no effect.
+      - ``CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK``
+      - 1
+      - By default if no logical address of the requested type can be claimed, then
+	it will go back to the unconfigured state. If this flag is set, then it will
+	fallback to the Unregistered logical address. Note that if the Unregistered
+	logical address was explicitly requested, then this flag has no effect.
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
@@ -234,30 +176,21 @@ logical address types are already defined will return with error ``EBUSY``.
     :stub-columns: 0
     :widths:       3 1 4
 
+    * .. _`CEC-OP-CEC-VERSION-1-3A`:
 
-    -  .. _`CEC-OP-CEC-VERSION-1-3A`:
-
-       -  ``CEC_OP_CEC_VERSION_1_3A``
-
-       -  4
-
-       -  CEC version according to the HDMI 1.3a standard.
-
-    -  .. _`CEC-OP-CEC-VERSION-1-4B`:
+      - ``CEC_OP_CEC_VERSION_1_3A``
+      - 4
+      - CEC version according to the HDMI 1.3a standard.
+    * .. _`CEC-OP-CEC-VERSION-1-4B`:
 
-       -  ``CEC_OP_CEC_VERSION_1_4B``
+      - ``CEC_OP_CEC_VERSION_1_4B``
+      - 5
+      - CEC version according to the HDMI 1.4b standard.
+    * .. _`CEC-OP-CEC-VERSION-2-0`:
 
-       -  5
-
-       -  CEC version according to the HDMI 1.4b standard.
-
-    -  .. _`CEC-OP-CEC-VERSION-2-0`:
-
-       -  ``CEC_OP_CEC_VERSION_2_0``
-
-       -  6
-
-       -  CEC version according to the HDMI 2.0 standard.
+      - ``CEC_OP_CEC_VERSION_2_0``
+      - 6
+      - CEC version according to the HDMI 2.0 standard.
 
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
@@ -269,62 +202,41 @@ logical address types are already defined will return with error ``EBUSY``.
     :stub-columns: 0
     :widths:       3 1 4
 
+    * .. _`CEC-OP-PRIM-DEVTYPE-TV`:
 
-    -  .. _`CEC-OP-PRIM-DEVTYPE-TV`:
-
-       -  ``CEC_OP_PRIM_DEVTYPE_TV``
-
-       -  0
+      - ``CEC_OP_PRIM_DEVTYPE_TV``
+      - 0
+      - Use for a TV.
+    * .. _`CEC-OP-PRIM-DEVTYPE-RECORD`:
 
-       -  Use for a TV.
+      - ``CEC_OP_PRIM_DEVTYPE_RECORD``
+      - 1
+      - Use for a recording device.
+    * .. _`CEC-OP-PRIM-DEVTYPE-TUNER`:
 
-    -  .. _`CEC-OP-PRIM-DEVTYPE-RECORD`:
+      - ``CEC_OP_PRIM_DEVTYPE_TUNER``
+      - 3
+      - Use for a device with a tuner.
+    * .. _`CEC-OP-PRIM-DEVTYPE-PLAYBACK`:
 
-       -  ``CEC_OP_PRIM_DEVTYPE_RECORD``
+      - ``CEC_OP_PRIM_DEVTYPE_PLAYBACK``
+      - 4
+      - Use for a playback device.
+    * .. _`CEC-OP-PRIM-DEVTYPE-AUDIOSYSTEM`:
 
-       -  1
+      - ``CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM``
+      - 5
+      - Use for an audio system (e.g. an audio/video receiver).
+    * .. _`CEC-OP-PRIM-DEVTYPE-SWITCH`:
 
-       -  Use for a recording device.
+      - ``CEC_OP_PRIM_DEVTYPE_SWITCH``
+      - 6
+      - Use for a CEC switch.
+    * .. _`CEC-OP-PRIM-DEVTYPE-VIDEOPROC`:
 
-    -  .. _`CEC-OP-PRIM-DEVTYPE-TUNER`:
-
-       -  ``CEC_OP_PRIM_DEVTYPE_TUNER``
-
-       -  3
-
-       -  Use for a device with a tuner.
-
-    -  .. _`CEC-OP-PRIM-DEVTYPE-PLAYBACK`:
-
-       -  ``CEC_OP_PRIM_DEVTYPE_PLAYBACK``
-
-       -  4
-
-       -  Use for a playback device.
-
-    -  .. _`CEC-OP-PRIM-DEVTYPE-AUDIOSYSTEM`:
-
-       -  ``CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM``
-
-       -  5
-
-       -  Use for an audio system (e.g. an audio/video receiver).
-
-    -  .. _`CEC-OP-PRIM-DEVTYPE-SWITCH`:
-
-       -  ``CEC_OP_PRIM_DEVTYPE_SWITCH``
-
-       -  6
-
-       -  Use for a CEC switch.
-
-    -  .. _`CEC-OP-PRIM-DEVTYPE-VIDEOPROC`:
-
-       -  ``CEC_OP_PRIM_DEVTYPE_VIDEOPROC``
-
-       -  7
-
-       -  Use for a video processor device.
+      - ``CEC_OP_PRIM_DEVTYPE_VIDEOPROC``
+      - 7
+      - Use for a video processor device.
 
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
@@ -336,64 +248,43 @@ logical address types are already defined will return with error ``EBUSY``.
     :stub-columns: 0
     :widths:       3 1 16
 
+    * .. _`CEC-LOG-ADDR-TYPE-TV`:
 
-    -  .. _`CEC-LOG-ADDR-TYPE-TV`:
-
-       -  ``CEC_LOG_ADDR_TYPE_TV``
-
-       -  0
-
-       -  Use for a TV.
-
-    -  .. _`CEC-LOG-ADDR-TYPE-RECORD`:
-
-       -  ``CEC_LOG_ADDR_TYPE_RECORD``
-
-       -  1
-
-       -  Use for a recording device.
-
-    -  .. _`CEC-LOG-ADDR-TYPE-TUNER`:
-
-       -  ``CEC_LOG_ADDR_TYPE_TUNER``
-
-       -  2
+      - ``CEC_LOG_ADDR_TYPE_TV``
+      - 0
+      - Use for a TV.
+    * .. _`CEC-LOG-ADDR-TYPE-RECORD`:
 
-       -  Use for a tuner device.
+      - ``CEC_LOG_ADDR_TYPE_RECORD``
+      - 1
+      - Use for a recording device.
+    * .. _`CEC-LOG-ADDR-TYPE-TUNER`:
 
-    -  .. _`CEC-LOG-ADDR-TYPE-PLAYBACK`:
+      - ``CEC_LOG_ADDR_TYPE_TUNER``
+      - 2
+      - Use for a tuner device.
+    * .. _`CEC-LOG-ADDR-TYPE-PLAYBACK`:
 
-       -  ``CEC_LOG_ADDR_TYPE_PLAYBACK``
+      - ``CEC_LOG_ADDR_TYPE_PLAYBACK``
+      - 3
+      - Use for a playback device.
+    * .. _`CEC-LOG-ADDR-TYPE-AUDIOSYSTEM`:
 
-       -  3
+      - ``CEC_LOG_ADDR_TYPE_AUDIOSYSTEM``
+      - 4
+      - Use for an audio system device.
+    * .. _`CEC-LOG-ADDR-TYPE-SPECIFIC`:
 
-       -  Use for a playback device.
+      - ``CEC_LOG_ADDR_TYPE_SPECIFIC``
+      - 5
+      - Use for a second TV or for a video processor device.
+    * .. _`CEC-LOG-ADDR-TYPE-UNREGISTERED`:
 
-    -  .. _`CEC-LOG-ADDR-TYPE-AUDIOSYSTEM`:
-
-       -  ``CEC_LOG_ADDR_TYPE_AUDIOSYSTEM``
-
-       -  4
-
-       -  Use for an audio system device.
-
-    -  .. _`CEC-LOG-ADDR-TYPE-SPECIFIC`:
-
-       -  ``CEC_LOG_ADDR_TYPE_SPECIFIC``
-
-       -  5
-
-       -  Use for a second TV or for a video processor device.
-
-    -  .. _`CEC-LOG-ADDR-TYPE-UNREGISTERED`:
-
-       -  ``CEC_LOG_ADDR_TYPE_UNREGISTERED``
-
-       -  6
-
-       -  Use this if you just want to remain unregistered. Used for pure
-	  CEC switches or CDC-only devices (CDC: Capability Discovery and
-	  Control).
+      - ``CEC_LOG_ADDR_TYPE_UNREGISTERED``
+      - 6
+      - Use this if you just want to remain unregistered. Used for pure
+	CEC switches or CDC-only devices (CDC: Capability Discovery and
+	Control).
 
 
 
@@ -406,54 +297,36 @@ logical address types are already defined will return with error ``EBUSY``.
     :stub-columns: 0
     :widths:       3 1 4
 
+    * .. _`CEC-OP-ALL-DEVTYPE-TV`:
 
-    -  .. _`CEC-OP-ALL-DEVTYPE-TV`:
-
-       -  ``CEC_OP_ALL_DEVTYPE_TV``
-
-       -  0x80
-
-       -  This supports the TV type.
-
-    -  .. _`CEC-OP-ALL-DEVTYPE-RECORD`:
-
-       -  ``CEC_OP_ALL_DEVTYPE_RECORD``
-
-       -  0x40
-
-       -  This supports the Recording type.
-
-    -  .. _`CEC-OP-ALL-DEVTYPE-TUNER`:
-
-       -  ``CEC_OP_ALL_DEVTYPE_TUNER``
-
-       -  0x20
-
-       -  This supports the Tuner type.
-
-    -  .. _`CEC-OP-ALL-DEVTYPE-PLAYBACK`:
-
-       -  ``CEC_OP_ALL_DEVTYPE_PLAYBACK``
-
-       -  0x10
-
-       -  This supports the Playback type.
-
-    -  .. _`CEC-OP-ALL-DEVTYPE-AUDIOSYSTEM`:
-
-       -  ``CEC_OP_ALL_DEVTYPE_AUDIOSYSTEM``
-
-       -  0x08
+      - ``CEC_OP_ALL_DEVTYPE_TV``
+      - 0x80
+      - This supports the TV type.
+    * .. _`CEC-OP-ALL-DEVTYPE-RECORD`:
 
-       -  This supports the Audio System type.
+      - ``CEC_OP_ALL_DEVTYPE_RECORD``
+      - 0x40
+      - This supports the Recording type.
+    * .. _`CEC-OP-ALL-DEVTYPE-TUNER`:
 
-    -  .. _`CEC-OP-ALL-DEVTYPE-SWITCH`:
+      - ``CEC_OP_ALL_DEVTYPE_TUNER``
+      - 0x20
+      - This supports the Tuner type.
+    * .. _`CEC-OP-ALL-DEVTYPE-PLAYBACK`:
 
-       -  ``CEC_OP_ALL_DEVTYPE_SWITCH``
+      - ``CEC_OP_ALL_DEVTYPE_PLAYBACK``
+      - 0x10
+      - This supports the Playback type.
+    * .. _`CEC-OP-ALL-DEVTYPE-AUDIOSYSTEM`:
 
-       -  0x04
+      - ``CEC_OP_ALL_DEVTYPE_AUDIOSYSTEM``
+      - 0x08
+      - This supports the Audio System type.
+    * .. _`CEC-OP-ALL-DEVTYPE-SWITCH`:
 
-       -  This supports the CEC Switch or Video Processing type.
+      - ``CEC_OP_ALL_DEVTYPE_SWITCH``
+      - 0x04
+      - This supports the CEC Switch or Video Processing type.
 
 
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index e283588..e256c66 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -58,26 +58,16 @@ it is guaranteed that the state did change in between the two events.
     :stub-columns: 0
     :widths:       1 1 8
 
-
-    -  .. row 1
-
-       -  __u16
-
-       -  ``phys_addr``
-
-       -  The current physical address. This is ``CEC_PHYS_ADDR_INVALID`` if no
+    * - __u16
+      - ``phys_addr``
+      - The current physical address. This is ``CEC_PHYS_ADDR_INVALID`` if no
           valid physical address is set.
-
-    -  .. row 2
-
-       -  __u16
-
-       -  ``log_addr_mask``
-
-       -  The current set of claimed logical addresses. This is 0 if no logical
-          addresses are claimed or if ``phys_addr`` is ``CEC_PHYS_ADDR_INVALID``.
-	  If bit 15 is set (``1 << CEC_LOG_ADDR_UNREGISTERED``) then this device
-	  has the unregistered logical address. In that case all other bits are 0.
+    * - __u16
+      - ``log_addr_mask``
+      - The current set of claimed logical addresses. This is 0 if no logical
+        addresses are claimed or if ``phys_addr`` is ``CEC_PHYS_ADDR_INVALID``.
+	If bit 15 is set (``1 << CEC_LOG_ADDR_UNREGISTERED``) then this device
+	has the unregistered logical address. In that case all other bits are 0.
 
 
 .. c:type:: cec_event_lost_msgs
@@ -89,22 +79,17 @@ it is guaranteed that the state did change in between the two events.
     :stub-columns: 0
     :widths:       1 1 16
 
-
-    -  .. row 1
-
-       -  __u32
-
-       -  ``lost_msgs``
-
-       -  Set to the number of lost messages since the filehandle was opened
-	  or since the last time this event was dequeued for this
-	  filehandle. The messages lost are the oldest messages. So when a
-	  new message arrives and there is no more room, then the oldest
-	  message is discarded to make room for the new one. The internal
-	  size of the message queue guarantees that all messages received in
-	  the last two seconds will be stored. Since messages should be
-	  replied to within a second according to the CEC specification,
-	  this is more than enough.
+    * - __u32
+      - ``lost_msgs``
+      - Set to the number of lost messages since the filehandle was opened
+	or since the last time this event was dequeued for this
+	filehandle. The messages lost are the oldest messages. So when a
+	new message arrives and there is no more room, then the oldest
+	message is discarded to make room for the new one. The internal
+	size of the message queue guarantees that all messages received in
+	the last two seconds will be stored. Since messages should be
+	replied to within a second according to the CEC specification,
+	this is more than enough.
 
 
 .. tabularcolumns:: |p{1.0cm}|p{4.2cm}|p{2.5cm}|p{8.8cm}|
@@ -116,62 +101,32 @@ it is guaranteed that the state did change in between the two events.
     :stub-columns: 0
     :widths:       1 1 1 8
 
-
-    -  .. row 1
-
-       -  __u64
-
-       -  ``ts``
-
-       -  :cspan:`1` Timestamp of the event in ns.
-
-	  The timestamp has been taken from the ``CLOCK_MONOTONIC`` clock. To access
-	  the same clock from userspace use :c:func:`clock_gettime`.
-
-    -  .. row 2
-
-       -  __u32
-
-       -  ``event``
-
-       -  :cspan:`1` The CEC event type, see :ref:`cec-events`.
-
-    -  .. row 3
-
-       -  __u32
-
-       -  ``flags``
-
-       -  :cspan:`1` Event flags, see :ref:`cec-event-flags`.
-
-    -  .. row 4
-
-       -  union
-
-       -  (anonymous)
-
-       -
-       -
-
-    -  .. row 5
-
-       -
-       -  struct cec_event_state_change
-
-       -  ``state_change``
-
-       -  The new adapter state as sent by the :ref:`CEC_EVENT_STATE_CHANGE <CEC-EVENT-STATE-CHANGE>`
-	  event.
-
-    -  .. row 6
-
-       -
-       -  struct cec_event_lost_msgs
-
-       -  ``lost_msgs``
-
-       -  The number of lost messages as sent by the :ref:`CEC_EVENT_LOST_MSGS <CEC-EVENT-LOST-MSGS>`
-	  event.
+    * - __u64
+      - ``ts``
+      - :cspan:`1` Timestamp of the event in ns.
+
+	The timestamp has been taken from the ``CLOCK_MONOTONIC`` clock. To access
+	the same clock from userspace use :c:func:`clock_gettime`.
+    * - __u32
+      - ``event``
+      - :cspan:`1` The CEC event type, see :ref:`cec-events`.
+    * - __u32
+      - ``flags``
+      - :cspan:`1` Event flags, see :ref:`cec-event-flags`.
+    * - union
+      - (anonymous)
+      -
+      -
+    * -
+      - struct cec_event_state_change
+      - ``state_change``
+      - The new adapter state as sent by the :ref:`CEC_EVENT_STATE_CHANGE <CEC-EVENT-STATE-CHANGE>`
+	event.
+    * -
+      - struct cec_event_lost_msgs
+      - ``lost_msgs``
+      - The number of lost messages as sent by the :ref:`CEC_EVENT_LOST_MSGS <CEC-EVENT-LOST-MSGS>`
+	event.
 
 
 .. tabularcolumns:: |p{5.6cm}|p{0.9cm}|p{11.0cm}|
@@ -183,25 +138,19 @@ it is guaranteed that the state did change in between the two events.
     :stub-columns: 0
     :widths:       3 1 16
 
+    * .. _`CEC-EVENT-STATE-CHANGE`:
 
-    -  .. _`CEC-EVENT-STATE-CHANGE`:
-
-       -  ``CEC_EVENT_STATE_CHANGE``
-
-       -  1
-
-       -  Generated when the CEC Adapter's state changes. When open() is
-	  called an initial event will be generated for that filehandle with
-	  the CEC Adapter's state at that time.
-
-    -  .. _`CEC-EVENT-LOST-MSGS`:
+      - ``CEC_EVENT_STATE_CHANGE``
+      - 1
+      - Generated when the CEC Adapter's state changes. When open() is
+	called an initial event will be generated for that filehandle with
+	the CEC Adapter's state at that time.
+    * .. _`CEC-EVENT-LOST-MSGS`:
 
-       -  ``CEC_EVENT_LOST_MSGS``
-
-       -  2
-
-       -  Generated if one or more CEC messages were lost because the
-	  application didn't dequeue CEC messages fast enough.
+      - ``CEC_EVENT_LOST_MSGS``
+      - 2
+      - Generated if one or more CEC messages were lost because the
+	application didn't dequeue CEC messages fast enough.
 
 
 .. tabularcolumns:: |p{6.0cm}|p{0.6cm}|p{10.9cm}|
@@ -213,17 +162,14 @@ it is guaranteed that the state did change in between the two events.
     :stub-columns: 0
     :widths:       3 1 8
 
+    * .. _`CEC-EVENT-FL-INITIAL-VALUE`:
 
-    -  .. _`CEC-EVENT-FL-INITIAL-VALUE`:
-
-       -  ``CEC_EVENT_FL_INITIAL_VALUE``
-
-       -  1
-
-       -  Set for the initial events that are generated when the device is
-	  opened. See the table above for which events do this. This allows
-	  applications to learn the initial state of the CEC adapter at
-	  open() time.
+      - ``CEC_EVENT_FL_INITIAL_VALUE``
+      - 1
+      - Set for the initial events that are generated when the device is
+	opened. See the table above for which events do this. This allows
+	applications to learn the initial state of the CEC adapter at
+	open() time.
 
 
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index 70a4190..4f5818b 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -83,37 +83,28 @@ Available initiator modes are:
     :stub-columns: 0
     :widths:       3 1 16
 
-
-    -  .. _`CEC-MODE-NO-INITIATOR`:
-
-       -  ``CEC_MODE_NO_INITIATOR``
-
-       -  0x0
-
-       -  This is not an initiator, i.e. it cannot transmit CEC messages or
-	  make any other changes to the CEC adapter.
-
-    -  .. _`CEC-MODE-INITIATOR`:
-
-       -  ``CEC_MODE_INITIATOR``
-
-       -  0x1
-
-       -  This is an initiator (the default when the device is opened) and
-	  it can transmit CEC messages and make changes to the CEC adapter,
-	  unless there is an exclusive initiator.
-
-    -  .. _`CEC-MODE-EXCL-INITIATOR`:
-
-       -  ``CEC_MODE_EXCL_INITIATOR``
-
-       -  0x2
-
-       -  This is an exclusive initiator and this file descriptor is the
-	  only one that can transmit CEC messages and make changes to the
-	  CEC adapter. If someone else is already the exclusive initiator
-	  then an attempt to become one will return the ``EBUSY`` error code
-	  error.
+    * .. _`CEC-MODE-NO-INITIATOR`:
+
+      - ``CEC_MODE_NO_INITIATOR``
+      - 0x0
+      - This is not an initiator, i.e. it cannot transmit CEC messages or
+	make any other changes to the CEC adapter.
+    * .. _`CEC-MODE-INITIATOR`:
+
+      - ``CEC_MODE_INITIATOR``
+      - 0x1
+      - This is an initiator (the default when the device is opened) and
+	it can transmit CEC messages and make changes to the CEC adapter,
+	unless there is an exclusive initiator.
+    * .. _`CEC-MODE-EXCL-INITIATOR`:
+
+      - ``CEC_MODE_EXCL_INITIATOR``
+      - 0x2
+      - This is an exclusive initiator and this file descriptor is the
+	only one that can transmit CEC messages and make changes to the
+	CEC adapter. If someone else is already the exclusive initiator
+	then an attempt to become one will return the ``EBUSY`` error code
+	error.
 
 
 Available follower modes are:
@@ -127,86 +118,68 @@ Available follower modes are:
     :stub-columns: 0
     :widths:       3 1 16
 
-
-    -  .. _`CEC-MODE-NO-FOLLOWER`:
-
-       -  ``CEC_MODE_NO_FOLLOWER``
-
-       -  0x00
-
-       -  This is not a follower (the default when the device is opened).
-
-    -  .. _`CEC-MODE-FOLLOWER`:
-
-       -  ``CEC_MODE_FOLLOWER``
-
-       -  0x10
-
-       -  This is a follower and it will receive CEC messages unless there
-	  is an exclusive follower. You cannot become a follower if
-	  :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>` is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`
-	  was specified, the ``EINVAL`` error code is returned in that case.
-
-    -  .. _`CEC-MODE-EXCL-FOLLOWER`:
-
-       -  ``CEC_MODE_EXCL_FOLLOWER``
-
-       -  0x20
-
-       -  This is an exclusive follower and only this file descriptor will
-	  receive CEC messages for processing. If someone else is already
-	  the exclusive follower then an attempt to become one will return
-	  the ``EBUSY`` error code. You cannot become a follower if
-	  :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>` is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`
-	  was specified, the ``EINVAL`` error code is returned in that case.
-
-    -  .. _`CEC-MODE-EXCL-FOLLOWER-PASSTHRU`:
-
-       -  ``CEC_MODE_EXCL_FOLLOWER_PASSTHRU``
-
-       -  0x30
-
-       -  This is an exclusive follower and only this file descriptor will
-	  receive CEC messages for processing. In addition it will put the
-	  CEC device into passthrough mode, allowing the exclusive follower
-	  to handle most core messages instead of relying on the CEC
-	  framework for that. If someone else is already the exclusive
-	  follower then an attempt to become one will return the ``EBUSY`` error
-	  code. You cannot become a follower if :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>`
-	  is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>` was specified,
-	  the ``EINVAL`` error code is returned in that case.
-
-    -  .. _`CEC-MODE-MONITOR`:
-
-       -  ``CEC_MODE_MONITOR``
-
-       -  0xe0
-
-       -  Put the file descriptor into monitor mode. Can only be used in
-	  combination with :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`, otherwise EINVAL error
-	  code will be returned. In monitor mode all messages this CEC
-	  device transmits and all messages it receives (both broadcast
-	  messages and directed messages for one its logical addresses) will
-	  be reported. This is very useful for debugging. This is only
-	  allowed if the process has the ``CAP_NET_ADMIN`` capability. If
-	  that is not set, then the ``EPERM`` error code is returned.
-
-    -  .. _`CEC-MODE-MONITOR-ALL`:
-
-       -  ``CEC_MODE_MONITOR_ALL``
-
-       -  0xf0
-
-       -  Put the file descriptor into 'monitor all' mode. Can only be used
-	  in combination with :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`, otherwise
-	  the ``EINVAL`` error code will be returned. In 'monitor all' mode all messages
-	  this CEC device transmits and all messages it receives, including
-	  directed messages for other CEC devices will be reported. This is
-	  very useful for debugging, but not all devices support this. This
-	  mode requires that the :ref:`CEC_CAP_MONITOR_ALL <CEC-CAP-MONITOR-ALL>` capability is set,
-	  otherwise the ``EINVAL`` error code is returned. This is only allowed if
-	  the process has the ``CAP_NET_ADMIN`` capability. If that is not
-	  set, then the ``EPERM`` error code is returned.
+    * .. _`CEC-MODE-NO-FOLLOWER`:
+
+      - ``CEC_MODE_NO_FOLLOWER``
+      - 0x00
+      - This is not a follower (the default when the device is opened).
+    * .. _`CEC-MODE-FOLLOWER`:
+
+      - ``CEC_MODE_FOLLOWER``
+      - 0x10
+      - This is a follower and it will receive CEC messages unless there
+	is an exclusive follower. You cannot become a follower if
+	:ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>` is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`
+	was specified, the ``EINVAL`` error code is returned in that case.
+    * .. _`CEC-MODE-EXCL-FOLLOWER`:
+
+      - ``CEC_MODE_EXCL_FOLLOWER``
+      - 0x20
+      - This is an exclusive follower and only this file descriptor will
+	receive CEC messages for processing. If someone else is already
+	the exclusive follower then an attempt to become one will return
+	the ``EBUSY`` error code. You cannot become a follower if
+	:ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>` is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`
+	was specified, the ``EINVAL`` error code is returned in that case.
+    * .. _`CEC-MODE-EXCL-FOLLOWER-PASSTHRU`:
+
+      - ``CEC_MODE_EXCL_FOLLOWER_PASSTHRU``
+      - 0x30
+      - This is an exclusive follower and only this file descriptor will
+	receive CEC messages for processing. In addition it will put the
+	CEC device into passthrough mode, allowing the exclusive follower
+	to handle most core messages instead of relying on the CEC
+	framework for that. If someone else is already the exclusive
+	follower then an attempt to become one will return the ``EBUSY`` error
+	code. You cannot become a follower if :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>`
+	is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>` was specified,
+	the ``EINVAL`` error code is returned in that case.
+    * .. _`CEC-MODE-MONITOR`:
+
+      - ``CEC_MODE_MONITOR``
+      - 0xe0
+      - Put the file descriptor into monitor mode. Can only be used in
+	combination with :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`, otherwise EINVAL error
+	code will be returned. In monitor mode all messages this CEC
+	device transmits and all messages it receives (both broadcast
+	messages and directed messages for one its logical addresses) will
+	be reported. This is very useful for debugging. This is only
+	allowed if the process has the ``CAP_NET_ADMIN`` capability. If
+	that is not set, then the ``EPERM`` error code is returned.
+    * .. _`CEC-MODE-MONITOR-ALL`:
+
+      - ``CEC_MODE_MONITOR_ALL``
+      - 0xf0
+      - Put the file descriptor into 'monitor all' mode. Can only be used
+	in combination with :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`, otherwise
+	the ``EINVAL`` error code will be returned. In 'monitor all' mode all messages
+	this CEC device transmits and all messages it receives, including
+	directed messages for other CEC devices will be reported. This is
+	very useful for debugging, but not all devices support this. This
+	mode requires that the :ref:`CEC_CAP_MONITOR_ALL <CEC-CAP-MONITOR-ALL>` capability is set,
+	otherwise the ``EINVAL`` error code is returned. This is only allowed if
+	the process has the ``CAP_NET_ADMIN`` capability. If that is not
+	set, then the ``EPERM`` error code is returned.
 
 
 Core message processing details:
@@ -220,76 +193,58 @@ Core message processing details:
     :stub-columns: 0
     :widths: 1 8
 
-
-    -  .. _`CEC-MSG-GET-CEC-VERSION`:
-
-       -  ``CEC_MSG_GET_CEC_VERSION``
-
-       -  When in passthrough mode this message has to be handled by
-	  userspace, otherwise the core will return the CEC version that was
-	  set with :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`.
-
-    -  .. _`CEC-MSG-GIVE-DEVICE-VENDOR-ID`:
-
-       -  ``CEC_MSG_GIVE_DEVICE_VENDOR_ID``
-
-       -  When in passthrough mode this message has to be handled by
-	  userspace, otherwise the core will return the vendor ID that was
-	  set with :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`.
-
-    -  .. _`CEC-MSG-ABORT`:
-
-       -  ``CEC_MSG_ABORT``
-
-       -  When in passthrough mode this message has to be handled by
-	  userspace, otherwise the core will return a feature refused
-	  message as per the specification.
-
-    -  .. _`CEC-MSG-GIVE-PHYSICAL-ADDR`:
-
-       -  ``CEC_MSG_GIVE_PHYSICAL_ADDR``
-
-       -  When in passthrough mode this message has to be handled by
-	  userspace, otherwise the core will report the current physical
-	  address.
-
-    -  .. _`CEC-MSG-GIVE-OSD-NAME`:
-
-       -  ``CEC_MSG_GIVE_OSD_NAME``
-
-       -  When in passthrough mode this message has to be handled by
-	  userspace, otherwise the core will report the current OSD name as
-	  was set with :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`.
-
-    -  .. _`CEC-MSG-GIVE-FEATURES`:
-
-       -  ``CEC_MSG_GIVE_FEATURES``
-
-       -  When in passthrough mode this message has to be handled by
-	  userspace, otherwise the core will report the current features as
-	  was set with :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
-	  or the message is ignored if the CEC version was older than 2.0.
-
-    -  .. _`CEC-MSG-USER-CONTROL-PRESSED`:
-
-       -  ``CEC_MSG_USER_CONTROL_PRESSED``
-
-       -  If :ref:`CEC_CAP_RC <CEC-CAP-RC>` is set, then generate a remote control key
-	  press. This message is always passed on to userspace.
-
-    -  .. _`CEC-MSG-USER-CONTROL-RELEASED`:
-
-       -  ``CEC_MSG_USER_CONTROL_RELEASED``
-
-       -  If :ref:`CEC_CAP_RC <CEC-CAP-RC>` is set, then generate a remote control key
-	  release. This message is always passed on to userspace.
-
-    -  .. _`CEC-MSG-REPORT-PHYSICAL-ADDR`:
-
-       -  ``CEC_MSG_REPORT_PHYSICAL_ADDR``
-
-       -  The CEC framework will make note of the reported physical address
-	  and then just pass the message on to userspace.
+    * .. _`CEC-MSG-GET-CEC-VERSION`:
+
+      - ``CEC_MSG_GET_CEC_VERSION``
+      - When in passthrough mode this message has to be handled by
+	userspace, otherwise the core will return the CEC version that was
+	set with :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`.
+    * .. _`CEC-MSG-GIVE-DEVICE-VENDOR-ID`:
+
+      - ``CEC_MSG_GIVE_DEVICE_VENDOR_ID``
+      - When in passthrough mode this message has to be handled by
+	userspace, otherwise the core will return the vendor ID that was
+	set with :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`.
+    * .. _`CEC-MSG-ABORT`:
+
+      - ``CEC_MSG_ABORT``
+      - When in passthrough mode this message has to be handled by
+	userspace, otherwise the core will return a feature refused
+	message as per the specification.
+    * .. _`CEC-MSG-GIVE-PHYSICAL-ADDR`:
+
+      - ``CEC_MSG_GIVE_PHYSICAL_ADDR``
+      - When in passthrough mode this message has to be handled by
+	userspace, otherwise the core will report the current physical
+	address.
+    * .. _`CEC-MSG-GIVE-OSD-NAME`:
+
+      - ``CEC_MSG_GIVE_OSD_NAME``
+      - When in passthrough mode this message has to be handled by
+	userspace, otherwise the core will report the current OSD name as
+	was set with :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`.
+    * .. _`CEC-MSG-GIVE-FEATURES`:
+
+      - ``CEC_MSG_GIVE_FEATURES``
+      - When in passthrough mode this message has to be handled by
+	userspace, otherwise the core will report the current features as
+	was set with :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
+	or the message is ignored if the CEC version was older than 2.0.
+    * .. _`CEC-MSG-USER-CONTROL-PRESSED`:
+
+      - ``CEC_MSG_USER_CONTROL_PRESSED``
+      - If :ref:`CEC_CAP_RC <CEC-CAP-RC>` is set, then generate a remote control key
+	press. This message is always passed on to userspace.
+    * .. _`CEC-MSG-USER-CONTROL-RELEASED`:
+
+      - ``CEC_MSG_USER_CONTROL_RELEASED``
+      - If :ref:`CEC_CAP_RC <CEC-CAP-RC>` is set, then generate a remote control key
+	release. This message is always passed on to userspace.
+    * .. _`CEC-MSG-REPORT-PHYSICAL-ADDR`:
+
+      - ``CEC_MSG_REPORT_PHYSICAL_ADDR``
+      - The CEC framework will make note of the reported physical address
+	and then just pass the message on to userspace.
 
 
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index d585b1b..21a88df 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -86,173 +86,98 @@ result.
     :stub-columns: 0
     :widths:       1 1 16
 
-
-    -  .. row 1
-
-       -  __u64
-
-       -  ``tx_ts``
-
-       -  Timestamp in ns of when the last byte of the message was transmitted.
-	  The timestamp has been taken from the ``CLOCK_MONOTONIC`` clock. To access
-	  the same clock from userspace use :c:func:`clock_gettime`.
-
-    -  .. row 2
-
-       -  __u64
-
-       -  ``rx_ts``
-
-       -  Timestamp in ns of when the last byte of the message was received.
-	  The timestamp has been taken from the ``CLOCK_MONOTONIC`` clock. To access
-	  the same clock from userspace use :c:func:`clock_gettime`.
-
-    -  .. row 3
-
-       -  __u32
-
-       -  ``len``
-
-       -  The length of the message. For :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` this is filled in
-	  by the application. The driver will fill this in for
-	  :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`. For :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` it will be
-	  filled in by the driver with the length of the reply message if ``reply`` was set.
-
-    -  .. row 4
-
-       -  __u32
-
-       -  ``timeout``
-
-       -  The timeout in milliseconds. This is the time the device will wait
-	  for a message to be received before timing out. If it is set to 0,
-	  then it will wait indefinitely when it is called by :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`.
-	  If it is 0 and it is called by :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>`,
-	  then it will be replaced by 1000 if the ``reply`` is non-zero or
-	  ignored if ``reply`` is 0.
-
-    -  .. row 5
-
-       -  __u32
-
-       -  ``sequence``
-
-       -  A non-zero sequence number is automatically assigned by the CEC framework
-	  for all transmitted messages. It is used by the CEC framework when it queues
-	  the transmit result (when transmit was called in non-blocking mode). This
-	  allows the application to associate the received message with the original
-	  transmit.
-
-    -  .. row 6
-
-       -  __u32
-
-       -  ``flags``
-
-       -  Flags. No flags are defined yet, so set this to 0.
-
-    -  .. row 7
-
-       -  __u8
-
-       -  ``tx_status``
-
-       -  The status bits of the transmitted message. See
-	  :ref:`cec-tx-status` for the possible status values. It is 0 if
-	  this messages was received, not transmitted.
-
-    -  .. row 8
-
-       -  __u8
-
-       -  ``msg[16]``
-
-       -  The message payload. For :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` this is filled in by the
-	  application. The driver will fill this in for :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`.
-	  For :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` it will be filled in by the driver with
-	  the payload of the reply message if ``timeout`` was set.
-
-    -  .. row 8
-
-       -  __u8
-
-       -  ``reply``
-
-       -  Wait until this message is replied. If ``reply`` is 0 and the
-	  ``timeout`` is 0, then don't wait for a reply but return after
-	  transmitting the message. Ignored by :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`.
-	  The case where ``reply`` is 0 (this is the opcode for the Feature Abort
-	  message) and ``timeout`` is non-zero is specifically allowed to make it
-	  possible to send a message and wait up to ``timeout`` milliseconds for a
-	  Feature Abort reply. In this case ``rx_status`` will either be set
-	  to :ref:`CEC_RX_STATUS_TIMEOUT <CEC-RX-STATUS-TIMEOUT>` or
-	  :ref:`CEC_RX_STATUS_FEATURE_ABORT <CEC-RX-STATUS-FEATURE-ABORT>`.
-
-    -  .. row 9
-
-       -  __u8
-
-       -  ``rx_status``
-
-       -  The status bits of the received message. See
-	  :ref:`cec-rx-status` for the possible status values. It is 0 if
-	  this message was transmitted, not received, unless this is the
-	  reply to a transmitted message. In that case both ``rx_status``
-	  and ``tx_status`` are set.
-
-    -  .. row 10
-
-       -  __u8
-
-       -  ``tx_status``
-
-       -  The status bits of the transmitted message. See
-	  :ref:`cec-tx-status` for the possible status values. It is 0 if
-	  this messages was received, not transmitted.
-
-    -  .. row 11
-
-       -  __u8
-
-       -  ``tx_arb_lost_cnt``
-
-       -  A counter of the number of transmit attempts that resulted in the
-	  Arbitration Lost error. This is only set if the hardware supports
-	  this, otherwise it is always 0. This counter is only valid if the
-	  :ref:`CEC_TX_STATUS_ARB_LOST <CEC-TX-STATUS-ARB-LOST>` status bit is set.
-
-    -  .. row 12
-
-       -  __u8
-
-       -  ``tx_nack_cnt``
-
-       -  A counter of the number of transmit attempts that resulted in the
-	  Not Acknowledged error. This is only set if the hardware supports
-	  this, otherwise it is always 0. This counter is only valid if the
-	  :ref:`CEC_TX_STATUS_NACK <CEC-TX-STATUS-NACK>` status bit is set.
-
-    -  .. row 13
-
-       -  __u8
-
-       -  ``tx_low_drive_cnt``
-
-       -  A counter of the number of transmit attempts that resulted in the
-	  Arbitration Lost error. This is only set if the hardware supports
-	  this, otherwise it is always 0. This counter is only valid if the
-	  :ref:`CEC_TX_STATUS_LOW_DRIVE <CEC-TX-STATUS-LOW-DRIVE>` status bit is set.
-
-    -  .. row 14
-
-       -  __u8
-
-       -  ``tx_error_cnt``
-
-       -  A counter of the number of transmit errors other than Arbitration
-	  Lost or Not Acknowledged. This is only set if the hardware
-	  supports this, otherwise it is always 0. This counter is only
-	  valid if the :ref:`CEC_TX_STATUS_ERROR <CEC-TX-STATUS-ERROR>` status bit is set.
+    * - __u64
+      - ``tx_ts``
+      - Timestamp in ns of when the last byte of the message was transmitted.
+	The timestamp has been taken from the ``CLOCK_MONOTONIC`` clock. To access
+	the same clock from userspace use :c:func:`clock_gettime`.
+    * - __u64
+      - ``rx_ts``
+      - Timestamp in ns of when the last byte of the message was received.
+	The timestamp has been taken from the ``CLOCK_MONOTONIC`` clock. To access
+	the same clock from userspace use :c:func:`clock_gettime`.
+    * - __u32
+      - ``len``
+      - The length of the message. For :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` this is filled in
+	by the application. The driver will fill this in for
+	:ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`. For :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` it will be
+	filled in by the driver with the length of the reply message if ``reply`` was set.
+    * - __u32
+      - ``timeout``
+      - The timeout in milliseconds. This is the time the device will wait
+	for a message to be received before timing out. If it is set to 0,
+	then it will wait indefinitely when it is called by :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`.
+	If it is 0 and it is called by :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>`,
+	then it will be replaced by 1000 if the ``reply`` is non-zero or
+	ignored if ``reply`` is 0.
+    * - __u32
+      - ``sequence``
+      - A non-zero sequence number is automatically assigned by the CEC framework
+	for all transmitted messages. It is used by the CEC framework when it queues
+	the transmit result (when transmit was called in non-blocking mode). This
+	allows the application to associate the received message with the original
+	transmit.
+    * - __u32
+      - ``flags``
+      - Flags. No flags are defined yet, so set this to 0.
+    * - __u8
+      - ``tx_status``
+      - The status bits of the transmitted message. See
+	:ref:`cec-tx-status` for the possible status values. It is 0 if
+	this messages was received, not transmitted.
+    * - __u8
+      - ``msg[16]``
+      - The message payload. For :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` this is filled in by the
+	application. The driver will fill this in for :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`.
+	For :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` it will be filled in by the driver with
+	the payload of the reply message if ``timeout`` was set.
+    * - __u8
+      - ``reply``
+      - Wait until this message is replied. If ``reply`` is 0 and the
+	``timeout`` is 0, then don't wait for a reply but return after
+	transmitting the message. Ignored by :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`.
+	The case where ``reply`` is 0 (this is the opcode for the Feature Abort
+	message) and ``timeout`` is non-zero is specifically allowed to make it
+	possible to send a message and wait up to ``timeout`` milliseconds for a
+	Feature Abort reply. In this case ``rx_status`` will either be set
+	to :ref:`CEC_RX_STATUS_TIMEOUT <CEC-RX-STATUS-TIMEOUT>` or
+	:ref:`CEC_RX_STATUS_FEATURE_ABORT <CEC-RX-STATUS-FEATURE-ABORT>`.
+    * - __u8
+      - ``rx_status``
+      - The status bits of the received message. See
+	:ref:`cec-rx-status` for the possible status values. It is 0 if
+	this message was transmitted, not received, unless this is the
+	reply to a transmitted message. In that case both ``rx_status``
+	and ``tx_status`` are set.
+    * - __u8
+      - ``tx_status``
+      - The status bits of the transmitted message. See
+	:ref:`cec-tx-status` for the possible status values. It is 0 if
+	this messages was received, not transmitted.
+    * - __u8
+      - ``tx_arb_lost_cnt``
+      - A counter of the number of transmit attempts that resulted in the
+	Arbitration Lost error. This is only set if the hardware supports
+	this, otherwise it is always 0. This counter is only valid if the
+	:ref:`CEC_TX_STATUS_ARB_LOST <CEC-TX-STATUS-ARB-LOST>` status bit is set.
+    * - __u8
+      - ``tx_nack_cnt``
+      - A counter of the number of transmit attempts that resulted in the
+	Not Acknowledged error. This is only set if the hardware supports
+	this, otherwise it is always 0. This counter is only valid if the
+	:ref:`CEC_TX_STATUS_NACK <CEC-TX-STATUS-NACK>` status bit is set.
+    * - __u8
+      - ``tx_low_drive_cnt``
+      - A counter of the number of transmit attempts that resulted in the
+	Arbitration Lost error. This is only set if the hardware supports
+	this, otherwise it is always 0. This counter is only valid if the
+	:ref:`CEC_TX_STATUS_LOW_DRIVE <CEC-TX-STATUS-LOW-DRIVE>` status bit is set.
+    * - __u8
+      - ``tx_error_cnt``
+      - A counter of the number of transmit errors other than Arbitration
+	Lost or Not Acknowledged. This is only set if the hardware
+	supports this, otherwise it is always 0. This counter is only
+	valid if the :ref:`CEC_TX_STATUS_ERROR <CEC-TX-STATUS-ERROR>` status bit is set.
 
 
 .. tabularcolumns:: |p{5.6cm}|p{0.9cm}|p{11.0cm}|
@@ -264,64 +189,46 @@ result.
     :stub-columns: 0
     :widths:       3 1 16
 
-
-    -  .. _`CEC-TX-STATUS-OK`:
-
-       -  ``CEC_TX_STATUS_OK``
-
-       -  0x01
-
-       -  The message was transmitted successfully. This is mutually
-	  exclusive with :ref:`CEC_TX_STATUS_MAX_RETRIES <CEC-TX-STATUS-MAX-RETRIES>`. Other bits can still
-	  be set if earlier attempts met with failure before the transmit
-	  was eventually successful.
-
-    -  .. _`CEC-TX-STATUS-ARB-LOST`:
-
-       -  ``CEC_TX_STATUS_ARB_LOST``
-
-       -  0x02
-
-       -  CEC line arbitration was lost.
-
-    -  .. _`CEC-TX-STATUS-NACK`:
-
-       -  ``CEC_TX_STATUS_NACK``
-
-       -  0x04
-
-       -  Message was not acknowledged.
-
-    -  .. _`CEC-TX-STATUS-LOW-DRIVE`:
-
-       -  ``CEC_TX_STATUS_LOW_DRIVE``
-
-       -  0x08
-
-       -  Low drive was detected on the CEC bus. This indicates that a
-	  follower detected an error on the bus and requests a
-	  retransmission.
-
-    -  .. _`CEC-TX-STATUS-ERROR`:
-
-       -  ``CEC_TX_STATUS_ERROR``
-
-       -  0x10
-
-       -  Some error occurred. This is used for any errors that do not fit
-	  the previous two, either because the hardware could not tell which
-	  error occurred, or because the hardware tested for other
-	  conditions besides those two.
-
-    -  .. _`CEC-TX-STATUS-MAX-RETRIES`:
-
-       -  ``CEC_TX_STATUS_MAX_RETRIES``
-
-       -  0x20
-
-       -  The transmit failed after one or more retries. This status bit is
-	  mutually exclusive with :ref:`CEC_TX_STATUS_OK <CEC-TX-STATUS-OK>`. Other bits can still
-	  be set to explain which failures were seen.
+    * .. _`CEC-TX-STATUS-OK`:
+
+      - ``CEC_TX_STATUS_OK``
+      - 0x01
+      - The message was transmitted successfully. This is mutually
+	exclusive with :ref:`CEC_TX_STATUS_MAX_RETRIES <CEC-TX-STATUS-MAX-RETRIES>`. Other bits can still
+	be set if earlier attempts met with failure before the transmit
+	was eventually successful.
+    * .. _`CEC-TX-STATUS-ARB-LOST`:
+
+      - ``CEC_TX_STATUS_ARB_LOST``
+      - 0x02
+      - CEC line arbitration was lost.
+    * .. _`CEC-TX-STATUS-NACK`:
+
+      - ``CEC_TX_STATUS_NACK``
+      - 0x04
+      - Message was not acknowledged.
+    * .. _`CEC-TX-STATUS-LOW-DRIVE`:
+
+      - ``CEC_TX_STATUS_LOW_DRIVE``
+      - 0x08
+      - Low drive was detected on the CEC bus. This indicates that a
+	follower detected an error on the bus and requests a
+	retransmission.
+    * .. _`CEC-TX-STATUS-ERROR`:
+
+      - ``CEC_TX_STATUS_ERROR``
+      - 0x10
+      - Some error occurred. This is used for any errors that do not fit
+	the previous two, either because the hardware could not tell which
+	error occurred, or because the hardware tested for other
+	conditions besides those two.
+    * .. _`CEC-TX-STATUS-MAX-RETRIES`:
+
+      - ``CEC_TX_STATUS_MAX_RETRIES``
+      - 0x20
+      - The transmit failed after one or more retries. This status bit is
+	mutually exclusive with :ref:`CEC_TX_STATUS_OK <CEC-TX-STATUS-OK>`. Other bits can still
+	be set to explain which failures were seen.
 
 
 .. tabularcolumns:: |p{5.6cm}|p{0.9cm}|p{11.0cm}|
@@ -333,32 +240,23 @@ result.
     :stub-columns: 0
     :widths:       3 1 16
 
+    * .. _`CEC-RX-STATUS-OK`:
 
-    -  .. _`CEC-RX-STATUS-OK`:
-
-       -  ``CEC_RX_STATUS_OK``
-
-       -  0x01
-
-       -  The message was received successfully.
-
-    -  .. _`CEC-RX-STATUS-TIMEOUT`:
-
-       -  ``CEC_RX_STATUS_TIMEOUT``
-
-       -  0x02
-
-       -  The reply to an earlier transmitted message timed out.
-
-    -  .. _`CEC-RX-STATUS-FEATURE-ABORT`:
-
-       -  ``CEC_RX_STATUS_FEATURE_ABORT``
+      - ``CEC_RX_STATUS_OK``
+      - 0x01
+      - The message was received successfully.
+    * .. _`CEC-RX-STATUS-TIMEOUT`:
 
-       -  0x04
+      - ``CEC_RX_STATUS_TIMEOUT``
+      - 0x02
+      - The reply to an earlier transmitted message timed out.
+    * .. _`CEC-RX-STATUS-FEATURE-ABORT`:
 
-       -  The message was received successfully but the reply was
-	  ``CEC_MSG_FEATURE_ABORT``. This status is only set if this message
-	  was the reply to an earlier transmitted message.
+      - ``CEC_RX_STATUS_FEATURE_ABORT``
+      - 0x04
+      - The message was received successfully but the reply was
+	``CEC_MSG_FEATURE_ABORT``. This status is only set if this message
+	was the reply to an earlier transmitted message.
 
 
 
-- 
2.10.1

