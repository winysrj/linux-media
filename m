Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41189 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245AbcGJPSc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 11:18:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 3/3] [media] doc-rst: improve display of notes and warnings
Date: Sun, 10 Jul 2016 12:18:17 -0300
Message-Id: <706f8a9975cb8889742d1f606ff466205ed29805.1468163257.git.mchehab@s-opensource.com>
In-Reply-To: <5632442d6cc87024c69467df5621db33a55a2091.1468163257.git.mchehab@s-opensource.com>
References: <5632442d6cc87024c69467df5621db33a55a2091.1468163257.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <5632442d6cc87024c69467df5621db33a55a2091.1468163257.git.mchehab@s-opensource.com>
References: <5632442d6cc87024c69467df5621db33a55a2091.1468163257.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several notes and warning mesages in the middle of
the media docbook. Use the ReST tags for that, as it makes
them visually better and hightlights them.

While here, modify a few ones to make them clearer.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/cec/cec-func-close.rst    |   4 +-
 Documentation/media/uapi/cec/cec-func-ioctl.rst    |   4 +-
 Documentation/media/uapi/cec/cec-func-open.rst     |   4 +-
 Documentation/media/uapi/cec/cec-func-poll.rst     |   4 +-
 Documentation/media/uapi/cec/cec-intro.rst         |   4 +-
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |  38 +++----
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    |  80 +++++++-------
 .../media/uapi/cec/cec-ioc-adap-g-phys-addr.rst    |   4 +-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |  36 +++---
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    | 122 ++++++++++-----------
 Documentation/media/uapi/cec/cec-ioc-receive.rst   | 114 +++++++++----------
 .../media/uapi/dvb/dvb-fe-read-status.rst          |  11 +-
 Documentation/media/uapi/dvb/dvbapi.rst            |   4 +-
 Documentation/media/uapi/dvb/dvbproperty.rst       |  26 ++---
 Documentation/media/uapi/dvb/examples.rst          |   8 +-
 .../uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst    |   5 +-
 Documentation/media/uapi/dvb/fe-get-info.rst       |   4 +-
 Documentation/media/uapi/dvb/fe-read-status.rst    |   6 +-
 Documentation/media/uapi/dvb/fe-set-tone.rst       |   8 +-
 Documentation/media/uapi/dvb/fe-set-voltage.rst    |  10 +-
 Documentation/media/uapi/dvb/frontend.rst          |   4 +-
 Documentation/media/uapi/gen-errors.rst            |  12 +-
 Documentation/media/uapi/rc/lirc_ioctl.rst         |  12 +-
 Documentation/media/uapi/v4l/audio.rst             |  11 +-
 Documentation/media/uapi/v4l/buffer.rst            |  25 +++--
 Documentation/media/uapi/v4l/crop.rst              |  20 ++--
 Documentation/media/uapi/v4l/dev-capture.rst       |   4 +-
 Documentation/media/uapi/v4l/dev-codec.rst         |   6 +-
 Documentation/media/uapi/v4l/dev-effect.rst        |   9 +-
 Documentation/media/uapi/v4l/dev-osd.rst           |   9 +-
 Documentation/media/uapi/v4l/dev-output.rst        |   4 +-
 Documentation/media/uapi/v4l/dev-overlay.rst       |  17 +--
 Documentation/media/uapi/v4l/dev-rds.rst           |   8 +-
 Documentation/media/uapi/v4l/dev-subdev.rst        |   6 +-
 Documentation/media/uapi/v4l/dmabuf.rst            |  17 +--
 Documentation/media/uapi/v4l/extended-controls.rst |  63 ++++++-----
 Documentation/media/uapi/v4l/func-mmap.rst         |  35 +++---
 Documentation/media/uapi/v4l/mmap.rst              |  14 ++-
 Documentation/media/uapi/v4l/pixfmt-006.rst        |   8 +-
 Documentation/media/uapi/v4l/pixfmt-007.rst        |  32 +++---
 Documentation/media/uapi/v4l/pixfmt-sbggr16.rst    |   7 +-
 Documentation/media/uapi/v4l/pixfmt-y16-be.rst     |   7 +-
 Documentation/media/uapi/v4l/pixfmt-y16.rst        |   5 +-
 Documentation/media/uapi/v4l/standard.rst          |  11 +-
 Documentation/media/uapi/v4l/tuner.rst             |  15 +--
 Documentation/media/uapi/v4l/userp.rst             |  15 +--
 .../media/uapi/v4l/vidioc-dbg-g-chip-info.rst      |   2 +-
 .../media/uapi/v4l/vidioc-dbg-g-register.rst       |   2 +-
 .../media/uapi/v4l/vidioc-dv-timings-cap.rst       |   6 +-
 .../media/uapi/v4l/vidioc-enum-dv-timings.rst      |   6 +-
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |  10 +-
 .../media/uapi/v4l/vidioc-enum-frameintervals.rst  |  14 +--
 .../media/uapi/v4l/vidioc-enum-framesizes.rst      |   6 +-
 .../media/uapi/v4l/vidioc-enum-freq-bands.rst      |  14 ++-
 .../media/uapi/v4l/vidioc-enumaudioout.rst         |   4 +-
 Documentation/media/uapi/v4l/vidioc-enuminput.rst  |   4 +-
 Documentation/media/uapi/v4l/vidioc-g-audioout.rst |   4 +-
 Documentation/media/uapi/v4l/vidioc-g-edid.rst     |   6 +-
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |  16 ++-
 .../media/uapi/v4l/vidioc-g-modulator.rst          |  14 ++-
 .../media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst     |   4 +-
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst    |  22 ++--
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |  17 +--
 .../media/uapi/v4l/vidioc-query-dv-timings.rst     |  20 ++--
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  35 +++---
 Documentation/media/uapi/v4l/vidioc-querystd.rst   |  20 ++--
 Documentation/media/uapi/v4l/vidioc-streamon.rst   |   8 +-
 .../media/uapi/v4l/vidioc-subdev-g-crop.rst        |   2 +-
 .../media/uapi/v4l/vidioc-subscribe-event.rst      |   8 +-
 69 files changed, 591 insertions(+), 525 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-func-close.rst b/Documentation/media/uapi/cec/cec-func-close.rst
index ae55e55ab84a..bb94e4358910 100644
--- a/Documentation/media/uapi/cec/cec-func-close.rst
+++ b/Documentation/media/uapi/cec/cec-func-close.rst
@@ -32,8 +32,8 @@ Arguments
 Description
 ===========
 
-Note: this documents the proposed CEC API. This API is not yet finalized
-and is currently only available as a staging kernel module.
+.. note:: This documents the proposed CEC API. This API is not yet finalized
+   and is currently only available as a staging kernel module.
 
 Closes the cec device. Resources associated with the file descriptor are
 freed. The device configuration remain unchanged.
diff --git a/Documentation/media/uapi/cec/cec-func-ioctl.rst b/Documentation/media/uapi/cec/cec-func-ioctl.rst
index 69510ac5088a..a07cc7cf8afb 100644
--- a/Documentation/media/uapi/cec/cec-func-ioctl.rst
+++ b/Documentation/media/uapi/cec/cec-func-ioctl.rst
@@ -38,8 +38,8 @@ Arguments
 Description
 ===========
 
-Note: this documents the proposed CEC API. This API is not yet finalized
-and is currently only available as a staging kernel module.
+.. note:: This documents the proposed CEC API. This API is not yet finalized
+   and is currently only available as a staging kernel module.
 
 The :c:func:`ioctl()` function manipulates cec device parameters. The
 argument ``fd`` must be an open file descriptor.
diff --git a/Documentation/media/uapi/cec/cec-func-open.rst b/Documentation/media/uapi/cec/cec-func-open.rst
index 95db9d1dc6b5..245d6793dd35 100644
--- a/Documentation/media/uapi/cec/cec-func-open.rst
+++ b/Documentation/media/uapi/cec/cec-func-open.rst
@@ -45,8 +45,8 @@ Arguments
 Description
 ===========
 
-Note: this documents the proposed CEC API. This API is not yet finalized
-and is currently only available as a staging kernel module.
+.. note:: This documents the proposed CEC API. This API is not yet finalized
+   and is currently only available as a staging kernel module.
 
 To open a cec device applications call :c:func:`open()` with the
 desired device name. The function has no side effects; the device
diff --git a/Documentation/media/uapi/cec/cec-func-poll.rst b/Documentation/media/uapi/cec/cec-func-poll.rst
index eacc164558a5..fcab65f6d6b8 100644
--- a/Documentation/media/uapi/cec/cec-func-poll.rst
+++ b/Documentation/media/uapi/cec/cec-func-poll.rst
@@ -29,8 +29,8 @@ Arguments
 Description
 ===========
 
-Note: this documents the proposed CEC API. This API is not yet finalized
-and is currently only available as a staging kernel module.
+.. note:: This documents the proposed CEC API. This API is not yet finalized
+   and is currently only available as a staging kernel module.
 
 With the :c:func:`poll()` function applications can wait for CEC
 events.
diff --git a/Documentation/media/uapi/cec/cec-intro.rst b/Documentation/media/uapi/cec/cec-intro.rst
index d6a878866b3f..afa76f26fdde 100644
--- a/Documentation/media/uapi/cec/cec-intro.rst
+++ b/Documentation/media/uapi/cec/cec-intro.rst
@@ -3,8 +3,8 @@
 Introduction
 ============
 
-Note: this documents the proposed CEC API. This API is not yet finalized
-and is currently only available as a staging kernel module.
+.. note:: This documents the proposed CEC API. This API is not yet finalized
+   and is currently only available as a staging kernel module.
 
 HDMI connectors provide a single pin for use by the Consumer Electronics
 Control protocol. This protocol allows different devices connected by an
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index 6cf959ee6929..2ca9199c3305 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -31,8 +31,8 @@ Arguments
 Description
 ===========
 
-Note: this documents the proposed CEC API. This API is not yet finalized
-and is currently only available as a staging kernel module.
+.. note:: This documents the proposed CEC API. This API is not yet finalized
+   and is currently only available as a staging kernel module.
 
 All cec devices must support the :ref:`CEC_ADAP_G_CAPS` ioctl. To query
 device information, applications call the ioctl with a pointer to a
@@ -63,7 +63,7 @@ returns the information to the application. The ioctl never fails.
        -  ``name[32]``
 
        -  The name of this CEC adapter. The combination ``driver`` and
-          ``name`` must be unique.
+	  ``name`` must be unique.
 
     -  .. row 3
 
@@ -72,7 +72,7 @@ returns the information to the application. The ioctl never fails.
        -  ``capabilities``
 
        -  The capabilities of the CEC adapter, see
-          :ref:`cec-capabilities`.
+	  :ref:`cec-capabilities`.
 
     -  .. row 4
 
@@ -81,7 +81,7 @@ returns the information to the application. The ioctl never fails.
        -  ``version``
 
        -  CEC Framework API version, formatted with the ``KERNEL_VERSION()``
-          macro.
+	  macro.
 
 
 
@@ -100,10 +100,10 @@ returns the information to the application. The ioctl never fails.
        -  0x00000001
 
        -  Userspace has to configure the physical address by calling
-          :ref:`CEC_ADAP_S_PHYS_ADDR`. If
-          this capability isn't set, then setting the physical address is
-          handled by the kernel whenever the EDID is set (for an HDMI
-          receiver) or read (for an HDMI transmitter).
+	  :ref:`CEC_ADAP_S_PHYS_ADDR`. If
+	  this capability isn't set, then setting the physical address is
+	  handled by the kernel whenever the EDID is set (for an HDMI
+	  receiver) or read (for an HDMI transmitter).
 
     -  .. _`CEC-CAP-LOG-ADDRS`:
 
@@ -112,9 +112,9 @@ returns the information to the application. The ioctl never fails.
        -  0x00000002
 
        -  Userspace has to configure the logical addresses by calling
-          :ref:`CEC_ADAP_S_LOG_ADDRS`. If
-          this capability isn't set, then the kernel will have configured
-          this.
+	  :ref:`CEC_ADAP_S_LOG_ADDRS`. If
+	  this capability isn't set, then the kernel will have configured
+	  this.
 
     -  .. _`CEC-CAP-TRANSMIT`:
 
@@ -123,11 +123,11 @@ returns the information to the application. The ioctl never fails.
        -  0x00000004
 
        -  Userspace can transmit CEC messages by calling
-          :ref:`CEC_TRANSMIT`. This implies that
-          userspace can be a follower as well, since being able to transmit
-          messages is a prerequisite of becoming a follower. If this
-          capability isn't set, then the kernel will handle all CEC
-          transmits and process all CEC messages it receives.
+	  :ref:`CEC_TRANSMIT`. This implies that
+	  userspace can be a follower as well, since being able to transmit
+	  messages is a prerequisite of becoming a follower. If this
+	  capability isn't set, then the kernel will handle all CEC
+	  transmits and process all CEC messages it receives.
 
     -  .. _`CEC-CAP-PASSTHROUGH`:
 
@@ -136,7 +136,7 @@ returns the information to the application. The ioctl never fails.
        -  0x00000008
 
        -  Userspace can use the passthrough mode by calling
-          :ref:`CEC_S_MODE`.
+	  :ref:`CEC_S_MODE`.
 
     -  .. _`CEC-CAP-RC`:
 
@@ -153,7 +153,7 @@ returns the information to the application. The ioctl never fails.
        -  0x00000020
 
        -  The CEC hardware can monitor all messages, not just directed and
-          broadcast messages.
+	  broadcast messages.
 
 
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 322df752465f..7d7a3b43aedc 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -35,8 +35,8 @@ Arguments
 Description
 ===========
 
-Note: this documents the proposed CEC API. This API is not yet finalized
-and is currently only available as a staging kernel module.
+.. note:: This documents the proposed CEC API. This API is not yet finalized
+   and is currently only available as a staging kernel module.
 
 To query the current CEC logical addresses, applications call the
 :ref:`CEC_ADAP_G_LOG_ADDRS` ioctl with a pointer to a
