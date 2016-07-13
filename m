Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:56647 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbcGMLtL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 07:49:11 -0400
Received: from [64.103.36.133] (proxy-ams-1.cisco.com [64.103.36.133])
	by tschai.lan (Postfix) with ESMTPSA id 9135E180C37
	for <linux-media@vger.kernel.org>; Wed, 13 Jul 2016 13:48:55 +0200 (CEST)
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2] doc-rst: improve CEC documentation
Message-ID: <57862AA6.3080906@xs4all.nl>
Date: Wed, 13 Jul 2016 13:48:54 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lots of fixups relating to references.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Changes since v1:

- Always use refs for ioctls
---
diff --git a/Documentation/media/uapi/cec/cec-func-ioctl.rst b/Documentation/media/uapi/cec/cec-func-ioctl.rst
index a07cc7c..d0279e6d 100644
--- a/Documentation/media/uapi/cec/cec-func-ioctl.rst
+++ b/Documentation/media/uapi/cec/cec-func-ioctl.rst
@@ -29,7 +29,7 @@ Arguments

 ``request``
     CEC ioctl request code as defined in the cec.h header file, for
-    example CEC_ADAP_G_CAPS.
+    example :ref:`CEC_ADAP_G_CAPS`.

 ``argp``
     Pointer to a request-specific structure.
diff --git a/Documentation/media/uapi/cec/cec-func-open.rst b/Documentation/media/uapi/cec/cec-func-open.rst
index 245d679..cbf1176 100644
--- a/Documentation/media/uapi/cec/cec-func-open.rst
+++ b/Documentation/media/uapi/cec/cec-func-open.rst
@@ -32,11 +32,11 @@ Arguments
     Open flags. Access mode must be ``O_RDWR``.

     When the ``O_NONBLOCK`` flag is given, the
-    :ref:`CEC_RECEIVE` ioctl will return EAGAIN
-    error code when no message is available, and the
-    :ref:`CEC_TRANSMIT`,
-    :ref:`CEC_ADAP_S_PHYS_ADDR` and
-    :ref:`CEC_ADAP_S_LOG_ADDRS` ioctls
+    :ref:`CEC_RECEIVE <CEC_RECEIVE>` ioctl will return the EAGAIN
+    error code when no message is available, and ioctls
+    :ref:`CEC_TRANSMIT <CEC_TRANSMIT>`,
+    :ref:`CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>` and
+    :ref:`CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
     all act in non-blocking mode.

     Other flags have no effect.
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index 2ca9199..eaedc63 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -34,7 +34,7 @@ Description
 .. note:: This documents the proposed CEC API. This API is not yet finalized
    and is currently only available as a staging kernel module.

-All cec devices must support the :ref:`CEC_ADAP_G_CAPS` ioctl. To query
+All cec devices must support :ref:`ioctl CEC_ADAP_G_CAPS <CEC_ADAP_G_CAPS>`. To query
 device information, applications call the ioctl with a pointer to a
 struct :ref:`cec_caps <cec-caps>`. The driver fills the structure and
 returns the information to the application. The ioctl never fails.
@@ -100,7 +100,7 @@ returns the information to the application. The ioctl never fails.
        -  0x00000001

        -  Userspace has to configure the physical address by calling
-	  :ref:`CEC_ADAP_S_PHYS_ADDR`. If
+	  :ref:`ioctl CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>`. If
 	  this capability isn't set, then setting the physical address is
 	  handled by the kernel whenever the EDID is set (for an HDMI
 	  receiver) or read (for an HDMI transmitter).
@@ -112,7 +112,7 @@ returns the information to the application. The ioctl never fails.
        -  0x00000002

        -  Userspace has to configure the logical addresses by calling
-	  :ref:`CEC_ADAP_S_LOG_ADDRS`. If
+	  :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`. If
 	  this capability isn't set, then the kernel will have configured
 	  this.

@@ -123,7 +123,7 @@ returns the information to the application. The ioctl never fails.
        -  0x00000004

        -  Userspace can transmit CEC messages by calling