@@ -68,10 +68,10 @@ by a file handle in initiator mode (see
        -  ``log_addr`` [CEC_MAX_LOG_ADDRS]
 
        -  The actual logical addresses that were claimed. This is set by the
-          driver. If no logical address could be claimed, then it is set to
-          ``CEC_LOG_ADDR_INVALID``. If this adapter is Unregistered, then
-          ``log_addr[0]`` is set to 0xf and all others to
-          ``CEC_LOG_ADDR_INVALID``.
+	  driver. If no logical address could be claimed, then it is set to
+	  ``CEC_LOG_ADDR_INVALID``. If this adapter is Unregistered, then
+	  ``log_addr[0]`` is set to 0xf and all others to
+	  ``CEC_LOG_ADDR_INVALID``.
 
     -  .. row 2
 
@@ -80,9 +80,9 @@ by a file handle in initiator mode (see
        -  ``log_addr_mask``
 
        -  The bitmask of all logical addresses this adapter has claimed. If
-          this adapter is Unregistered then ``log_addr_mask`` sets bit 15
-          and clears all other bits. If this adapter is not configured at
-          all, then ``log_addr_mask`` is set to 0. Set by the driver.
+	  this adapter is Unregistered then ``log_addr_mask`` sets bit 15
+	  and clears all other bits. If this adapter is not configured at
+	  all, then ``log_addr_mask`` is set to 0. Set by the driver.
 
     -  .. row 3
 
@@ -91,10 +91,10 @@ by a file handle in initiator mode (see
        -  ``cec_version``
 
        -  The CEC version that this adapter shall use. See
-          :ref:`cec-versions`. Used to implement the
-          ``CEC_MSG_CEC_VERSION`` and ``CEC_MSG_REPORT_FEATURES`` messages.
-          Note that :ref:`CEC_OP_CEC_VERSION_1_3A <CEC-OP-CEC-VERSION-1-3A>` is not allowed by the CEC
-          framework.
+	  :ref:`cec-versions`. Used to implement the
+	  ``CEC_MSG_CEC_VERSION`` and ``CEC_MSG_REPORT_FEATURES`` messages.
+	  Note that :ref:`CEC_OP_CEC_VERSION_1_3A <CEC-OP-CEC-VERSION-1-3A>` is not allowed by the CEC
+	  framework.
 
     -  .. row 4
 
@@ -103,17 +103,17 @@ by a file handle in initiator mode (see
        -  ``num_log_addrs``
 
        -  Number of logical addresses to set up. Must be ≤
-          ``available_log_addrs`` as returned by
-          :ref:`CEC_ADAP_G_CAPS`. All arrays in
-          this structure are only filled up to index
-          ``available_log_addrs``-1. The remaining array elements will be
-          ignored. Note that the CEC 2.0 standard allows for a maximum of 2
-          logical addresses, although some hardware has support for more.
-          ``CEC_MAX_LOG_ADDRS`` is 4. The driver will return the actual
-          number of logical addresses it could claim, which may be less than
-          what was requested. If this field is set to 0, then the CEC
-          adapter shall clear all claimed logical addresses and all other
-          fields will be ignored.
+	  ``available_log_addrs`` as returned by
+	  :ref:`CEC_ADAP_G_CAPS`. All arrays in
+	  this structure are only filled up to index
+	  ``available_log_addrs``-1. The remaining array elements will be
+	  ignored. Note that the CEC 2.0 standard allows for a maximum of 2
+	  logical addresses, although some hardware has support for more.
+	  ``CEC_MAX_LOG_ADDRS`` is 4. The driver will return the actual
+	  number of logical addresses it could claim, which may be less than
+	  what was requested. If this field is set to 0, then the CEC
+	  adapter shall clear all claimed logical addresses and all other
+	  fields will be ignored.
 
     -  .. row 5
 
@@ -122,9 +122,9 @@ by a file handle in initiator mode (see
        -  ``vendor_id``
 
        -  The vendor ID is a 24-bit number that identifies the specific
-          vendor or entity. Based on this ID vendor specific commands may be
-          defined. If you do not want a vendor ID then set it to
-          ``CEC_VENDOR_ID_NONE``.
+	  vendor or entity. Based on this ID vendor specific commands may be
+	  defined. If you do not want a vendor ID then set it to
+	  ``CEC_VENDOR_ID_NONE``.
 
     -  .. row 6
 
@@ -141,7 +141,7 @@ by a file handle in initiator mode (see
        -  ``osd_name``\ [15]
 
        -  The On-Screen Display name as is returned by the
-          ``CEC_MSG_SET_OSD_NAME`` message.
+	  ``CEC_MSG_SET_OSD_NAME`` message.
 
     -  .. row 8
 
@@ -150,7 +150,7 @@ by a file handle in initiator mode (see
        -  ``primary_device_type`` [CEC_MAX_LOG_ADDRS]
 
        -  Primary device type for each logical address. See
-          :ref:`cec-prim-dev-types` for possible types.
+	  :ref:`cec-prim-dev-types` for possible types.
 
     -  .. row 9
 
@@ -159,9 +159,9 @@ by a file handle in initiator mode (see
        -  ``log_addr_type`` [CEC_MAX_LOG_ADDRS]
 
        -  Logical address types. See :ref:`cec-log-addr-types` for
-          possible types. The driver will update this with the actual
-          logical address type that it claimed (e.g. it may have to fallback
-          to :ref:`CEC_LOG_ADDR_TYPE_UNREGISTERED <CEC-LOG-ADDR-TYPE-UNREGISTERED>`).
+	  possible types. The driver will update this with the actual
+	  logical address type that it claimed (e.g. it may have to fallback
+	  to :ref:`CEC_LOG_ADDR_TYPE_UNREGISTERED <CEC-LOG-ADDR-TYPE-UNREGISTERED>`).
 
     -  .. row 10
 
@@ -170,9 +170,9 @@ by a file handle in initiator mode (see
        -  ``all_device_types`` [CEC_MAX_LOG_ADDRS]
 
        -  CEC 2.0 specific: all device types. See
-          :ref:`cec-all-dev-types-flags`. Used to implement the
-          ``CEC_MSG_REPORT_FEATURES`` message. This field is ignored if
-          ``cec_version`` < :ref:`CEC_OP_CEC_VERSION_2_0 <CEC-OP-CEC-VERSION-2-0>`.
+	  :ref:`cec-all-dev-types-flags`. Used to implement the
+	  ``CEC_MSG_REPORT_FEATURES`` message. This field is ignored if
+	  ``cec_version`` < :ref:`CEC_OP_CEC_VERSION_2_0 <CEC-OP-CEC-VERSION-2-0>`.
 
     -  .. row 11
 
@@ -181,9 +181,9 @@ by a file handle in initiator mode (see
        -  ``features`` [CEC_MAX_LOG_ADDRS][12]
 
        -  Features for each logical address. Used to implement the
-          ``CEC_MSG_REPORT_FEATURES`` message. The 12 bytes include both the
-          RC Profile and the Device Features. This field is ignored if
-          ``cec_version`` < :ref:`CEC_OP_CEC_VERSION_2_0 <CEC-OP-CEC-VERSION-2-0>`.
+	  ``CEC_MSG_REPORT_FEATURES`` message. The 12 bytes include both the
+	  RC Profile and the Device Features. This field is ignored if
+	  ``cec_version`` < :ref:`CEC_OP_CEC_VERSION_2_0 <CEC-OP-CEC-VERSION-2-0>`.
 
 
 
@@ -350,8 +350,8 @@ by a file handle in initiator mode (see
        -  6
 
        -  Use this if you just want to remain unregistered. Used for pure
-          CEC switches or CDC-only devices (CDC: Capability Discovery and
-          Control).
+	  CEC switches or CDC-only devices (CDC: Capability Discovery and
+	  Control).
 
 
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
index 40e0baaa1630..58aaba6e21f8 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
@@ -34,8 +34,8 @@ Arguments
 Description
 ===========
 
-Note: this documents the proposed CEC API. This API is not yet finalized
-and is currently only available as a staging kernel module.
+.. note:: This documents the proposed CEC API. This API is not yet finalized
+   and is currently only available as a staging kernel module.
 
 To query the current physical address applications call the
 :ref:`CEC_ADAP_G_PHYS_ADDR` ioctl with a pointer to an __u16 where the
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index 204bc18d69a9..681201fc92d7 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -32,8 +32,8 @@ Arguments
 Description
 ===========
 
-Note: this documents the proposed CEC API. This API is not yet finalized
-and is currently only available as a staging kernel module.
+.. note:: This documents the proposed CEC API. This API is not yet finalized
+   and is currently only available as a staging kernel module.
 
 CEC devices can send asynchronous events. These can be retrieved by
 calling the :ref:`CEC_DQEVENT` ioctl. If the file descriptor is in
@@ -91,14 +91,14 @@ state did change in between the two events.
        -  ``lost_msgs``
 
        -  Set to the number of lost messages since the filehandle was opened
-          or since the last time this event was dequeued for this
-          filehandle. The messages lost are the oldest messages. So when a
-          new message arrives and there is no more room, then the oldest
-          message is discarded to make room for the new one. The internal
-          size of the message queue guarantees that all messages received in
-          the last two seconds will be stored. Since messages should be
-          replied to within a second according to the CEC specification,
-          this is more than enough.
+	  or since the last time this event was dequeued for this
+	  filehandle. The messages lost are the oldest messages. So when a
+	  new message arrives and there is no more room, then the oldest
+	  message is discarded to make room for the new one. The internal
+	  size of the message queue guarantees that all messages received in
+	  the last two seconds will be stored. Since messages should be
+	  replied to within a second according to the CEC specification,
+	  this is more than enough.
 
 
 
@@ -157,7 +157,7 @@ state did change in between the two events.
        -  ``state_change``
 
        -  The new adapter state as sent by the :ref:`CEC_EVENT_STATE_CHANGE <CEC-EVENT-STATE-CHANGE>`
-          event.
+	  event.
 
     -  .. row 6
 
@@ -167,7 +167,7 @@ state did change in between the two events.
        -  ``lost_msgs``
 
        -  The number of lost messages as sent by the :ref:`CEC_EVENT_LOST_MSGS <CEC-EVENT-LOST-MSGS>`
-          event.
+	  event.
 
 
 
@@ -186,8 +186,8 @@ state did change in between the two events.
        -  1
 
        -  Generated when the CEC Adapter's state changes. When open() is
-          called an initial event will be generated for that filehandle with
-          the CEC Adapter's state at that time.
+	  called an initial event will be generated for that filehandle with
+	  the CEC Adapter's state at that time.
 
     -  .. _`CEC-EVENT-LOST-MSGS`:
 
@@ -196,7 +196,7 @@ state did change in between the two events.
        -  2
 
        -  Generated if one or more CEC messages were lost because the
-          application didn't dequeue CEC messages fast enough.
+	  application didn't dequeue CEC messages fast enough.
 
 
 
@@ -215,9 +215,9 @@ state did change in between the two events.
        -  1
 
        -  Set for the initial events that are generated when the device is
-          opened. See the table above for which events do this. This allows
-          applications to learn the initial state of the CEC adapter at
-          open() time.
+	  opened. See the table above for which events do this. This allows
+	  applications to learn the initial state of the CEC adapter at
+	  open() time.
 
 
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index c11de2f4ddf0..c5a0fc41469e 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -30,8 +30,8 @@ Arguments
 Description
 ===========
 
-Note: this documents the proposed CEC API. This API is not yet finalized
-and is currently only available as a staging kernel module.
+.. note:: This documents the proposed CEC API. This API is not yet finalized
+   and is currently only available as a staging kernel module.
 
 By default any filehandle can use
 :ref:`CEC_TRANSMIT` and
@@ -89,7 +89,7 @@ Available initiator modes are:
        -  0x0
 
        -  This is not an initiator, i.e. it cannot transmit CEC messages or
-          make any other changes to the CEC adapter.
+	  make any other changes to the CEC adapter.
 
     -  .. _`CEC-MODE-INITIATOR`:
 
@@ -98,8 +98,8 @@ Available initiator modes are:
        -  0x1
 
        -  This is an initiator (the default when the device is opened) and
-          it can transmit CEC messages and make changes to the CEC adapter,
-          unless there is an exclusive initiator.
+	  it can transmit CEC messages and make changes to the CEC adapter,
+	  unless there is an exclusive initiator.
 
     -  .. _`CEC-MODE-EXCL-INITIATOR`:
 
@@ -108,10 +108,10 @@ Available initiator modes are:
        -  0x2
 
        -  This is an exclusive initiator and this file descriptor is the
-          only one that can transmit CEC messages and make changes to the
-          CEC adapter. If someone else is already the exclusive initiator
-          then an attempt to become one will return the EBUSY error code
-          error.
+	  only one that can transmit CEC messages and make changes to the
+	  CEC adapter. If someone else is already the exclusive initiator
+	  then an attempt to become one will return the EBUSY error code
+	  error.
 
 
 Available follower modes are:
@@ -140,9 +140,9 @@ Available follower modes are:
        -  0x10
 
        -  This is a follower and it will receive CEC messages unless there
-          is an exclusive follower. You cannot become a follower if
-          :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>` is not set or if :ref:`CEC-MODE-NO-INITIATOR <CEC-MODE-NO-INITIATOR>`
-          was specified, EINVAL error code is returned in that case.
+	  is an exclusive follower. You cannot become a follower if
+	  :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>` is not set or if :ref:`CEC-MODE-NO-INITIATOR <CEC-MODE-NO-INITIATOR>`
+	  was specified, EINVAL error code is returned in that case.
 
     -  .. _`CEC-MODE-EXCL-FOLLOWER`:
 
@@ -151,11 +151,11 @@ Available follower modes are:
        -  0x20
 
        -  This is an exclusive follower and only this file descriptor will
-          receive CEC messages for processing. If someone else is already
-          the exclusive follower then an attempt to become one will return
-          the EBUSY error code error. You cannot become a follower if
-          :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>` is not set or if :ref:`CEC-MODE-NO-INITIATOR <CEC-MODE-NO-INITIATOR>`
-          was specified, EINVAL error code is returned in that case.
+	  receive CEC messages for processing. If someone else is already
+	  the exclusive follower then an attempt to become one will return
+	  the EBUSY error code error. You cannot become a follower if
+	  :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>` is not set or if :ref:`CEC-MODE-NO-INITIATOR <CEC-MODE-NO-INITIATOR>`
+	  was specified, EINVAL error code is returned in that case.
 
     -  .. _`CEC-MODE-EXCL-FOLLOWER-PASSTHRU`:
 
@@ -164,14 +164,14 @@ Available follower modes are:
        -  0x30
 
        -  This is an exclusive follower and only this file descriptor will
-          receive CEC messages for processing. In addition it will put the
-          CEC device into passthrough mode, allowing the exclusive follower
-          to handle most core messages instead of relying on the CEC
-          framework for that. If someone else is already the exclusive
-          follower then an attempt to become one will return the EBUSY error
-          code error. You cannot become a follower if :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>`
-          is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>` was specified, EINVAL
-          error code is returned in that case.
+	  receive CEC messages for processing. In addition it will put the
+	  CEC device into passthrough mode, allowing the exclusive follower
+	  to handle most core messages instead of relying on the CEC
+	  framework for that. If someone else is already the exclusive
+	  follower then an attempt to become one will return the EBUSY error
+	  code error. You cannot become a follower if :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>`
+	  is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>` was specified, EINVAL
+	  error code is returned in that case.
 
     -  .. _`CEC-MODE-MONITOR`:
 
@@ -180,13 +180,13 @@ Available follower modes are:
        -  0xe0
 
        -  Put the file descriptor into monitor mode. Can only be used in
-          combination with :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`, otherwise EINVAL error
-          code will be returned. In monitor mode all messages this CEC
-          device transmits and all messages it receives (both broadcast
-          messages and directed messages for one its logical addresses) will
-          be reported. This is very useful for debugging. This is only
-          allowed if the process has the ``CAP_NET_ADMIN`` capability. If
-          that is not set, then EPERM error code is returned.
+	  combination with :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`, otherwise EINVAL error
+	  code will be returned. In monitor mode all messages this CEC
+	  device transmits and all messages it receives (both broadcast
+	  messages and directed messages for one its logical addresses) will
+	  be reported. This is very useful for debugging. This is only
+	  allowed if the process has the ``CAP_NET_ADMIN`` capability. If
+	  that is not set, then EPERM error code is returned.
 
     -  .. _`CEC-MODE-MONITOR-ALL`:
 
@@ -195,15 +195,15 @@ Available follower modes are:
        -  0xf0
 
        -  Put the file descriptor into 'monitor all' mode. Can only be used
-          in combination with :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`, otherwise EINVAL
-          error code will be returned. In 'monitor all' mode all messages
-          this CEC device transmits and all messages it receives, including
-          directed messages for other CEC devices will be reported. This is
-          very useful for debugging, but not all devices support this. This
-          mode requires that the :ref:`CEC_CAP_MONITOR_ALL <CEC-CAP-MONITOR-ALL>` capability is set,
-          otherwise EINVAL error code is returned. This is only allowed if
-          the process has the ``CAP_NET_ADMIN`` capability. If that is not
-          set, then EPERM error code is returned.
+	  in combination with :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`, otherwise EINVAL
+	  error code will be returned. In 'monitor all' mode all messages
+	  this CEC device transmits and all messages it receives, including
+	  directed messages for other CEC devices will be reported. This is
+	  very useful for debugging, but not all devices support this. This
+	  mode requires that the :ref:`CEC_CAP_MONITOR_ALL <CEC-CAP-MONITOR-ALL>` capability is set,
+	  otherwise EINVAL error code is returned. This is only allowed if
+	  the process has the ``CAP_NET_ADMIN`` capability. If that is not
+	  set, then EPERM error code is returned.
 
 
 Core message processing details:
@@ -222,74 +222,74 @@ Core message processing details:
        -  ``CEC_MSG_GET_CEC_VERSION``
 
        -  When in passthrough mode this message has to be handled by
-          userspace, otherwise the core will return the CEC version that was
-          set with
-          :ref:`CEC_ADAP_S_LOG_ADDRS`.
+	  userspace, otherwise the core will return the CEC version that was
+	  set with
+	  :ref:`CEC_ADAP_S_LOG_ADDRS`.
 
     -  .. _`CEC-MSG-GIVE-DEVICE-VENDOR-ID`:
 
        -  ``CEC_MSG_GIVE_DEVICE_VENDOR_ID``
 
        -  When in passthrough mode this message has to be handled by
-          userspace, otherwise the core will return the vendor ID that was
-          set with
-          :ref:`CEC_ADAP_S_LOG_ADDRS`.
+	  userspace, otherwise the core will return the vendor ID that was
+	  set with
+	  :ref:`CEC_ADAP_S_LOG_ADDRS`.
 
     -  .. _`CEC-MSG-ABORT`:
 
        -  ``CEC_MSG_ABORT``
 
        -  When in passthrough mode this message has to be handled by
-          userspace, otherwise the core will return a feature refused
-          message as per the specification.
+	  userspace, otherwise the core will return a feature refused
+	  message as per the specification.
 
     -  .. _`CEC-MSG-GIVE-PHYSICAL-ADDR`:
 
        -  ``CEC_MSG_GIVE_PHYSICAL_ADDR``
 
        -  When in passthrough mode this message has to be handled by
-          userspace, otherwise the core will report the current physical
-          address.
+	  userspace, otherwise the core will report the current physical
+	  address.
 
     -  .. _`CEC-MSG-GIVE-OSD-NAME`:
 
        -  ``CEC_MSG_GIVE_OSD_NAME``
 
        -  When in passthrough mode this message has to be handled by
-          userspace, otherwise the core will report the current OSD name as
-          was set with
-          :ref:`CEC_ADAP_S_LOG_ADDRS`.
+	  userspace, otherwise the core will report the current OSD name as
+	  was set with
+	  :ref:`CEC_ADAP_S_LOG_ADDRS`.
 
     -  .. _`CEC-MSG-GIVE-FEATURES`:
 
        -  ``CEC_MSG_GIVE_FEATURES``
 
        -  When in passthrough mode this message has to be handled by
-          userspace, otherwise the core will report the current features as
-          was set with
-          :ref:`CEC_ADAP_S_LOG_ADDRS` or
-          the message is ignore if the CEC version was older than 2.0.
+	  userspace, otherwise the core will report the current features as
+	  was set with
+	  :ref:`CEC_ADAP_S_LOG_ADDRS` or
+	  the message is ignore if the CEC version was older than 2.0.
 
     -  .. _`CEC-MSG-USER-CONTROL-PRESSED`:
 
        -  ``CEC_MSG_USER_CONTROL_PRESSED``
 
        -  If :ref:`CEC_CAP_RC <CEC-CAP-RC>` is set, then generate a remote control key
-          press. This message is always passed on to userspace.
+	  press. This message is always passed on to userspace.
 
     -  .. _`CEC-MSG-USER-CONTROL-RELEASED`:
 
        -  ``CEC_MSG_USER_CONTROL_RELEASED``
 
        -  If :ref:`CEC_CAP_RC <CEC-CAP-RC>` is set, then generate a remote control key
-          release. This message is always passed on to userspace.
+	  release. This message is always passed on to userspace.
 
     -  .. _`CEC-MSG-REPORT-PHYSICAL-ADDR`:
 
        -  ``CEC_MSG_REPORT_PHYSICAL_ADDR``
 
        -  The CEC framework will make note of the reported physical address
-          and then just pass the message on to userspace.
+	  and then just pass the message on to userspace.
 
 
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 2bc2d6091f53..47aadcd553ee 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -33,8 +33,8 @@ Arguments
 Description
 ===========
 
-Note: this documents the proposed CEC API. This API is not yet finalized
-and is currently only available as a staging kernel module.
+.. note:: This documents the proposed CEC API. This API is not yet finalized
+   and is currently only available as a staging kernel module.
 
 To receive a CEC message the application has to fill in the
 :c:type:`struct cec_msg` structure and pass it to the :ref:`CEC_RECEIVE`
@@ -67,8 +67,8 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  ``ts``
 
        -  Timestamp of when the message was transmitted in ns in the case of
-          :ref:`CEC_TRANSMIT` with ``reply`` set to 0, or the timestamp of the
-          received message in all other cases.
+	  :ref:`CEC_TRANSMIT` with ``reply`` set to 0, or the timestamp of the
+	  received message in all other cases.
 
     -  .. row 2
 
@@ -77,9 +77,9 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  ``len``
 
        -  The length of the message. For :ref:`CEC_TRANSMIT` this is filled in
-          by the application. The driver will fill this in for
-          :ref:`CEC_RECEIVE` and for :ref:`CEC_TRANSMIT` it will be filled in with
-          the length of the reply message if ``reply`` was set.
+	  by the application. The driver will fill this in for
+	  :ref:`CEC_RECEIVE` and for :ref:`CEC_TRANSMIT` it will be filled in with
+	  the length of the reply message if ``reply`` was set.
 
     -  .. row 3
 
@@ -88,11 +88,11 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  ``timeout``
 
        -  The timeout in milliseconds. This is the time the device will wait
-          for a message to be received before timing out. If it is set to 0,
-          then it will wait indefinitely when it is called by
-          :ref:`CEC_RECEIVE`. If it is 0 and it is called by :ref:`CEC_TRANSMIT`,
-          then it will be replaced by 1000 if the ``reply`` is non-zero or
-          ignored if ``reply`` is 0.
+	  for a message to be received before timing out. If it is set to 0,
+	  then it will wait indefinitely when it is called by
+	  :ref:`CEC_RECEIVE`. If it is 0 and it is called by :ref:`CEC_TRANSMIT`,
+	  then it will be replaced by 1000 if the ``reply`` is non-zero or
+	  ignored if ``reply`` is 0.
 
     -  .. row 4
 
@@ -101,9 +101,9 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  ``sequence``
 
        -  The sequence number is automatically assigned by the CEC framework
-          for all transmitted messages. It can be later used by the
-          framework to generate an event if a reply for a message was
-          requested and the message was transmitted in a non-blocking mode.
+	  for all transmitted messages. It can be later used by the
+	  framework to generate an event if a reply for a message was
+	  requested and the message was transmitted in a non-blocking mode.
 
     -  .. row 5
 
@@ -120,10 +120,10 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  ``rx_status``
 
        -  The status bits of the received message. See
-          :ref:`cec-rx-status` for the possible status values. It is 0 if
-          this message was transmitted, not received, unless this is the
-          reply to a transmitted message. In that case both ``rx_status``
-          and ``tx_status`` are set.
+	  :ref:`cec-rx-status` for the possible status values. It is 0 if
+	  this message was transmitted, not received, unless this is the
+	  reply to a transmitted message. In that case both ``rx_status``
+	  and ``tx_status`` are set.
 
     -  .. row 7
 
@@ -132,8 +132,8 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  ``tx_status``
 
        -  The status bits of the transmitted message. See
-          :ref:`cec-tx-status` for the possible status values. It is 0 if
-          this messages was received, not transmitted.
+	  :ref:`cec-tx-status` for the possible status values. It is 0 if
+	  this messages was received, not transmitted.
 
     -  .. row 8
 
@@ -142,9 +142,9 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  ``msg``\ [16]
 
        -  The message payload. For :ref:`CEC_TRANSMIT` this is filled in by the
-          application. The driver will fill this in for :ref:`CEC_RECEIVE` and
-          for :ref:`CEC_TRANSMIT` it will be filled in with the payload of the
-          reply message if ``reply`` was set.
+	  application. The driver will fill this in for :ref:`CEC_RECEIVE` and
+	  for :ref:`CEC_TRANSMIT` it will be filled in with the payload of the
+	  reply message if ``reply`` was set.
 
     -  .. row 9
 
@@ -153,15 +153,15 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  ``reply``
 
        -  Wait until this message is replied. If ``reply`` is 0 and the
-          ``timeout`` is 0, then don't wait for a reply but return after
-          transmitting the message. If there was an error as indicated by a
-          non-zero ``tx_status`` field, then ``reply`` and ``timeout`` are
-          both set to 0 by the driver. Ignored by :ref:`CEC_RECEIVE`. The case
-          where ``reply`` is 0 (this is the opcode for the Feature Abort
-          message) and ``timeout`` is non-zero is specifically allowed to
-          send a message and wait up to ``timeout`` milliseconds for a
-          Feature Abort reply. In this case ``rx_status`` will either be set
-          to :ref:`CEC_RX_STATUS_TIMEOUT <CEC-RX-STATUS-TIMEOUT>` or :ref:`CEC_RX_STATUS-FEATURE-ABORT <CEC-RX-STATUS-FEATURE-ABORT>`.
+	  ``timeout`` is 0, then don't wait for a reply but return after
+	  transmitting the message. If there was an error as indicated by a
+	  non-zero ``tx_status`` field, then ``reply`` and ``timeout`` are
+	  both set to 0 by the driver. Ignored by :ref:`CEC_RECEIVE`. The case
+	  where ``reply`` is 0 (this is the opcode for the Feature Abort
+	  message) and ``timeout`` is non-zero is specifically allowed to
+	  send a message and wait up to ``timeout`` milliseconds for a
+	  Feature Abort reply. In this case ``rx_status`` will either be set
+	  to :ref:`CEC_RX_STATUS_TIMEOUT <CEC-RX-STATUS-TIMEOUT>` or :ref:`CEC_RX_STATUS-FEATURE-ABORT <CEC-RX-STATUS-FEATURE-ABORT>`.
 
     -  .. row 10
 
@@ -170,9 +170,9 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  ``tx_arb_lost_cnt``
 
        -  A counter of the number of transmit attempts that resulted in the
-          Arbitration Lost error. This is only set if the hardware supports
-          this, otherwise it is always 0. This counter is only valid if the
-          :ref:`CEC_TX_STATUS_ARB_LOST <CEC-TX-STATUS-ARB-LOST>` status bit is set.
+	  Arbitration Lost error. This is only set if the hardware supports
+	  this, otherwise it is always 0. This counter is only valid if the
+	  :ref:`CEC_TX_STATUS_ARB_LOST <CEC-TX-STATUS-ARB-LOST>` status bit is set.
 
     -  .. row 11
 
@@ -181,9 +181,9 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  ``tx_nack_cnt``
 
        -  A counter of the number of transmit attempts that resulted in the
-          Not Acknowledged error. This is only set if the hardware supports
-          this, otherwise it is always 0. This counter is only valid if the
-          :ref:`CEC_TX_STATUS_NACK <CEC-TX-STATUS-NACK>` status bit is set.
+	  Not Acknowledged error. This is only set if the hardware supports
+	  this, otherwise it is always 0. This counter is only valid if the
+	  :ref:`CEC_TX_STATUS_NACK <CEC-TX-STATUS-NACK>` status bit is set.
 
     -  .. row 12
 
@@ -192,9 +192,9 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  ``tx_low_drive_cnt``
 
        -  A counter of the number of transmit attempts that resulted in the
-          Arbitration Lost error. This is only set if the hardware supports
-          this, otherwise it is always 0. This counter is only valid if the
-          :ref:`CEC_TX_STATUS_LOW_DRIVE <CEC-TX-STATUS-LOW-DRIVE>` status bit is set.
+	  Arbitration Lost error. This is only set if the hardware supports
+	  this, otherwise it is always 0. This counter is only valid if the
+	  :ref:`CEC_TX_STATUS_LOW_DRIVE <CEC-TX-STATUS-LOW-DRIVE>` status bit is set.
 
     -  .. row 13
 
@@ -203,9 +203,9 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  ``tx_error_cnt``
 
        -  A counter of the number of transmit errors other than Arbitration
-          Lost or Not Acknowledged. This is only set if the hardware
-          supports this, otherwise it is always 0. This counter is only
-          valid if the :ref:`CEC_TX_STATUS_ERROR <CEC-TX-STATUS-ERROR>` status bit is set.
+	  Lost or Not Acknowledged. This is only set if the hardware
+	  supports this, otherwise it is always 0. This counter is only
+	  valid if the :ref:`CEC_TX_STATUS_ERROR <CEC-TX-STATUS-ERROR>` status bit is set.
 
 
 
@@ -224,9 +224,9 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  0x01
 
        -  The message was transmitted successfully. This is mutually
-          exclusive with :ref:`CEC_TX_STATUS_MAX_RETRIES <CEC-TX-STATUS-MAX-RETRIES>`. Other bits can still
-          be set if earlier attempts met with failure before the transmit
-          was eventually successful.
+	  exclusive with :ref:`CEC_TX_STATUS_MAX_RETRIES <CEC-TX-STATUS-MAX-RETRIES>`. Other bits can still
+	  be set if earlier attempts met with failure before the transmit
+	  was eventually successful.
 
     -  .. _`CEC-TX-STATUS-ARB-LOST`:
 
@@ -251,8 +251,8 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  0x08
 
        -  Low drive was detected on the CEC bus. This indicates that a
-          follower detected an error on the bus and requests a
-          retransmission.
+	  follower detected an error on the bus and requests a
+	  retransmission.
 
     -  .. _`CEC-TX-STATUS-ERROR`:
 
@@ -261,9 +261,9 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  0x10
 
        -  Some error occurred. This is used for any errors that do not fit
-          the previous two, either because the hardware could not tell which
-          error occurred, or because the hardware tested for other
-          conditions besides those two.
+	  the previous two, either because the hardware could not tell which
+	  error occurred, or because the hardware tested for other
+	  conditions besides those two.
 
     -  .. _`CEC-TX-STATUS-MAX-RETRIES`:
 
@@ -272,8 +272,8 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  0x20
 
        -  The transmit failed after one or more retries. This status bit is
-          mutually exclusive with :ref:`CEC_TX_STATUS_OK <CEC-TX-STATUS-OK>`. Other bits can still
-          be set to explain which failures were seen.
+	  mutually exclusive with :ref:`CEC_TX_STATUS_OK <CEC-TX-STATUS-OK>`. Other bits can still
+	  be set to explain which failures were seen.
 
 
 
@@ -308,8 +308,8 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  0x04
 
        -  The message was received successfully but the reply was
-          ``CEC_MSG_FEATURE_ABORT``. This status is only set if this message
-          was the reply to an earlier transmitted message.
+	  ``CEC_MSG_FEATURE_ABORT``. This status is only set if this message
+	  was the reply to an earlier transmitted message.
 
 
 
diff --git a/Documentation/media/uapi/dvb/dvb-fe-read-status.rst b/Documentation/media/uapi/dvb/dvb-fe-read-status.rst
index 1c708c5e6bc0..fcffaa7e1463 100644
--- a/Documentation/media/uapi/dvb/dvb-fe-read-status.rst
+++ b/Documentation/media/uapi/dvb/dvb-fe-read-status.rst
@@ -15,8 +15,9 @@ The information about the frontend tuner locking status can be queried
 using :ref:`FE_READ_STATUS`.
 
 Signal statistics are provided via
-:ref:`FE_GET_PROPERTY`. Please note that several
-statistics require the demodulator to be fully locked (e. g. with
-FE_HAS_LOCK bit set). See
-:ref:`Frontend statistics indicators <frontend-stat-properties>` for
-more details.
+:ref:`FE_GET_PROPERTY`.
+
+.. note:: Most statistics require the demodulator to be fully locked
+   (e. g. with FE_HAS_LOCK bit set). See
+   :ref:`Frontend statistics indicators <frontend-stat-properties>` for
+   more details.
diff --git a/Documentation/media/uapi/dvb/dvbapi.rst b/Documentation/media/uapi/dvb/dvbapi.rst
index 60fb3d46b1d6..6c06147f167c 100644
--- a/Documentation/media/uapi/dvb/dvbapi.rst
+++ b/Documentation/media/uapi/dvb/dvbapi.rst
@@ -8,8 +8,8 @@
 Digital TV API
 ##############
 
-**NOTE:** This API is also known as **DVB API**, although it is generic
-enough to support all digital TV standards.
+.. note:: This API is also known as **DVB API**, although it is generic
+   enough to support all digital TV standards.
 
 **Version 5.10**
 
diff --git a/Documentation/media/uapi/dvb/dvbproperty.rst b/Documentation/media/uapi/dvb/dvbproperty.rst
index 3c348e585729..cd0511b06c2c 100644
--- a/Documentation/media/uapi/dvb/dvbproperty.rst
+++ b/Documentation/media/uapi/dvb/dvbproperty.rst
@@ -20,13 +20,13 @@ Also, the union didn't have any space left to be expanded without
 breaking userspace. So, the decision was to deprecate the legacy
 union/struct based approach, in favor of a properties set approach.
 
-NOTE: on Linux DVB API version 3, setting a frontend were done via
-:ref:`struct dvb_frontend_parameters <dvb-frontend-parameters>`.
-This got replaced on version 5 (also called "S2API", as this API were
-added originally_enabled to provide support for DVB-S2), because the
-old API has a very limited support to new standards and new hardware.
-This section describes the new and recommended way to set the frontend,
-with suppports all digital TV delivery systems.
+.. note:: On Linux DVB API version 3, setting a frontend were done via
+   :ref:`struct dvb_frontend_parameters <dvb-frontend-parameters>`.
+   This got replaced on version 5 (also called "S2API", as this API were
+   added originally_enabled to provide support for DVB-S2), because the
+   old API has a very limited support to new standards and new hardware.
+   This section describes the new and recommended way to set the frontend,
+   with suppports all digital TV delivery systems.
 
 Example: with the properties based approach, in order to set the tuner
 to a DVB-C channel at 651 kHz, modulated with 256-QAM, FEC 3/4 and
@@ -93,12 +93,12 @@ Example: Setting digital TV frontend properties
 	return 0;
     }
 
-NOTE: While it is possible to directly call the Kernel code like the
-above example, it is strongly recommended to use
-`libdvbv5 <https://linuxtv.org/docs/libdvbv5/index.html>`__, as it
-provides abstraction to work with the supported digital TV standards and
-provides methods for usual operations like program scanning and to
-read/write channel descriptor files.
+.. attention:: While it is possible to directly call the Kernel code like the
+   above example, it is strongly recommended to use
+   `libdvbv5 <https://linuxtv.org/docs/libdvbv5/index.html>`__, as it
+   provides abstraction to work with the supported digital TV standards and
+   provides methods for usual operations like program scanning and to
+   read/write channel descriptor files.
 
 
 .. toctree::
diff --git a/Documentation/media/uapi/dvb/examples.rst b/Documentation/media/uapi/dvb/examples.rst
index ead3ddf764c0..bf0a8617de92 100644
--- a/Documentation/media/uapi/dvb/examples.rst
+++ b/Documentation/media/uapi/dvb/examples.rst
@@ -9,10 +9,10 @@ Examples
 In this section we would like to present some examples for using the DVB
 API.
 
-NOTE: This section is out of date, and the code below won't even
-compile. Please refer to the
-`libdvbv5 <https://linuxtv.org/docs/libdvbv5/index.html>`__ for
-updated/recommended examples.
+..note:: This section is out of date, and the code below won't even
+   compile. Please refer to the
+   `libdvbv5 <https://linuxtv.org/docs/libdvbv5/index.html>`__ for
+   updated/recommended examples.
 
 
 .. _tuning:
diff --git a/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst b/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
index 9f71b39de0c2..d47e9dbf558a 100644
--- a/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
+++ b/Documentation/media/uapi/dvb/fe-dishnetwork-send-legacy-cmd.rst
@@ -36,8 +36,9 @@ Arguments
 Description
 ===========
 
-WARNING: This is a very obscure legacy command, used only at stv0299
-driver. Should not be used on newer drivers.
+.. warning::
+   This is a very obscure legacy command, used only at stv0299
+   driver. Should not be used on newer drivers.
 
 It provides a non-standard method for selecting Diseqc voltage on the
 frontend, for Dish Network legacy switches.
diff --git a/Documentation/media/uapi/dvb/fe-get-info.rst b/Documentation/media/uapi/dvb/fe-get-info.rst
index 9a9ddbcdb1ec..bb6c32e47ce8 100644
--- a/Documentation/media/uapi/dvb/fe-get-info.rst
+++ b/Documentation/media/uapi/dvb/fe-get-info.rst
@@ -144,8 +144,8 @@ struct dvb_frontend_info
        -  Capabilities supported by the frontend
 
 
-NOTE: The frequencies are specified in Hz for Terrestrial and Cable
-systems. They're specified in kHz for Satellite systems
+.. note:: The frequencies are specified in Hz for Terrestrial and Cable
+   systems. They're specified in kHz for Satellite systems
 
 
 .. _fe-caps-t:
diff --git a/Documentation/media/uapi/dvb/fe-read-status.rst b/Documentation/media/uapi/dvb/fe-read-status.rst
index 339955fbe133..624ed9d06488 100644
--- a/Documentation/media/uapi/dvb/fe-read-status.rst
+++ b/Documentation/media/uapi/dvb/fe-read-status.rst
@@ -40,9 +40,9 @@ used to check about the locking status of the frontend after being
 tuned. The ioctl takes a pointer to an integer where the status will be
 written.
 
-NOTE: the size of status is actually sizeof(enum fe_status), with
-varies according with the architecture. This needs to be fixed in the
-future.
+.. note:: The size of status is actually sizeof(enum fe_status), with
+   varies according with the architecture. This needs to be fixed in the
+   future.
 
 
 .. _fe-status-t:
diff --git a/Documentation/media/uapi/dvb/fe-set-tone.rst b/Documentation/media/uapi/dvb/fe-set-tone.rst
index 763b61d91004..545e2afba2c0 100644
--- a/Documentation/media/uapi/dvb/fe-set-tone.rst
+++ b/Documentation/media/uapi/dvb/fe-set-tone.rst
@@ -42,10 +42,10 @@ to send a 22kHz tone in order to select between high/low band on some
 dual-band LNBf. It is also used to send signals to DiSEqC equipment, but
 this is done using the DiSEqC ioctls.
 
-NOTE: if more than one device is connected to the same antenna, setting
-a tone may interfere on other devices, as they may lose the capability
-of selecting the band. So, it is recommended that applications would
-change to SEC_TONE_OFF when the device is not used.
+.. attention:: If more than one device is connected to the same antenna,
+   setting a tone may interfere on other devices, as they may lose the
+   capability of selecting the band. So, it is recommended that applications
+   would change to SEC_TONE_OFF when the device is not used.
 
 .. _fe-sec-tone-mode-t:
 
diff --git a/Documentation/media/uapi/dvb/fe-set-voltage.rst b/Documentation/media/uapi/dvb/fe-set-voltage.rst
index 517f79bdbb4b..2b19086b660a 100644
--- a/Documentation/media/uapi/dvb/fe-set-voltage.rst
+++ b/Documentation/media/uapi/dvb/fe-set-voltage.rst
@@ -48,11 +48,11 @@ the ones that implement DISEqC and multipoint LNBf's don't need to
 control the voltage level, provided that either 13V or 18V is sent to
 power up the LNBf.
 
-NOTE: if more than one device is connected to the same antenna, setting
-a voltage level may interfere on other devices, as they may lose the
-capability of setting polarization or IF. So, on those cases, setting
-the voltage to SEC_VOLTAGE_OFF while the device is not is used is
-recommended.
+.. attention:: if more than one device is connected to the same antenna,
+   setting a voltage level may interfere on other devices, as they may lose
+   the capability of setting polarization or IF. So, on those cases, setting
+   the voltage to SEC_VOLTAGE_OFF while the device is not is used is
+   recommended.
 
 
 Return Value
diff --git a/Documentation/media/uapi/dvb/frontend.rst b/Documentation/media/uapi/dvb/frontend.rst
index 8c7e502bff1f..48c5cd487ce7 100644
--- a/Documentation/media/uapi/dvb/frontend.rst
+++ b/Documentation/media/uapi/dvb/frontend.rst
@@ -29,8 +29,8 @@ The frontend can be accessed through ``/dev/dvb/adapter?/frontend?``.
 Data types and ioctl definitions can be accessed by including
 ``linux/dvb/frontend.h`` in your application.
 
-NOTE: Transmission via the internet (DVB-IP) is not yet handled by this
-API but a future extension is possible.
+.. note:: Transmission via the internet (DVB-IP) is not yet handled by this
+   API but a future extension is possible.
 
 On Satellite systems, the API support for the Satellite Equipment
 Control (SEC) allows to power control and to send/receive signals to
diff --git a/Documentation/media/uapi/gen-errors.rst b/Documentation/media/uapi/gen-errors.rst
index 6cd5d26f32ab..d6b0cfd00a3f 100644
--- a/Documentation/media/uapi/gen-errors.rst
+++ b/Documentation/media/uapi/gen-errors.rst
@@ -92,10 +92,12 @@ Generic Error Codes
        -  Permission denied. Can be returned if the device needs write
 	  permission, or some special capabilities is needed (e. g. root)
 
+.. note::
 
-Note 1: ioctls may return other error codes. Since errors may have side
-effects such as a driver reset, applications should abort on unexpected
-errors.
+  #. This list is not exaustive; ioctls may return other error codes.
+     Since errors may have side effects such as a driver reset,
+     applications should abort on unexpected errors, or otherwise
+     assume that the device is in a bad state.
 
-Note 2: Request-specific error codes are listed in the individual
-requests descriptions.
+  #. Request-specific error codes are listed in the individual
+     requests descriptions.
diff --git a/Documentation/media/uapi/rc/lirc_ioctl.rst b/Documentation/media/uapi/rc/lirc_ioctl.rst
index c1c7163ba2f7..77f39d11e226 100644
--- a/Documentation/media/uapi/rc/lirc_ioctl.rst
+++ b/Documentation/media/uapi/rc/lirc_ioctl.rst
@@ -251,11 +251,13 @@ I/O control requests
     be useful of receivers that have otherwise narrow band receiver that
     prevents them to be used with some remotes. Wide band receiver might
     also be more precise On the other hand its disadvantage it usually
-    reduced range of reception. Note: wide band receiver might be
-    implictly enabled if you enable carrier reports. In that case it
-    will be disabled as soon as you disable carrier reports. Trying to
-    disable wide band receiver while carrier reports are active will do
-    nothing.
+    reduced range of reception.
+
+    .. note:: Wide band receiver might be
+       implictly enabled if you enable carrier reports. In that case it
+       will be disabled as soon as you disable carrier reports. Trying to
+       disable wide band receiver while carrier reports are active will do
+       nothing.
 
 
 .. _lirc_dev_errors:
diff --git a/Documentation/media/uapi/v4l/audio.rst b/Documentation/media/uapi/v4l/audio.rst
index 47f8334f071e..cd3057326de7 100644
--- a/Documentation/media/uapi/v4l/audio.rst
+++ b/Documentation/media/uapi/v4l/audio.rst
@@ -35,11 +35,12 @@ The struct :ref:`v4l2_audio <v4l2-audio>` returned by the
 
 The :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` and
 :ref:`VIDIOC_G_AUDOUT <VIDIOC_G_AUDOUT>` ioctls report the current
-audio input and output, respectively. Note that, unlike
-:ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` and
-:ref:`VIDIOC_G_OUTPUT <VIDIOC_G_OUTPUT>` these ioctls return a
-structure as :ref:`VIDIOC_ENUMAUDIO` and
-:ref:`VIDIOC_ENUMAUDOUT <VIDIOC_ENUMAUDOUT>` do, not just an index.
+audio input and output, respectively.
+
+.. note:: Note that, unlike :ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` and
+   :ref:`VIDIOC_G_OUTPUT <VIDIOC_G_OUTPUT>` these ioctls return a
+   structure as :ref:`VIDIOC_ENUMAUDIO` and
+   :ref:`VIDIOC_ENUMAUDOUT <VIDIOC_ENUMAUDOUT>` do, not just an index.
 
 To select an audio input and change its properties applications call the
 :ref:`VIDIOC_S_AUDIO <VIDIOC_G_AUDIO>` ioctl. To select an audio
diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index b195eb5b63a1..16cdd8e2c4d7 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -166,11 +166,11 @@ struct v4l2_buffer
 	  output device because the application did not pass new data in
 	  time.
 
-	  Note this may count the frames received e.g. over USB, without
-	  taking into account the frames dropped by the remote hardware due
-	  to limited compression throughput or bus bandwidth. These devices
-	  identify by not enumerating any video standards, see
-	  :ref:`standard`.
+	  .. note:: This may count the frames received e.g. over USB, without
+	     taking into account the frames dropped by the remote hardware due
+	     to limited compression throughput or bus bandwidth. These devices
+	     identify by not enumerating any video standards, see
+	     :ref:`standard`.
 
     -  .. row 10
 
@@ -297,8 +297,10 @@ struct v4l2_plane
 	  stream, applications when it refers to an output stream. If the
 	  application sets this to 0 for an output stream, then
 	  ``bytesused`` will be set to the size of the plane (see the
-	  ``length`` field of this struct) by the driver. Note that the
-	  actual image data starts at ``data_offset`` which may not be 0.
+	  ``length`` field of this struct) by the driver.
+
+	  .. note:: Note that the actual image data starts at ``data_offset``
+	     which may not be 0.
 
     -  .. row 2
 
@@ -367,10 +369,11 @@ struct v4l2_plane
        -
        -  Offset in bytes to video data in the plane. Drivers must set this
 	  field when ``type`` refers to a capture stream, applications when
-	  it refers to an output stream. Note that data_offset is included
-	  in ``bytesused``. So the size of the image in the plane is
-	  ``bytesused``-``data_offset`` at offset ``data_offset`` from the
-	  start of the plane.
+	  it refers to an output stream.
+
+	  .. note:: That data_offset is included  in ``bytesused``. So the
+	     size of the image in the plane is ``bytesused``-``data_offset``
+	     at offset ``data_offset`` from the start of the plane.
 
     -  .. row 8
 
diff --git a/Documentation/media/uapi/v4l/crop.rst b/Documentation/media/uapi/v4l/crop.rst
index 51b19491c302..0913822347af 100644
--- a/Documentation/media/uapi/v4l/crop.rst
+++ b/Documentation/media/uapi/v4l/crop.rst
@@ -15,9 +15,9 @@ offset into a video signal.
 Applications can use the following API to select an area in the video
 signal, query the default area and the hardware limits.
 
-**NOTE**: Despite their name, the :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>`,
-:ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and :ref:`VIDIOC_S_CROP
-<VIDIOC_G_CROP>` ioctls apply to input as well as output devices.
+.. note:: Despite their name, the :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>`,
+   :ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and :ref:`VIDIOC_S_CROP
+   <VIDIOC_G_CROP>` ioctls apply to input as well as output devices.
 
 Scaling requires a source and a target. On a video capture or overlay
 device the source is the video signal, and the cropping ioctls determine
@@ -38,9 +38,9 @@ support scaling or the :ref:`VIDIOC_G_CROP <VIDIOC_G_CROP>` and
 :ref:`VIDIOC_S_CROP <VIDIOC_G_CROP>` ioctls. Their size (and position
 where applicable) will be fixed in this case.
 
-**NOTE:** All capture and output devices must support the
-:ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>` ioctl such that applications can
-determine if scaling takes place.
+.. note:: All capture and output devices must support the
+   :ref:`VIDIOC_CROPCAP <VIDIOC_CROPCAP>` ioctl such that applications
+   can determine if scaling takes place.
 
 
 Cropping Structures
@@ -144,8 +144,8 @@ reopening a device, such that piping data into or out of a device will
 work without special preparations. More advanced applications should
 ensure the parameters are suitable before starting I/O.
 
-**NOTE:** on the next two examples, a video capture device is assumed;
-change ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` for other types of device.
+.. note:: On the next two examples, a video capture device is assumed;
+   change ``V4L2_BUF_TYPE_VIDEO_CAPTURE`` for other types of device.
 
 Example: Resetting the cropping parameters
 ==========================================
@@ -207,7 +207,7 @@ Example: Simple downscaling
 Example: Selecting an output area
 =================================
 
-**NOTE:** This example assumes an output device.
+.. note:: This example assumes an output device.
 
 .. code-block:: c
 
@@ -246,7 +246,7 @@ Example: Selecting an output area
 Example: Current scaling factor and pixel aspect
 ================================================
 
-**NOTE:** This example assumes a video capture device.
+.. note:: This example assumes a video capture device.
 
 .. code-block:: c
 
diff --git a/Documentation/media/uapi/v4l/dev-capture.rst b/Documentation/media/uapi/v4l/dev-capture.rst
index 16030a8354fd..8d049471e1c2 100644
--- a/Documentation/media/uapi/v4l/dev-capture.rst
+++ b/Documentation/media/uapi/v4l/dev-capture.rst
@@ -15,7 +15,9 @@ Conventionally V4L2 video capture devices are accessed through character
 device special files named ``/dev/video`` and ``/dev/video0`` to
 ``/dev/video63`` with major number 81 and minor numbers 0 to 63.
 ``/dev/video`` is typically a symbolic link to the preferred video
-device. Note the same device files are used for video output devices.
+device.
+
+.. note:: The same device file names are used for video output devices.
 
 
 Querying Capabilities
diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentation/media/uapi/v4l/dev-codec.rst
index 7fd28d085c2c..dfb20328e34d 100644
--- a/Documentation/media/uapi/v4l/dev-codec.rst
+++ b/Documentation/media/uapi/v4l/dev-codec.rst
@@ -19,8 +19,10 @@ both sides and finally call :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`
 for both capture and output to start the codec.
 
 Video compression codecs use the MPEG controls to setup their codec
-parameters (note that the MPEG controls actually support many more
-codecs than just MPEG). See :ref:`mpeg-controls`.
+parameters
+
+.. note:: The MPEG controls actually support many more codecs than
+   just MPEG. See :ref:`mpeg-controls`.
 
 Memory-to-memory devices can often be used as a shared resource: you can
 open the video node multiple times, each application setting up their
diff --git a/Documentation/media/uapi/v4l/dev-effect.rst b/Documentation/media/uapi/v4l/dev-effect.rst
index be4de3b0a025..b946cc9e1064 100644
--- a/Documentation/media/uapi/v4l/dev-effect.rst
+++ b/Documentation/media/uapi/v4l/dev-effect.rst
@@ -6,11 +6,10 @@
 Effect Devices Interface
 ************************
 
-    **Note**
-
-    This interface has been be suspended from the V4L2 API implemented
-    in Linux 2.6 until we have more experience with effect device
-    interfaces.
+.. note::
+    This interface has been be suspended from the V4L2 API.
+    The implementation for such effects should be done
+    via mem2mem devices.
 
 A V4L2 video effect device can do image effects, filtering, or combine
 two or more images or image streams. For example video transitions or
diff --git a/Documentation/media/uapi/v4l/dev-osd.rst b/Documentation/media/uapi/v4l/dev-osd.rst
index 98570cea63a5..fadda131f020 100644
--- a/Documentation/media/uapi/v4l/dev-osd.rst
+++ b/Documentation/media/uapi/v4l/dev-osd.rst
@@ -14,10 +14,11 @@ this interface, which borrows structures and ioctls of the
 :ref:`Video Overlay <overlay>` interface.
 
 The OSD function is accessible through the same character special file
-as the :ref:`Video Output <capture>` function. Note the default
-function of such a ``/dev/video`` device is video capturing or output.
-The OSD function is only available after calling the
-:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl.
+as the :ref:`Video Output <capture>` function.
+
+.. note:: The default function of such a ``/dev/video`` device is video
+   capturing or output. The OSD function is only available after calling
+   the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl.
 
 
 Querying Capabilities
diff --git a/Documentation/media/uapi/v4l/dev-output.rst b/Documentation/media/uapi/v4l/dev-output.rst
index 5063be7d4938..4f1123a0b40d 100644
--- a/Documentation/media/uapi/v4l/dev-output.rst
+++ b/Documentation/media/uapi/v4l/dev-output.rst
@@ -14,7 +14,9 @@ Conventionally V4L2 video output devices are accessed through character
 device special files named ``/dev/video`` and ``/dev/video0`` to
 ``/dev/video63`` with major number 81 and minor numbers 0 to 63.
 ``/dev/video`` is typically a symbolic link to the preferred video
-device. Note the same device files are used for video capture devices.
+device.
+
+..note:: The same device file names are used also for video capture devices.
 
 
 Querying Capabilities
diff --git a/Documentation/media/uapi/v4l/dev-overlay.rst b/Documentation/media/uapi/v4l/dev-overlay.rst
index bed00bf34982..bf8a418e7554 100644
--- a/Documentation/media/uapi/v4l/dev-overlay.rst
+++ b/Documentation/media/uapi/v4l/dev-overlay.rst
@@ -17,10 +17,11 @@ plants needed cooling towers this used to be the only way to put live
 video into a window.
 
 Video overlay devices are accessed through the same character special
-files as :ref:`video capture <capture>` devices. Note the default
-function of a ``/dev/video`` device is video capturing. The overlay
-function is only available after calling the
-:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl.
+files as :ref:`video capture <capture>` devices.
+
+.. note:: The default function of a ``/dev/video`` device is video
+   capturing. The overlay function is only available after calling
+   the :ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>` ioctl.
 
 The driver may support simultaneous overlay and capturing using the
 read/write and streaming I/O methods. If so, operation at the nominal
@@ -235,10 +236,10 @@ exceeded are undefined. [3]_
     :ref:`VIDIOC_S_FBUF <VIDIOC_G_FBUF>`,
     :ref:`framebuffer-flags`).
 
-    **Note**: this field was added in Linux 2.6.23, extending the structure.
-    However the :ref:`VIDIOC_[G|S|TRY]_FMT <VIDIOC_G_FMT>`
-    ioctls, which take a pointer to a :ref:`v4l2_format <v4l2-format>`
-    parent structure with padding bytes at the end, are not affected.
+    .. note:: This field was added in Linux 2.6.23, extending the
+       structure. However the :ref:`VIDIOC_[G|S|TRY]_FMT <VIDIOC_G_FMT>`
+       ioctls, which take a pointer to a :ref:`v4l2_format <v4l2-format>`
+       parent structure with padding bytes at the end, are not affected.
 
 
 .. _v4l2-clip:
diff --git a/Documentation/media/uapi/v4l/dev-rds.rst b/Documentation/media/uapi/v4l/dev-rds.rst
index 6a0b1a874668..cd6ad63cb90b 100644
--- a/Documentation/media/uapi/v4l/dev-rds.rst
+++ b/Documentation/media/uapi/v4l/dev-rds.rst
@@ -14,10 +14,10 @@ at devices capable of receiving and/or transmitting RDS information.
 For more information see the core RDS standard :ref:`iec62106` and the
 RBDS standard :ref:`nrsc4`.
 
-Note that the RBDS standard as is used in the USA is almost identical to
-the RDS standard. Any RDS decoder/encoder can also handle RBDS. Only
-some of the fields have slightly different meanings. See the RBDS
-standard for more information.
+.. note:: Note that the RBDS standard as is used in the USA is almost
+   identical to the RDS standard. Any RDS decoder/encoder can also handle
+   RBDS. Only some of the fields have slightly different meanings. See the
+   RBDS standard for more information.
 
 The RBDS standard also specifies support for MMBS (Modified Mobile
 Search). This is a proprietary format which seems to be discontinued.
diff --git a/Documentation/media/uapi/v4l/dev-subdev.rst b/Documentation/media/uapi/v4l/dev-subdev.rst
index 39d3d860dda4..5a112eb7a245 100644
--- a/Documentation/media/uapi/v4l/dev-subdev.rst
+++ b/Documentation/media/uapi/v4l/dev-subdev.rst
@@ -72,14 +72,14 @@ reported on one (or several) V4L2 device nodes.
 Pad-level Formats
 =================
 
-    **Warning**
+.. warning::
 
-    Pad-level formats are only applicable to very complex device that
+    Pad-level formats are only applicable to very complex devices that
     need to expose low-level format configuration to user space. Generic
     V4L2 applications do *not* need to use the API described in this
     section.
 
-    **Note**
+.. note::
 
     For the purpose of this section, the term *format* means the
     combination of media bus data format, frame width and frame height.
diff --git a/Documentation/media/uapi/v4l/dmabuf.rst b/Documentation/media/uapi/v4l/dmabuf.rst
index 57917fb98c7a..675768f7c66a 100644
--- a/Documentation/media/uapi/v4l/dmabuf.rst
+++ b/Documentation/media/uapi/v4l/dmabuf.rst
@@ -143,13 +143,16 @@ functions are always available.
 
 To start and stop capturing or displaying applications call the
 :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` and
-:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctls. Note that
-:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` removes all buffers from
-both queues and unlocks all buffers as a side effect. Since there is no
-notion of doing anything "now" on a multitasking system, if an
-application needs to synchronize with another event it should examine
-the struct :ref:`v4l2_buffer <v4l2-buffer>` ``timestamp`` of captured or
-outputted buffers.
+:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctls.
+
+.. note::
+
+   :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` removes all buffers from
+   both queues and unlocks all buffers as a side effect. Since there is no
+   notion of doing anything "now" on a multitasking system, if an
+   application needs to synchronize with another event it should examine
+   the struct :ref:`v4l2_buffer <v4l2-buffer>` ``timestamp`` of captured or
+   outputted buffers.
 
 Drivers implementing DMABUF importing I/O must support the
 :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`, :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`,
diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 26eb6ee851c3..11d15d3190e9 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -84,17 +84,20 @@ themselves than is possible with
 particular, this ioctl gives the dimensions of the N-dimensional array
 if this control consists of more than one element.
 
-It is important to realize that due to the flexibility of controls it is
-necessary to check whether the control you want to set actually is
-supported in the driver and what the valid range of values is. So use
-the :ref:`VIDIOC_QUERYCTRL` (or
-:ref:`VIDIOC_QUERY_EXT_CTRL <VIDIOC_QUERYCTRL>`) and
-:ref:`VIDIOC_QUERYMENU <VIDIOC_QUERYCTRL>` ioctls to check this. Also
-note that it is possible that some of the menu indices in a control of
-type ``V4L2_CTRL_TYPE_MENU`` may not be supported (``VIDIOC_QUERYMENU``
-will return an error). A good example is the list of supported MPEG
-audio bitrates. Some drivers only support one or two bitrates, others
-support a wider range.
+.. note::
+
+   #. It is important to realize that due to the flexibility of controls it is
+      necessary to check whether the control you want to set actually is
+      supported in the driver and what the valid range of values is. So use
+      the :ref:`VIDIOC_QUERYCTRL` (or :ref:`VIDIOC_QUERY_EXT_CTRL
+      <VIDIOC_QUERYCTRL>`) and :ref:`VIDIOC_QUERYMENU <VIDIOC_QUERYCTRL>`
+      ioctls to check this.
+
+   #. It is possible that some of the menu indices in a control of
+      type ``V4L2_CTRL_TYPE_MENU`` may not be supported (``VIDIOC_QUERYMENU``
+      will return an error). A good example is the list of supported MPEG
+      audio bitrates. Some drivers only support one or two bitrates, others
+      support a wider range.
 
 All controls use machine endianness.
 
@@ -181,10 +184,10 @@ Codec Control Reference
 Below all controls within the Codec control class are described. First
 the generic controls, then controls specific for certain hardware.
 
-Note: These controls are applicable to all codecs and not just MPEG. The
-defines are prefixed with V4L2_CID_MPEG/V4L2_MPEG as the controls
-were originally made for MPEG codecs and later extended to cover all
-encoding formats.
+.. note:: These controls are applicable to all codecs and not just MPEG. The
+   defines are prefixed with V4L2_CID_MPEG/V4L2_MPEG as the controls
+   were originally made for MPEG codecs and later extended to cover all
+   encoding formats.
 
 
 Generic Codec Controls
@@ -2282,13 +2285,15 @@ MFC 5.1 Control IDs
 ``V4L2_CID_MPEG_MFC51_VIDEO_RC_REACTION_COEFF (integer)``
     Reaction coefficient for MFC rate control. Applicable to encoders.
 
-    Note 1: Valid only when the frame level RC is enabled.
+    .. note::
 
-    Note 2: For tight CBR, this field must be small (ex. 2 ~ 10). For
-    VBR, this field must be large (ex. 100 ~ 1000).
+       #. Valid only when the frame level RC is enabled.
 
-    Note 3: It is not recommended to use the greater number than
-    FRAME_RATE * (10^9 / BIT_RATE).
+       #. For tight CBR, this field must be small (ex. 2 ~ 10). For
+	  VBR, this field must be large (ex. 100 ~ 1000).
+
+       #. It is not recommended to use the greater number than
+	  FRAME_RATE * (10^9 / BIT_RATE).
 
 ``V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_DARK (boolean)``
     Adaptive rate control for dark region. Valid only when H.264 and
@@ -4107,14 +4112,16 @@ transmitters for `VGA <http://en.wikipedia.org/wiki/Vga>`__,
 the receiver or transmitter subdevice that implements them, so they are
 only exposed on the ``/dev/v4l-subdev*`` device node.
 
-Note that these devices can have multiple input or output pads which are
-hooked up to e.g. HDMI connectors. Even though the subdevice will
-receive or transmit video from/to only one of those pads, the other pads
-can still be active when it comes to EDID (Extended Display
-Identification Data, :ref:`vesaedid`) and HDCP (High-bandwidth Digital
-Content Protection System, :ref:`hdcp`) processing, allowing the
-device to do the fairly slow EDID/HDCP handling in advance. This allows
-for quick switching between connectors.
+.. note::
+
+   Note that these devices can have multiple input or output pads which are
+   hooked up to e.g. HDMI connectors. Even though the subdevice will
+   receive or transmit video from/to only one of those pads, the other pads
+   can still be active when it comes to EDID (Extended Display
+   Identification Data, :ref:`vesaedid`) and HDCP (High-bandwidth Digital
+   Content Protection System, :ref:`hdcp`) processing, allowing the
+   device to do the fairly slow EDID/HDCP handling in advance. This allows
+   for quick switching between connectors.
 
 These pads appear in several of the controls in this section as
 bitmasks, one bit for each pad. Bit 0 corresponds to pad 0, bit 1 to pad
diff --git a/Documentation/media/uapi/v4l/func-mmap.rst b/Documentation/media/uapi/v4l/func-mmap.rst
index 3502c2afd894..c156fb7b7422 100644
--- a/Documentation/media/uapi/v4l/func-mmap.rst
+++ b/Documentation/media/uapi/v4l/func-mmap.rst
@@ -47,17 +47,20 @@ Arguments
     Regardless of the device type and the direction of data exchange it
     should be set to ``PROT_READ`` | ``PROT_WRITE``, permitting read
     and write access to image buffers. Drivers should support at least
-    this combination of flags. Note the Linux ``video-buf`` kernel
-    module, which is used by the bttv, saa7134, saa7146, cx88 and vivi
-    driver supports only ``PROT_READ`` | ``PROT_WRITE``. When the
-    driver does not support the desired protection the
-    :ref:`mmap() <func-mmap>` function fails.
+    this combination of flags.
 
-    Note device memory accesses (e. g. the memory on a graphics card
-    with video capturing hardware) may incur a performance penalty
-    compared to main memory accesses, or reads may be significantly
-    slower than writes or vice versa. Other I/O methods may be more
-    efficient in this case.
+    .. note::
+
+      #. The Linux ``videobuf`` kernel module, which is used by some
+	 drivers supports only ``PROT_READ`` | ``PROT_WRITE``. When the
+	 driver does not support the desired protection, the
+	 :ref:`mmap() <func-mmap>` function fails.
+
+      #. Device memory accesses (e. g. the memory on a graphics card
+	 with video capturing hardware) may incur a performance penalty
+	 compared to main memory accesses, or reads may be significantly
+	 slower than writes or vice versa. Other I/O methods may be more
+	 efficient in such case.
 
 ``flags``
     The ``flags`` parameter specifies the type of the mapped object,
@@ -73,11 +76,13 @@ Arguments
 
     One of the ``MAP_SHARED`` or ``MAP_PRIVATE`` flags must be set.
     ``MAP_SHARED`` allows applications to share the mapped memory with
-    other (e. g. child-) processes. Note the Linux ``video-buf`` module
-    which is used by the bttv, saa7134, saa7146, cx88 and vivi driver
-    supports only ``MAP_SHARED``. ``MAP_PRIVATE`` requests copy-on-write
-    semantics. V4L2 applications should not set the ``MAP_PRIVATE``,
-    ``MAP_DENYWRITE``, ``MAP_EXECUTABLE`` or ``MAP_ANON`` flag.
+    other (e. g. child-) processes.
+
+    .. note:: The Linux ``videobuf`` module  which is used by some
+       drivers supports only ``MAP_SHARED``. ``MAP_PRIVATE`` requests
+       copy-on-write semantics. V4L2 applications should not set the
+       ``MAP_PRIVATE``, ``MAP_DENYWRITE``, ``MAP_EXECUTABLE`` or ``MAP_ANON``
+       flags.
 
 ``fd``
     File descriptor returned by :ref:`open() <func-open>`.
diff --git a/Documentation/media/uapi/v4l/mmap.rst b/Documentation/media/uapi/v4l/mmap.rst
index b01f4486499a..260c2db8916b 100644
--- a/Documentation/media/uapi/v4l/mmap.rst
+++ b/Documentation/media/uapi/v4l/mmap.rst
@@ -245,12 +245,14 @@ available. The :ref:`select() <func-select>` or :ref:`poll()
 
 To start and stop capturing or output applications call the
 :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` and :ref:`VIDIOC_STREAMOFF
-<VIDIOC_STREAMON>` ioctl. Note :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`
-removes all buffers from both queues as a side effect. Since there is
-no notion of doing anything "now" on a multitasking system, if an
-application needs to synchronize with another event it should examine
-the struct ::ref:`v4l2_buffer <v4l2-buffer>` ``timestamp`` of captured
-or outputted buffers.
+<VIDIOC_STREAMON>` ioctl.
+
+.. note:::ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`
+   removes all buffers from both queues as a side effect. Since there is
+   no notion of doing anything "now" on a multitasking system, if an
+   application needs to synchronize with another event it should examine
+   the struct ::ref:`v4l2_buffer <v4l2-buffer>` ``timestamp`` of captured
+   or outputted buffers.
 
 Drivers implementing memory mapping I/O must support the
 :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`, :ref:`VIDIOC_QUERYBUF
diff --git a/Documentation/media/uapi/v4l/pixfmt-006.rst b/Documentation/media/uapi/v4l/pixfmt-006.rst
index b9e7c6844020..9a0f494e2851 100644
--- a/Documentation/media/uapi/v4l/pixfmt-006.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-006.rst
@@ -17,9 +17,11 @@ identifier (enum :ref:`v4l2_quantization <v4l2-quantization>`) to
 specify non-standard quantization methods. Most of the time only the
 colorspace field of struct :ref:`v4l2_pix_format <v4l2-pix-format>`
 or struct :ref:`v4l2_pix_format_mplane <v4l2-pix-format-mplane>`
-needs to be filled in. Note that the default R'G'B' quantization is full
-range for all colorspaces except for BT.2020 which uses limited range
-R'G'B' quantization.
+needs to be filled in.
+
+.. note:: The default R'G'B' quantization is full range for all
+   colorspaces except for BT.2020 which uses limited range R'G'B'
+   quantization.
 
 
 .. _v4l2-colorspace:
diff --git a/Documentation/media/uapi/v4l/pixfmt-007.rst b/Documentation/media/uapi/v4l/pixfmt-007.rst
index 5e39cda6147a..8c946b0c63a0 100644
--- a/Documentation/media/uapi/v4l/pixfmt-007.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-007.rst
@@ -536,11 +536,13 @@ Colorspace DCI-P3 (V4L2_COLORSPACE_DCI_P3)
 The :ref:`smpte431` standard defines the colorspace used by cinema
 projectors that use the DCI-P3 colorspace. The default transfer function
 is ``V4L2_XFER_FUNC_DCI_P3``. The default Y'CbCr encoding is
-``V4L2_YCBCR_ENC_709``. Note that this colorspace does not specify a
-Y'CbCr encoding since it is not meant to be encoded to Y'CbCr. So this
-default Y'CbCr encoding was picked because it is the HDTV encoding. The
-default Y'CbCr quantization is limited range. The chromaticities of the
-primary colors and the white reference are:
+``V4L2_YCBCR_ENC_709``.
+
+.. note:: Note that this colorspace does not specify a
+   Y'CbCr encoding since it is not meant to be encoded to Y'CbCr. So this
+   default Y'CbCr encoding was picked because it is the HDTV encoding. The
+   default Y'CbCr quantization is limited range. The chromaticities of the
+   primary colors and the white reference are:
 
 
 
@@ -752,10 +754,10 @@ reference are:
        -  0.316
 
 
-Note that this colorspace uses Illuminant C instead of D65 as the white
-reference. To correctly convert an image in this colorspace to another
-that uses D65 you need to apply a chromatic adaptation algorithm such as
-the Bradford method.
+.. note:: This colorspace uses Illuminant C instead of D65 as the white
+   reference. To correctly convert an image in this colorspace to another
+   that uses D65 you need to apply a chromatic adaptation algorithm such as
+   the Bradford method.
 
 The transfer function was never properly defined for NTSC 1953. The Rec.
 709 transfer function is recommended in the literature:
@@ -886,9 +888,9 @@ reference are identical to sRGB. The transfer function use is
 with full range quantization where Y' is scaled to [0…255] and Cb/Cr are
 scaled to [-128…128] and then clipped to [-128…127].
 
-Note that the JPEG standard does not actually store colorspace
-information. So if something other than sRGB is used, then the driver
-will have to set that information explicitly. Effectively
-``V4L2_COLORSPACE_JPEG`` can be considered to be an abbreviation for
-``V4L2_COLORSPACE_SRGB``, ``V4L2_YCBCR_ENC_601`` and
-``V4L2_QUANTIZATION_FULL_RANGE``.
+.. note:: The JPEG standard does not actually store colorspace
+   information. So if something other than sRGB is used, then the driver
+   will have to set that information explicitly. Effectively
+   ``V4L2_COLORSPACE_JPEG`` can be considered to be an abbreviation for
+   ``V4L2_COLORSPACE_SRGB``, ``V4L2_YCBCR_ENC_601`` and
+   ``V4L2_QUANTIZATION_FULL_RANGE``.
diff --git a/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst b/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
index 2cfcc97b3c96..14446ed7f650 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
@@ -17,9 +17,10 @@ Description
 This format is similar to
 :ref:`V4L2_PIX_FMT_SBGGR8 <V4L2-PIX-FMT-SBGGR8>`, except each pixel
 has a depth of 16 bits. The least significant byte is stored at lower
-memory addresses (little-endian). Note the actual sampling precision may
-be lower than 16 bits, for example 10 bits per pixel with values in
-range 0 to 1023.
+memory addresses (little-endian).
+
+..note:: The actual sampling precision may be lower than 16 bits,
+    for example 10 bits per pixel with values in tange 0 to 1023.
 
 **Byte Order.**
 Each cell is one byte.
diff --git a/Documentation/media/uapi/v4l/pixfmt-y16-be.rst b/Documentation/media/uapi/v4l/pixfmt-y16-be.rst
index 0c61a10018c2..37fa099c16a6 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y16-be.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y16-be.rst
@@ -15,9 +15,10 @@ Description
 ===========
 
 This is a grey-scale image with a depth of 16 bits per pixel. The most
-significant byte is stored at lower memory addresses (big-endian). Note
-the actual sampling precision may be lower than 16 bits, for example 10
-bits per pixel with values in range 0 to 1023.
+significant byte is stored at lower memory addresses (big-endian).
+
+.. note:: Tthe actual sampling precision may be lower than 16 bits, for
+   example 10 bits per pixel with values in range 0 to 1023.
 
 **Byte Order.**
 Each cell is one byte.
diff --git a/Documentation/media/uapi/v4l/pixfmt-y16.rst b/Documentation/media/uapi/v4l/pixfmt-y16.rst
index a8d4b7192ae3..4c41c042188b 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y16.rst
@@ -16,8 +16,9 @@ Description
 
 This is a grey-scale image with a depth of 16 bits per pixel. The least
 significant byte is stored at lower memory addresses (little-endian).
-Note the actual sampling precision may be lower than 16 bits, for
-example 10 bits per pixel with values in range 0 to 1023.
+
+.. note:: The actual sampling precision may be lower than 16 bits, for
+   example 10 bits per pixel with values in range 0 to 1023.
 
 **Byte Order.**
 Each cell is one byte.
diff --git a/Documentation/media/uapi/v4l/standard.rst b/Documentation/media/uapi/v4l/standard.rst
index 529891cf3af2..9c390c2a128a 100644
--- a/Documentation/media/uapi/v4l/standard.rst
+++ b/Documentation/media/uapi/v4l/standard.rst
@@ -39,11 +39,12 @@ To query and select the standard used by the current video input or
 output applications call the :ref:`VIDIOC_G_STD <VIDIOC_G_STD>` and
 :ref:`VIDIOC_S_STD <VIDIOC_G_STD>` ioctl, respectively. The
 *received* standard can be sensed with the
-:ref:`VIDIOC_QUERYSTD` ioctl. Note that the
-parameter of all these ioctls is a pointer to a
-:ref:`v4l2_std_id <v4l2-std-id>` type (a standard set), *not* an
-index into the standard enumeration. Drivers must implement all video
-standard ioctls when the device has one or more video inputs or outputs.
+:ref:`VIDIOC_QUERYSTD` ioctl.
+
+..note:: The parameter of all these ioctls is a pointer to a
+   :ref:`v4l2_std_id <v4l2-std-id>` type (a standard set), *not* an
+   index into the standard enumeration. Drivers must implement all video
+   standard ioctls when the device has one or more video inputs or outputs.
 
 Special rules apply to devices such as USB cameras where the notion of
 video standards makes little sense. More generally for any capture or
diff --git a/Documentation/media/uapi/v4l/tuner.rst b/Documentation/media/uapi/v4l/tuner.rst
index 23d0e00aefdd..37eb4b9b95fb 100644
--- a/Documentation/media/uapi/v4l/tuner.rst
+++ b/Documentation/media/uapi/v4l/tuner.rst
@@ -26,13 +26,14 @@ To query and change tuner properties applications use the
 :ref:`VIDIOC_S_TUNER <VIDIOC_G_TUNER>` ioctls, respectively. The
 struct :ref:`v4l2_tuner <v4l2-tuner>` returned by :ref:`VIDIOC_G_TUNER <VIDIOC_G_TUNER>`
 also contains signal status information applicable when the tuner of the
-current video or radio input is queried. Note that :ref:`VIDIOC_S_TUNER <VIDIOC_G_TUNER>`
-does not switch the current tuner, when there is more than one at all.
-The tuner is solely determined by the current video input. Drivers must
-support both ioctls and set the ``V4L2_CAP_TUNER`` flag in the struct
-:ref:`v4l2_capability <v4l2-capability>` returned by the
-:ref:`VIDIOC_QUERYCAP` ioctl when the device has
-one or more tuners.
+current video or radio input is queried.
+
+.. note:: :ref:`VIDIOC_S_TUNER <VIDIOC_G_TUNER>` does not switch the
+   current tuner, when there is more than one at all. The tuner is solely
+   determined by the current video input. Drivers must support both ioctls
+   and set the ``V4L2_CAP_TUNER`` flag in the struct :ref:`v4l2_capability
+   <v4l2-capability>` returned by the :ref:`VIDIOC_QUERYCAP` ioctl when the
+   device has one or more tuners.
 
 
 Modulators
diff --git a/Documentation/media/uapi/v4l/userp.rst b/Documentation/media/uapi/v4l/userp.rst
index 0871c204dc6c..601963a33acb 100644
--- a/Documentation/media/uapi/v4l/userp.rst
+++ b/Documentation/media/uapi/v4l/userp.rst
@@ -86,13 +86,14 @@ available.
 
 To start and stop capturing or output applications call the
 :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` and
-:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctl. Note
-:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` removes all buffers from both
-queues and unlocks all buffers as a side effect. Since there is no
-notion of doing anything "now" on a multitasking system, if an
-application needs to synchronize with another event it should examine
-the struct :ref:`v4l2_buffer <v4l2-buffer>` ``timestamp`` of captured or
-outputted buffers.
+:ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` ioctl.
+
+.. note:: ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` removes all buffers from
+   both queues and unlocks all buffers as a side effect. Since there is no
+   notion of doing anything "now" on a multitasking system, if an
+   application needs to synchronize with another event it should examine
+   the struct :ref:`v4l2_buffer <v4l2-buffer>` ``timestamp`` of captured or
+   outputted buffers.
 
 Drivers implementing user pointer I/O must support the
 :ref:`VIDIOC_REQBUFS <VIDIOC_REQBUFS>`, :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`,
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
index efa911c0fb19..f7e1b80af29e 100644
--- a/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dbg-g-chip-info.rst
@@ -33,7 +33,7 @@ Arguments
 Description
 ===========
 
-    **Note**
+.. note::
 
     This is an :ref:`experimental` interface and may
     change in the future.
diff --git a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
index 345aa321f380..09d2880e6170 100644
--- a/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dbg-g-register.rst
@@ -35,7 +35,7 @@ Arguments
 Description
 ===========
 
-    **Note**
+.. note::
 
     This is an :ref:`experimental` interface and may
     change in the future.
diff --git a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
index 5a35bb254b4b..6e05957013bb 100644
--- a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
@@ -37,8 +37,10 @@ To query the capabilities of the DV receiver/transmitter applications
 initialize the ``pad`` field to 0, zero the reserved array of struct
 :ref:`v4l2_dv_timings_cap <v4l2-dv-timings-cap>` and call the
 ``VIDIOC_DV_TIMINGS_CAP`` ioctl on a video node and the driver will fill
-in the structure. Note that drivers may return different values after
-switching the video input or output.
+in the structure.
+
+.. note:: Drivers may return different values after
+   switching the video input or output.
 
 When implemented by the driver DV capabilities of subdevices can be
 queried by calling the ``VIDIOC_SUBDEV_DV_TIMINGS_CAP`` ioctl directly
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
index f0dd0c4ca7d0..3ba75d3fb93c 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-dv-timings.rst
@@ -47,8 +47,10 @@ field, set the ``pad`` field to 0, zero the reserved array of struct
 structure. Drivers fill the rest of the structure or return an ``EINVAL``
 error code when the index is out of bounds. To enumerate all supported
 DV timings, applications shall begin at index zero, incrementing by one
-until the driver returns ``EINVAL``. Note that drivers may enumerate a
-different set of DV timings after switching the video input or output.
+until the driver returns ``EINVAL``.
+
+.. note:: Drivers may enumerate a different set of DV timings after
+   switching the video input or output.
 
 When implemented by the driver DV timings of subdevices can be queried
 by calling the ``VIDIOC_SUBDEV_ENUM_DV_TIMINGS`` ioctl directly on a
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
index 257c624e27be..90996f69d6ae 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
@@ -40,8 +40,8 @@ fill the rest of the structure or return an ``EINVAL`` error code. All
 formats are enumerable by beginning at index zero and incrementing by
 one until ``EINVAL`` is returned.
 
-Note that after switching input or output the list of enumerated image
-formats may be different.
+.. note:: After switching input or output the list of enumerated image
+   formats may be different.
 
 
 .. _v4l2-fmtdesc:
@@ -111,8 +111,10 @@ formats may be different.
 	      #define v4l2_fourcc(a,b,c,d) (((__u32)(a)<<0)|((__u32)(b)<<8)|((__u32)(c)<<16)|((__u32)(d)<<24))
 
 	  Several image formats are already defined by this specification in
-	  :ref:`pixfmt`. Note these codes are not the same as those used
-	  in the Windows world.
+	  :ref:`pixfmt`.
+
+	  .. attention:: These codes are not the same as those used
+	     in the Windows world.
 
     -  .. row 7
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
index 5d5de535a0fe..ceae6003039e 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
@@ -73,25 +73,21 @@ the device supports. Only for the ``V4L2_FRMIVAL_TYPE_DISCRETE`` type
 does it make sense to increase the index value to receive more frame
 intervals.
 
-Note that the order in which the frame intervals are returned has no
-special meaning. In particular does it not say anything about potential
-default frame intervals.
+.. note:: The order in which the frame intervals are returned has no
+   special meaning. In particular does it not say anything about potential
+   default frame intervals.
 
 Applications can assume that the enumeration data does not change
 without any interaction from the application itself. This means that the
 enumeration data is consistent if the application does not perform any
 other ioctl calls while it runs the frame interval enumeration.
 
+.. note::
 
-Notes
-=====
-
--  **Frame intervals and frame rates:** The V4L2 API uses frame
+   **Frame intervals and frame rates:** The V4L2 API uses frame
    intervals instead of frame rates. Given the frame interval the frame
    rate can be computed as follows:
 
-
-
    ::
 
        frame_rate = 1 / frame_interval
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
index d3b2e97df6c9..8b268354d442 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-framesizes.rst
@@ -72,9 +72,9 @@ the ``type`` field to determine the type of frame size enumeration the
 device supports. Only for the ``V4L2_FRMSIZE_TYPE_DISCRETE`` type does
 it make sense to increase the index value to receive more frame sizes.
 
-Note that the order in which the frame sizes are returned has no special
-meaning. In particular does it not say anything about potential default
-format sizes.
+.. note:: The order in which the frame sizes are returned has no special
+   meaning. In particular does it not say anything about potential default
+   format sizes.
 
 Applications can assume that the enumeration data does not change
 without any interaction from the application itself. This means that the
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
index ea754f4f5532..00ab5e19cc1d 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
@@ -127,12 +127,14 @@ of the corresponding tuner/modulator is set.
        -  ``modulation``
 
        -  :cspan:`2` The supported modulation systems of this frequency
-	  band. See :ref:`band-modulation`. Note that currently only one
-	  modulation system per frequency band is supported. More work will
-	  need to be done if multiple modulation systems are possible.
-	  Contact the linux-media mailing list
-	  (`https://linuxtv.org/lists.php <https://linuxtv.org/lists.php>`__)
-	  if you need that functionality.
+	  band. See :ref:`band-modulation`.
+
+	  .. note:: Currently only one modulation system per frequency band
+	     is supported. More work will need to be done if multiple
+	     modulation systems are possible. Contact the linux-media
+	     mailing list
+	     (`https://linuxtv.org/lists.php <https://linuxtv.org/lists.php>`__)
+	     if you need such functionality.
 
     -  .. row 8
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst b/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
index 15bc5a40f4a6..cde1db55834f 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumaudioout.rst
@@ -41,8 +41,8 @@ structure or return an ``EINVAL`` error code when the index is out of
 bounds. To enumerate all audio outputs applications shall begin at index
 zero, incrementing by one until the driver returns ``EINVAL``.
 
-Note connectors on a TV card to loop back the received audio signal to a
-sound card are not audio outputs in this sense.
+.. note:: Connectors on a TV card to loop back the received audio signal
+    to a sound card are not audio outputs in this sense.
 
 See :ref:`VIDIOC_G_AUDIOout <VIDIOC_G_AUDOUT>` for a description of struct
 :ref:`v4l2_audioout <v4l2-audioout>`.
diff --git a/Documentation/media/uapi/v4l/vidioc-enuminput.rst b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
index c1fc2e1f1d98..5060f54e3d18 100644
--- a/Documentation/media/uapi/v4l/vidioc-enuminput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
@@ -233,8 +233,8 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
 
        -  The input is connected to a device that produces a signal that is
 	  flipped vertically and does not correct this before passing the
-	  signal to userspace. Note that a 180 degree rotation is the same
-	  as HFLIP | VFLIP
+	  signal to userspace.
+	  .. note:: A 180 degree rotation is the same as HFLIP | VFLIP
 
     -  .. row 8
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
index bee5f78ed7c1..b1c1bfeb251e 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-audioout.rst
@@ -51,8 +51,8 @@ return the ``EINVAL`` error code when the index is out of bounds. This is a
 write-only ioctl, it does not return the current audio output attributes
 as ``VIDIOC_G_AUDOUT`` does.
 
-Note connectors on a TV card to loop back the received audio signal to a
-sound card are not audio outputs in this sense.
+.. note:: Connectors on a TV card to loop back the received audio signal
+   to a sound card are not audio outputs in this sense.
 
 
 .. _v4l2-audioout:
diff --git a/Documentation/media/uapi/v4l/vidioc-g-edid.rst b/Documentation/media/uapi/v4l/vidioc-g-edid.rst
index 907b2c1764a3..1a982b68a72f 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-edid.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-edid.rst
@@ -65,8 +65,10 @@ If ``start_block`` and ``blocks`` are both set to 0 when
 :ref:`VIDIOC_G_EDID <VIDIOC_G_EDID>` is called, then the driver will set ``blocks`` to the
 total number of available EDID blocks and it will return 0 without
 copying any data. This is an easy way to discover how many EDID blocks
-there are. Note that if there are no EDID blocks available at all, then
-the driver will set ``blocks`` to 0 and it returns 0.
+there are.
+
+.. note:: If there are no EDID blocks available at all, then
+   the driver will set ``blocks`` to 0 and it returns 0.
 
 To set the EDID blocks of a receiver the application has to fill in the
 ``pad``, ``blocks`` and ``edid`` fields, set ``start_block`` to 0 and
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index 96b6eaca755c..39e24ad4b825 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -125,10 +125,12 @@ still cause this situation.
 	  the payload. If :ref:`VIDIOC_G_EXT_CTRLS <VIDIOC_G_EXT_CTRLS>` finds that this value is
 	  less than is required to store the payload result, then it is set
 	  to a value large enough to store the payload result and ``ENOSPC`` is
-	  returned. Note that for string controls this ``size`` field should
-	  not be confused with the length of the string. This field refers
-	  to the size of the memory that contains the string. The actual
-	  *length* of the string may well be much smaller.
+	  returned.
+
+	  .. note:: For string controls, this ``size`` field should
+	     not be confused with the length of the string. This field refers
+	     to the size of the memory that contains the string. The actual
+	     *length* of the string may well be much smaller.
 
     -  .. row 3
 
@@ -261,8 +263,10 @@ still cause this situation.
        -  Which value of the control to get/set/try.
 	  ``V4L2_CTRL_WHICH_CUR_VAL`` will return the current value of the
 	  control and ``V4L2_CTRL_WHICH_DEF_VAL`` will return the default
-	  value of the control. Please note that you can only get the
-	  default value of the control, you cannot set or try it.
+	  value of the control.
+
+	  .. note:: You can only get the default value of the control,
+	     you cannot set or try it.
 
 	  For backwards compatibility you can also use a control class here
 	  (see :ref:`ctrl-class`). In that case all controls have to
diff --git a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
index 05d83610bdc5..a2e8c73f0678 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
@@ -128,12 +128,14 @@ To change the radio frequency the
 
        -  With this field applications can determine how audio sub-carriers
 	  shall be modulated. It contains a set of flags as defined in
-	  :ref:`modulator-txsubchans`. Note the tuner ``rxsubchans`` flags
-	  are reused, but the semantics are different. Video output devices
-	  are assumed to have an analog or PCM audio input with 1-3
-	  channels. The ``txsubchans`` flags select one or more channels for
-	  modulation, together with some audio subprogram indicator, for
-	  example a stereo pilot tone.
+	  :ref:`modulator-txsubchans`.
+
+	  .. note:: The tuner ``rxsubchans`` flags  are reused, but the
+	     semantics are different. Video output devices
+	     are assumed to have an analog or PCM audio input with 1-3
+	     channels. The ``txsubchans`` flags select one or more channels
+	     for modulation, together with some audio subprogram indicator,
+	     for example, a stereo pilot tone.
 
     -  .. row 7
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
index 76dd4ba3254f..f1f661d0200c 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -40,8 +40,8 @@ output device, applications initialize the ``type`` field of a struct
 driver fills in the remaining fields or returns an ``EINVAL`` error code if
 the sliced VBI API is unsupported or ``type`` is invalid.
 
-Note the ``type`` field was added, and the ioctl changed from read-only
-to write-read, in Linux 2.6.19.
+.. note:: The ``type`` field was added, and the ioctl changed from read-only
+   to write-read, in Linux 2.6.19.
 
 
 .. _v4l2-sliced-vbi-cap:
diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
index a8d7ebd73e8a..c82085513bee 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
@@ -391,9 +391,9 @@ To change the radio frequency the
 	  carrier for a monaural secondary language. Only
 	  ``V4L2_TUNER_ANALOG_TV`` tuners can have this capability.
 
-	  Note the ``V4L2_TUNER_CAP_LANG2`` and ``V4L2_TUNER_CAP_SAP`` flags
-	  are synonyms. ``V4L2_TUNER_CAP_SAP`` applies when the tuner
-	  supports the ``V4L2_STD_NTSC_M`` video standard.
+	  .. note:: The ``V4L2_TUNER_CAP_LANG2`` and ``V4L2_TUNER_CAP_SAP``
+	     flags are synonyms. ``V4L2_TUNER_CAP_SAP`` applies when the tuner
+	     supports the ``V4L2_STD_NTSC_M`` video standard.
 
     -  .. row 9
 
@@ -500,10 +500,11 @@ To change the radio frequency the
 
        -  0x0004
 
-       -  The tuner receives a Second Audio Program. Note the
-	  ``V4L2_TUNER_SUB_LANG2`` and ``V4L2_TUNER_SUB_SAP`` flags are
-	  synonyms. The ``V4L2_TUNER_SUB_SAP`` flag applies when the current
-	  video standard is ``V4L2_STD_NTSC_M``.
+       -  The tuner receives a Second Audio Program.
+
+	  .. note:: The ``V4L2_TUNER_SUB_LANG2`` and ``V4L2_TUNER_SUB_SAP``
+	     flags are synonyms. The ``V4L2_TUNER_SUB_SAP`` flag applies
+	     when the current video standard is ``V4L2_STD_NTSC_M``.
 
     -  .. row 6
 
@@ -578,9 +579,10 @@ To change the radio frequency the
        -  Play the Second Audio Program. When the tuner receives no
 	  bilingual audio or SAP, or their reception is not supported the
 	  driver shall fall back to mono or stereo mode. Only
-	  ``V4L2_TUNER_ANALOG_TV`` tuners support this mode. Note the
-	  ``V4L2_TUNER_MODE_LANG2`` and ``V4L2_TUNER_MODE_SAP`` are
-	  synonyms.
+	  ``V4L2_TUNER_ANALOG_TV`` tuners support this mode.
+
+	  .. note:: The ``V4L2_TUNER_MODE_LANG2`` and ``V4L2_TUNER_MODE_SAP``
+	     are synonyms.
 
     -  .. row 6
 
diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
index 9870d243131a..3b927f36fb5b 100644
--- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
@@ -135,14 +135,15 @@ EINVAL
 
 EIO
     ``VIDIOC_DQBUF`` failed due to an internal error. Can also indicate
-    temporary problems like signal loss. Note the driver might dequeue
-    an (empty) buffer despite returning an error, or even stop
-    capturing. Reusing such buffer may be unsafe though and its details
-    (e.g. ``index``) may not be returned either. It is recommended that
-    drivers indicate recoverable errors by setting the
-    ``V4L2_BUF_FLAG_ERROR`` and returning 0 instead. In that case the
-    application should be able to safely reuse the buffer and continue
-    streaming.
+    temporary problems like signal loss.
+
+    .. note:: The driver might dequeue an (empty) buffer despite returning
+       an error, or even stop capturing. Reusing such buffer may be unsafe
+       though and its details (e.g. ``index``) may not be returned either.
+       It is recommended that drivers indicate recoverable errors by setting
+       the ``V4L2_BUF_FLAG_ERROR`` and returning 0 instead. In that case the
+       application should be able to safely reuse the buffer and continue
+       streaming.
 
 EPIPE
     ``VIDIOC_DQBUF`` returns this on an empty capture queue for mem2mem
diff --git a/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
index 338b80df5b9b..416d8d604af4 100644
--- a/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-query-dv-timings.rst
@@ -39,16 +39,16 @@ similar to sensing the video standard. To do so, applications call
 :ref:`v4l2_dv_timings <v4l2-dv-timings>`. Once the hardware detects
 the timings, it will fill in the timings structure.
 
-Please note that drivers shall *not* switch timings automatically if new
-timings are detected. Instead, drivers should send the
-``V4L2_EVENT_SOURCE_CHANGE`` event (if they support this) and expect
-that userspace will take action by calling :ref:`VIDIOC_QUERY_DV_TIMINGS`.
-The reason is that new timings usually mean different buffer sizes as
-well, and you cannot change buffer sizes on the fly. In general,
-applications that receive the Source Change event will have to call
-:ref:`VIDIOC_QUERY_DV_TIMINGS`, and if the detected timings are valid they
-will have to stop streaming, set the new timings, allocate new buffers
-and start streaming again.
+.. note:: Drivers shall *not* switch timings automatically if new
+   timings are detected. Instead, drivers should send the
+   ``V4L2_EVENT_SOURCE_CHANGE`` event (if they support this) and expect
+   that userspace will take action by calling :ref:`VIDIOC_QUERY_DV_TIMINGS`.
+   The reason is that new timings usually mean different buffer sizes as
+   well, and you cannot change buffer sizes on the fly. In general,
+   applications that receive the Source Change event will have to call
+   :ref:`VIDIOC_QUERY_DV_TIMINGS`, and if the detected timings are valid they
+   will have to stop streaming, set the new timings, allocate new buffers
+   and start streaming again.
 
 If the timings could not be detected because there was no signal, then
 ENOLINK is returned. If a signal was detected, but it was unstable and
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index 0f27e712eec9..4342aceddd57 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -82,10 +82,12 @@ fills the rest of the structure or returns an ``EINVAL`` error code when the
 ``id`` or ``index`` is invalid. Menu items are enumerated by calling
 ``VIDIOC_QUERYMENU`` with successive ``index`` values from struct
 :ref:`v4l2_queryctrl <v4l2-queryctrl>` ``minimum`` to ``maximum``,
-inclusive. Note that it is possible for ``VIDIOC_QUERYMENU`` to return
-an ``EINVAL`` error code for some indices between ``minimum`` and
-``maximum``. In that case that particular menu item is not supported by
-this driver. Also note that the ``minimum`` value is not necessarily 0.
+inclusive.
+
+.. note:: It is possible for ``VIDIOC_QUERYMENU`` to return
+   an ``EINVAL`` error code for some indices between ``minimum`` and
+   ``maximum``. In that case that particular menu item is not supported by
+   this driver. Also note that the ``minimum`` value is not necessarily 0.
 
 See also the examples in :ref:`control`.
 
@@ -184,9 +186,10 @@ See also the examples in :ref:`control`.
 
        -  The default value of a ``V4L2_CTRL_TYPE_INTEGER``, ``_BOOLEAN``,
 	  ``_BITMASK``, ``_MENU`` or ``_INTEGER_MENU`` control. Not valid
-	  for other types of controls. Note that drivers reset controls to
-	  their default value only when the driver is first loaded, never
-	  afterwards.
+	  for other types of controls.
+
+	  .. note:: Drivers reset controls to their default value only when
+	     the driver is first loaded, never afterwards.
 
     -  .. row 8
 
@@ -301,9 +304,10 @@ See also the examples in :ref:`control`.
 
        -  The default value of a ``V4L2_CTRL_TYPE_INTEGER``, ``_INTEGER64``,
 	  ``_BOOLEAN``, ``_BITMASK``, ``_MENU``, ``_INTEGER_MENU``, ``_U8``
-	  or ``_U16`` control. Not valid for other types of controls. Note
-	  that drivers reset controls to their default value only when the
-	  driver is first loaded, never afterwards.
+	  or ``_U16`` control. Not valid for other types of controls.
+
+	  .. note:: Drivers reset controls to their default value only when
+	     the driver is first loaded, never afterwards.
 
     -  .. row 8
 
@@ -722,11 +726,12 @@ See also the examples in :ref:`control`.
 	  control changes continuously. A typical example would be the
 	  current gain value if the device is in auto-gain mode. In such a
 	  case the hardware calculates the gain value based on the lighting
-	  conditions which can change over time. Note that setting a new
-	  value for a volatile control will have no effect and no
-	  ``V4L2_EVENT_CTRL_CH_VALUE`` will be sent, unless the
-	  ``V4L2_CTRL_FLAG_EXECUTE_ON_WRITE`` flag (see below) is also set.
-	  Otherwise the new value will just be ignored.
+	  conditions which can change over time.
+
+	  .. note:: Setting a new value for a volatile control will have no
+	     effect and no ``V4L2_EVENT_CTRL_CH_VALUE`` will be sent, unless
+	     the ``V4L2_CTRL_FLAG_EXECUTE_ON_WRITE`` flag (see below) is
+	     also set. Otherwise the new value will just be ignored.
 
     -  .. row 9
 
diff --git a/Documentation/media/uapi/v4l/vidioc-querystd.rst b/Documentation/media/uapi/v4l/vidioc-querystd.rst
index 5bf62775c740..b4a4e222c7b0 100644
--- a/Documentation/media/uapi/v4l/vidioc-querystd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querystd.rst
@@ -43,16 +43,16 @@ will return V4L2_STD_UNKNOWN. When detection is not possible or fails,
 the set must contain all standards supported by the current video input
 or output.
 
-Please note that drivers shall *not* switch the video standard
-automatically if a new video standard is detected. Instead, drivers
-should send the ``V4L2_EVENT_SOURCE_CHANGE`` event (if they support
-this) and expect that userspace will take action by calling
-:ref:`VIDIOC_QUERYSTD`. The reason is that a new video standard can mean
-different buffer sizes as well, and you cannot change buffer sizes on
-the fly. In general, applications that receive the Source Change event
-will have to call :ref:`VIDIOC_QUERYSTD`, and if the detected video
-standard is valid they will have to stop streaming, set the new
-standard, allocate new buffers and start streaming again.
+.. note:: Drivers shall *not* switch the video standard
+   automatically if a new video standard is detected. Instead, drivers
+   should send the ``V4L2_EVENT_SOURCE_CHANGE`` event (if they support
+   this) and expect that userspace will take action by calling
+   :ref:`VIDIOC_QUERYSTD`. The reason is that a new video standard can mean
+   different buffer sizes as well, and you cannot change buffer sizes on
+   the fly. In general, applications that receive the Source Change event
+   will have to call :ref:`VIDIOC_QUERYSTD`, and if the detected video
+   standard is valid they will have to stop streaming, set the new
+   standard, allocate new buffers and start streaming again.
 
 
 Return Value
diff --git a/Documentation/media/uapi/v4l/vidioc-streamon.rst b/Documentation/media/uapi/v4l/vidioc-streamon.rst
index e87500e608e1..bb23745ebcaf 100644
--- a/Documentation/media/uapi/v4l/vidioc-streamon.rst
+++ b/Documentation/media/uapi/v4l/vidioc-streamon.rst
@@ -76,10 +76,10 @@ then 0 is returned. Nothing happens in the case of ``VIDIOC_STREAMON``,
 but ``VIDIOC_STREAMOFF`` will return queued buffers to their starting
 state as mentioned above.
 
-Note that applications can be preempted for unknown periods right before
-or after the ``VIDIOC_STREAMON`` or ``VIDIOC_STREAMOFF`` calls, there is
-no notion of starting or stopping "now". Buffer timestamps can be used
-to synchronize with other events.
+.. note:: Applications can be preempted for unknown periods right before
+   or after the ``VIDIOC_STREAMON`` or ``VIDIOC_STREAMOFF`` calls, there is
+   no notion of starting or stopping "now". Buffer timestamps can be used
+   to synchronize with other events.
 
 
 Return Value
diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
index 690034a391d3..ae802f1594e7 100644
--- a/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-crop.rst
@@ -35,7 +35,7 @@ Arguments
 Description
 ===========
 
-    **Note**
+.. note::
 
     This is an :ref:`obsolete` interface and may be removed
     in the future. It is superseded by
diff --git a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
index a027f602de3d..3ed91c627702 100644
--- a/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
+++ b/Documentation/media/uapi/v4l/vidioc-subscribe-event.rst
@@ -51,9 +51,11 @@ using the :ref:`VIDIOC_DQEVENT` ioctl.
 
        -  ``type``
 
-       -  Type of the event, see :ref:`event-type`. Note that
-	  ``V4L2_EVENT_ALL`` can be used with VIDIOC_UNSUBSCRIBE_EVENT for
-	  unsubscribing all events at once.
+       -  Type of the event, see :ref:`event-type`.
+
+	  .. note:: ``V4L2_EVENT_ALL`` can be used with
+	     :ref:`VIDIOC_UNSUBSCRIBE_EVENT` for unsubscribing all events
+	     at once.
 
     -  .. row 2
 
-- 
2.7.4