-	  :ref:`CEC_TRANSMIT`. This implies that
+	  :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>`. This implies that
 	  userspace can be a follower as well, since being able to transmit
 	  messages is a prerequisite of becoming a follower. If this
 	  capability isn't set, then the kernel will handle all CEC
@@ -136,7 +136,7 @@ returns the information to the application. The ioctl never fails.
        -  0x00000008

        -  Userspace can use the passthrough mode by calling
-	  :ref:`CEC_S_MODE`.
+	  :ref:`ioctl CEC_S_MODE <CEC_S_MODE>`.

     -  .. _`CEC-CAP-RC`:

diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 7d7a3b4..eab734e 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -4,9 +4,9 @@
 .. _CEC_ADAP_G_LOG_ADDRS:
 .. _CEC_ADAP_S_LOG_ADDRS:

-************************************************
-ioctl CEC_ADAP_G_LOG_ADDRS, CEC_ADAP_S_LOG_ADDRS
-************************************************
+****************************************************
+ioctls CEC_ADAP_G_LOG_ADDRS and CEC_ADAP_S_LOG_ADDRS
+****************************************************

 Name
 ====
@@ -38,19 +38,17 @@ Description
 .. note:: This documents the proposed CEC API. This API is not yet finalized
    and is currently only available as a staging kernel module.

-To query the current CEC logical addresses, applications call the
-:ref:`CEC_ADAP_G_LOG_ADDRS` ioctl with a pointer to a
-:c:type:`struct cec_log_addrs` structure where the drivers stores
-the logical addresses.
+To query the current CEC logical addresses, applications call
+:ref:`ioctl CEC_ADAP_G_LOG_ADDRS <CEC_ADAP_G_LOG_ADDRS>` with a pointer to a
+:c:type:`struct cec_log_addrs` where the driver stores the logical addresses.

-To set new logical addresses, applications fill in struct
-:c:type:`struct cec_log_addrs` and call the :ref:`CEC_ADAP_S_LOG_ADDRS`
-ioctl with a pointer to this struct. The :ref:`CEC_ADAP_S_LOG_ADDRS` ioctl
+To set new logical addresses, applications fill in
+:c:type:`struct cec_log_addrs` and call :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
+with a pointer to this struct. The :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
 is only available if ``CEC_CAP_LOG_ADDRS`` is set (ENOTTY error code is
 returned otherwise). This ioctl will block until all requested logical
-addresses have been claimed. :ref:`CEC_ADAP_S_LOG_ADDRS` can only be called
-by a file handle in initiator mode (see
-:ref:`CEC_S_MODE`).
+addresses have been claimed. The :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>` can only be called
+by a file handle in initiator mode (see :ref:`CEC_S_MODE`).


 .. _cec-log-addrs:
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
index 58aaba6..07a92d4 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
@@ -4,9 +4,9 @@
 .. _CEC_ADAP_G_PHYS_ADDR:
 .. _CEC_ADAP_S_PHYS_ADDR:

-************************************************
-ioctl CEC_ADAP_G_PHYS_ADDR, CEC_ADAP_S_PHYS_ADDR
-************************************************
+****************************************************
+ioctls CEC_ADAP_G_PHYS_ADDR and CEC_ADAP_S_PHYS_ADDR
+****************************************************

 Name
 ====
@@ -37,15 +37,15 @@ Description
 .. note:: This documents the proposed CEC API. This API is not yet finalized
    and is currently only available as a staging kernel module.

-To query the current physical address applications call the
-:ref:`CEC_ADAP_G_PHYS_ADDR` ioctl with a pointer to an __u16 where the
+To query the current physical address applications call
+:ref:`ioctl CEC_ADAP_G_PHYS_ADDR <CEC_ADAP_G_PHYS_ADDR>` with a pointer to a __u16 where the
 driver stores the physical address.

 To set a new physical address applications store the physical address in
-an __u16 and call the :ref:`CEC_ADAP_S_PHYS_ADDR` ioctl with a pointer to
-this integer. :ref:`CEC_ADAP_S_PHYS_ADDR` is only available if
+a __u16 and call :ref:`ioctl CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>` with a pointer to
+this integer. The :ref:`ioctl CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>` is only available if
 ``CEC_CAP_PHYS_ADDR`` is set (ENOTTY error code will be returned
-otherwise). :ref:`CEC_ADAP_S_PHYS_ADDR` can only be called by a file handle
+otherwise). The :ref:`ioctl CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>` can only be called by a file handle
 in initiator mode (see :ref:`CEC_S_MODE`), if not
 EBUSY error code will be returned.

diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index 681201f..0fdd4af 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -36,7 +36,7 @@ Description
    and is currently only available as a staging kernel module.

 CEC devices can send asynchronous events. These can be retrieved by
-calling the :ref:`CEC_DQEVENT` ioctl. If the file descriptor is in
+calling :ref:`ioctl CEC_DQEVENT <CEC_DQEVENT>`. If the file descriptor is in
 non-blocking mode and no event is pending, then it will return -1 and
 set errno to the EAGAIN error code.

@@ -45,7 +45,7 @@ there is no more room in a queue then the last event is overwritten with
 the new one. This means that intermediate results can be thrown away but
 that the latest event is always available. This also means that is it
 possible to read two successive events that have the same value (e.g.
-two CEC_EVENT_STATE_CHANGE events with the same state). In that case
+two :ref:`CEC_EVENT_STATE_CHANGE <CEC_EVENT_STATE_CHANGE>` events with the same state). In that case
 the intermediate state changes were lost but it is guaranteed that the
 state did change in between the two events.

diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index c5a0fc4..d071108 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -4,9 +4,9 @@
 .. _CEC_G_MODE:
 .. _CEC_S_MODE:

-****************************
-ioctl CEC_G_MODE, CEC_S_MODE
-****************************
+********************************
+ioctls CEC_G_MODE and CEC_S_MODE
+********************************

 CEC_G_MODE, CEC_S_MODE - Get or set exclusive use of the CEC adapter

@@ -33,9 +33,7 @@ Description
 .. note:: This documents the proposed CEC API. This API is not yet finalized
    and is currently only available as a staging kernel module.

-By default any filehandle can use
-:ref:`CEC_TRANSMIT` and
-:ref:`CEC_RECEIVE`, but in order to prevent
+By default any filehandle can use :ref:`CEC_TRANSMIT`, but in order to prevent
 applications from stepping on each others toes it must be possible to
 obtain exclusive access to the CEC adapter. This ioctl sets the
 filehandle to initiator and/or follower mode which can be exclusive
@@ -54,7 +52,7 @@ If the message is not a reply, then the CEC framework will process it
 first. If there is no follower, then the message is just discarded and a
 feature abort is sent back to the initiator if the framework couldn't
 process it. If there is a follower, then the message is passed on to the
-follower who will use :ref:`CEC_RECEIVE` to dequeue
+follower who will use :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>` to dequeue
 the new message. The framework expects the follower to make the right
 decisions.

@@ -66,10 +64,10 @@ There are some messages that the core will always process, regardless of
 the passthrough mode. See :ref:`cec-core-processing` for details.

 If there is no initiator, then any CEC filehandle can use
-:ref:`CEC_TRANSMIT`. If there is an exclusive
+:ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>`. If there is an exclusive
 initiator then only that initiator can call
 :ref:`CEC_TRANSMIT`. The follower can of course
-always call :ref:`CEC_TRANSMIT`.
+always call :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>`.

 Available initiator modes are:

@@ -141,7 +139,7 @@ Available follower modes are:

        -  This is a follower and it will receive CEC messages unless there
 	  is an exclusive follower. You cannot become a follower if
-	  :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>` is not set or if :ref:`CEC-MODE-NO-INITIATOR <CEC-MODE-NO-INITIATOR>`
+	  :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>` is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`
 	  was specified, EINVAL error code is returned in that case.

     -  .. _`CEC-MODE-EXCL-FOLLOWER`:
@@ -154,7 +152,7 @@ Available follower modes are:
 	  receive CEC messages for processing. If someone else is already
 	  the exclusive follower then an attempt to become one will return
 	  the EBUSY error code error. You cannot become a follower if
-	  :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>` is not set or if :ref:`CEC-MODE-NO-INITIATOR <CEC-MODE-NO-INITIATOR>`
+	  :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>` is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`
 	  was specified, EINVAL error code is returned in that case.

     -  .. _`CEC-MODE-EXCL-FOLLOWER-PASSTHRU`:
@@ -223,8 +221,7 @@ Core message processing details:

        -  When in passthrough mode this message has to be handled by
 	  userspace, otherwise the core will return the CEC version that was
-	  set with
-	  :ref:`CEC_ADAP_S_LOG_ADDRS`.
+	  set with :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`.

     -  .. _`CEC-MSG-GIVE-DEVICE-VENDOR-ID`:

@@ -232,8 +229,7 @@ Core message processing details:

        -  When in passthrough mode this message has to be handled by
 	  userspace, otherwise the core will return the vendor ID that was
-	  set with
-	  :ref:`CEC_ADAP_S_LOG_ADDRS`.
+	  set with :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`.

     -  .. _`CEC-MSG-ABORT`:

@@ -257,8 +253,7 @@ Core message processing details:

        -  When in passthrough mode this message has to be handled by
 	  userspace, otherwise the core will report the current OSD name as
-	  was set with
-	  :ref:`CEC_ADAP_S_LOG_ADDRS`.
+	  was set with :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`.

     -  .. _`CEC-MSG-GIVE-FEATURES`:

@@ -266,9 +261,8 @@ Core message processing details:

        -  When in passthrough mode this message has to be handled by
 	  userspace, otherwise the core will report the current features as
-	  was set with
-	  :ref:`CEC_ADAP_S_LOG_ADDRS` or
-	  the message is ignore if the CEC version was older than 2.0.
+	  was set with :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
+	  or the message is ignored if the CEC version was older than 2.0.

     -  .. _`CEC-MSG-USER-CONTROL-PRESSED`:

diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 34382af..f981987 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -3,9 +3,9 @@
 .. _CEC_TRANSMIT:
 .. _CEC_RECEIVE:

-*******************************
-ioctl CEC_RECEIVE, CEC_TRANSMIT
-*******************************
+***********************************
+ioctls CEC_RECEIVE and CEC_TRANSMIT
+***********************************

 Name
 ====
@@ -37,8 +37,8 @@ Description
    and is currently only available as a staging kernel module.

 To receive a CEC message the application has to fill in the
-:c:type:`struct cec_msg` structure and pass it to the :ref:`CEC_RECEIVE`
-ioctl. :ref:`CEC_RECEIVE` is only available if ``CEC_CAP_RECEIVE`` is set.
+:c:type:`struct cec_msg` and pass it to :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`.
+The :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>` is only available if ``CEC_CAP_RECEIVE`` is set.
 If the file descriptor is in non-blocking mode and there are no received
 messages pending, then it will return -1 and set errno to the EAGAIN
 error code. If the file descriptor is in blocking mode and ``timeout``
@@ -46,8 +46,8 @@ is non-zero and no message arrived within ``timeout`` milliseconds, then
 it will return -1 and set errno to the ETIMEDOUT error code.

 To send a CEC message the application has to fill in the
-:c:type:`struct cec_msg` structure and pass it to the
-:ref:`CEC_TRANSMIT` ioctl. :ref:`CEC_TRANSMIT` is only available if
+:c:type:`struct cec_msg` and pass it to
+:ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>`. The :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` is only available if
 ``CEC_CAP_TRANSMIT`` is set. If there is no more room in the transmit
 queue, then it will return -1 and set errno to the EBUSY error code.

@@ -82,10 +82,10 @@ queue, then it will return -1 and set errno to the EBUSY error code.

        -  ``len``

-       -  The length of the message. For :ref:`CEC_TRANSMIT` this is filled in
+       -  The length of the message. For :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` this is filled in
 	  by the application. The driver will fill this in for
-	  :ref:`CEC_RECEIVE` and for :ref:`CEC_TRANSMIT` it will be filled in with
-	  the length of the reply message if ``reply`` was set.
+	  :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`. For :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` it will be
+	  filled in by the driver with the length of the reply message if ``reply`` was set.

     -  .. row 4

@@ -95,8 +95,8 @@ queue, then it will return -1 and set errno to the EBUSY error code.

        -  The timeout in milliseconds. This is the time the device will wait
 	  for a message to be received before timing out. If it is set to 0,
-	  then it will wait indefinitely when it is called by
-	  :ref:`CEC_RECEIVE`. If it is 0 and it is called by :ref:`CEC_TRANSMIT`,
+	  then it will wait indefinitely when it is called by :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`.
+	  If it is 0 and it is called by :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>`,
 	  then it will be replaced by 1000 if the ``reply`` is non-zero or
 	  ignored if ``reply`` is 0.

@@ -125,10 +125,10 @@ queue, then it will return -1 and set errno to the EBUSY error code.

        -  ``msg``\ [16]

-       -  The message payload. For :ref:`CEC_TRANSMIT` this is filled in by the
-	  application. The driver will fill this in for :ref:`CEC_RECEIVE` and
-	  for :ref:`CEC_TRANSMIT` it will be filled in with the payload of the
-	  reply message if ``reply`` was set.
+       -  The message payload. For :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` this is filled in by the
+	  application. The driver will fill this in for :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`.
+	  For :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` it will be filled in by the driver with
+	  the payload of the reply message if ``timeout`` was set.

     -  .. row 8

@@ -140,12 +140,12 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 	  ``timeout`` is 0, then don't wait for a reply but return after
 	  transmitting the message. If there was an error as indicated by the
 	  ``tx_status`` field, then ``reply`` and ``timeout`` are
-	  both set to 0 by the driver. Ignored by :ref:`CEC_RECEIVE`. The case
+	  both set to 0 by the driver. Ignored by :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`. The case
 	  where ``reply`` is 0 (this is the opcode for the Feature Abort
 	  message) and ``timeout`` is non-zero is specifically allowed to
 	  send a message and wait up to ``timeout`` milliseconds for a
 	  Feature Abort reply. In this case ``rx_status`` will either be set
-	  to :ref:`CEC_RX_STATUS_TIMEOUT <CEC-RX-STATUS-TIMEOUT>` or :ref:`CEC_RX_STATUS-FEATURE-ABORT <CEC-RX-STATUS-FEATURE-ABORT>`.
+	  to :ref:`CEC_RX_STATUS_TIMEOUT <CEC-RX-STATUS-TIMEOUT>` or :ref:`CEC_RX_STATUS_FEATURE_ABORT <CEC-RX-STATUS-FEATURE-ABORT>`.

     -  .. row 9

