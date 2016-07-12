Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:44495 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbcGLSIB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 14:08:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] doc-rst: improve CEC documentation
Date: Tue, 12 Jul 2016 20:07:45 +0200
Message-Id: <1468346865-36465-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468346865-36465-1-git-send-email-hverkuil@xs4all.nl>
References: <1468346865-36465-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Lots of fixups relating to references.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/cec/cec-func-ioctl.rst    |  2 +-
 Documentation/media/uapi/cec/cec-func-open.rst     | 10 +++----
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         | 18 ++++++------
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    | 14 ++++-----
 .../media/uapi/cec/cec-ioc-adap-g-phys-addr.rst    | 14 ++++-----
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |  2 +-
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    | 34 +++++++++-------------
 Documentation/media/uapi/cec/cec-ioc-receive.rst   | 28 +++++++++---------
 8 files changed, 58 insertions(+), 64 deletions(-)

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
index 2ca9199..63b808e 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -34,7 +34,7 @@ Description
 .. note:: This documents the proposed CEC API. This API is not yet finalized
    and is currently only available as a staging kernel module.
 
-All cec devices must support the :ref:`CEC_ADAP_G_CAPS` ioctl. To query
+All cec devices must support ``CEC_ADAP_G_CAPS``. To query
 device information, applications call the ioctl with a pointer to a
 struct :ref:`cec_caps <cec-caps>`. The driver fills the structure and
 returns the information to the application. The ioctl never fails.
@@ -99,8 +99,8 @@ returns the information to the application. The ioctl never fails.
 
        -  0x00000001
 
-       -  Userspace has to configure the physical address by calling
-	  :ref:`CEC_ADAP_S_PHYS_ADDR`. If
+       -  Userspace has to configure the physical address by calling ioctl
+	  :ref:`CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>`. If
 	  this capability isn't set, then setting the physical address is
 	  handled by the kernel whenever the EDID is set (for an HDMI
 	  receiver) or read (for an HDMI transmitter).
@@ -111,8 +111,8 @@ returns the information to the application. The ioctl never fails.
 
        -  0x00000002
 
-       -  Userspace has to configure the logical addresses by calling
-	  :ref:`CEC_ADAP_S_LOG_ADDRS`. If
+       -  Userspace has to configure the logical addresses by calling ioctl
+	  :ref:`CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`. If
 	  this capability isn't set, then the kernel will have configured
 	  this.
 
@@ -122,8 +122,8 @@ returns the information to the application. The ioctl never fails.
 
        -  0x00000004
 
-       -  Userspace can transmit CEC messages by calling
-	  :ref:`CEC_TRANSMIT`. This implies that
+       -  Userspace can transmit CEC messages by calling ioctl
+	  :ref:`CEC_TRANSMIT <CEC_TRANSMIT>`. This implies that
 	  userspace can be a follower as well, since being able to transmit
 	  messages is a prerequisite of becoming a follower. If this
 	  capability isn't set, then the kernel will handle all CEC
@@ -135,8 +135,8 @@ returns the information to the application. The ioctl never fails.
 
        -  0x00000008
 
-       -  Userspace can use the passthrough mode by calling
-	  :ref:`CEC_S_MODE`.
+       -  Userspace can use the passthrough mode by calling ioctl
+	  :ref:`CEC_S_MODE <CEC_S_MODE>`.
 
     -  .. _`CEC-CAP-RC`:
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 7d7a3b4..d082830 100644
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
@@ -39,16 +39,16 @@ Description
    and is currently only available as a staging kernel module.
 
 To query the current CEC logical addresses, applications call the
-:ref:`CEC_ADAP_G_LOG_ADDRS` ioctl with a pointer to a
+``CEC_ADAP_G_LOG_ADDRS`` ioctl with a pointer to a
 :c:type:`struct cec_log_addrs` structure where the drivers stores
 the logical addresses.
 
 To set new logical addresses, applications fill in struct
-:c:type:`struct cec_log_addrs` and call the :ref:`CEC_ADAP_S_LOG_ADDRS`
-ioctl with a pointer to this struct. The :ref:`CEC_ADAP_S_LOG_ADDRS` ioctl
+:c:type:`struct cec_log_addrs` and call the ``CEC_ADAP_S_LOG_ADDRS`` ioctl
+with a pointer to this struct. The ``CEC_ADAP_S_LOG_ADDRS`` ioctl
 is only available if ``CEC_CAP_LOG_ADDRS`` is set (ENOTTY error code is
 returned otherwise). This ioctl will block until all requested logical
-addresses have been claimed. :ref:`CEC_ADAP_S_LOG_ADDRS` can only be called
+addresses have been claimed. The ``CEC_ADAP_S_LOG_ADDRS`` ioctl can only be called
 by a file handle in initiator mode (see
 :ref:`CEC_S_MODE`).
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
index 58aaba6..3a4d25a 100644
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
@@ -38,14 +38,14 @@ Description
    and is currently only available as a staging kernel module.
 
 To query the current physical address applications call the
-:ref:`CEC_ADAP_G_PHYS_ADDR` ioctl with a pointer to an __u16 where the
+``CEC_ADAP_G_PHYS_ADDR`` ioctl with a pointer to an __u16 where the
 driver stores the physical address.
 
 To set a new physical address applications store the physical address in
-an __u16 and call the :ref:`CEC_ADAP_S_PHYS_ADDR` ioctl with a pointer to
-this integer. :ref:`CEC_ADAP_S_PHYS_ADDR` is only available if
+an __u16 and call the ``CEC_ADAP_S_PHYS_ADDR`` ioctl with a pointer to
+this integer. The ``CEC_ADAP_S_PHYS_ADDR`` ioctl is only available if
 ``CEC_CAP_PHYS_ADDR`` is set (ENOTTY error code will be returned
-otherwise). :ref:`CEC_ADAP_S_PHYS_ADDR` can only be called by a file handle
+otherwise). The ``CEC_ADAP_S_PHYS_ADDR`` ioctl can only be called by a file handle
 in initiator mode (see :ref:`CEC_S_MODE`), if not
 EBUSY error code will be returned.
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index 681201f..136baa6 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -36,7 +36,7 @@ Description
    and is currently only available as a staging kernel module.
 
 CEC devices can send asynchronous events. These can be retrieved by
-calling the :ref:`CEC_DQEVENT` ioctl. If the file descriptor is in
+calling the ``CEC_DQEVENT`` ioctl. If the file descriptor is in
 non-blocking mode and no event is pending, then it will return -1 and
 set errno to the EAGAIN error code.
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index c5a0fc4..7b1a364 100644
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
+follower who will use ioctl :ref:`CEC_RECEIVE <CEC_RECEIVE>` to dequeue
 the new message. The framework expects the follower to make the right
 decisions.
 
@@ -66,10 +64,10 @@ There are some messages that the core will always process, regardless of
 the passthrough mode. See :ref:`cec-core-processing` for details.
 
 If there is no initiator, then any CEC filehandle can use
-:ref:`CEC_TRANSMIT`. If there is an exclusive
+:ref:`CEC_TRANSMIT <CEC_TRANSMIT>`. If there is an exclusive
 initiator then only that initiator can call
 :ref:`CEC_TRANSMIT`. The follower can of course
-always call :ref:`CEC_TRANSMIT`.
+always call :ref:`CEC_TRANSMIT <CEC_TRANSMIT>`.
 
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
+	  set with ioctl :ref:`CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`.
 
     -  .. _`CEC-MSG-GIVE-DEVICE-VENDOR-ID`:
 
@@ -232,8 +229,7 @@ Core message processing details:
 
        -  When in passthrough mode this message has to be handled by
 	  userspace, otherwise the core will return the vendor ID that was
-	  set with
-	  :ref:`CEC_ADAP_S_LOG_ADDRS`.
+	  set with ioctl :ref:`CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`.
 
     -  .. _`CEC-MSG-ABORT`:
 
@@ -257,8 +253,7 @@ Core message processing details:
 
        -  When in passthrough mode this message has to be handled by
 	  userspace, otherwise the core will report the current OSD name as
-	  was set with
-	  :ref:`CEC_ADAP_S_LOG_ADDRS`.
+	  was set with ioctl :ref:`CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`.
 
     -  .. _`CEC-MSG-GIVE-FEATURES`:
 
@@ -266,9 +261,8 @@ Core message processing details:
 
        -  When in passthrough mode this message has to be handled by
 	  userspace, otherwise the core will report the current features as
-	  was set with
-	  :ref:`CEC_ADAP_S_LOG_ADDRS` or
-	  the message is ignore if the CEC version was older than 2.0.
+	  was set with ioctl :ref:`CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
+	  or the message is ignored if the CEC version was older than 2.0.
 
     -  .. _`CEC-MSG-USER-CONTROL-PRESSED`:
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 34382af..d24eca8 100644
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
+:c:type:`struct cec_msg` structure and pass it to the ``CEC_RECEIVE``
+ioctl. ``CEC_RECEIVE`` is only available if ``CEC_CAP_RECEIVE`` is set.
 If the file descriptor is in non-blocking mode and there are no received
 messages pending, then it will return -1 and set errno to the EAGAIN
 error code. If the file descriptor is in blocking mode and ``timeout``
@@ -47,7 +47,7 @@ it will return -1 and set errno to the ETIMEDOUT error code.
 
 To send a CEC message the application has to fill in the
 :c:type:`struct cec_msg` structure and pass it to the
-:ref:`CEC_TRANSMIT` ioctl. :ref:`CEC_TRANSMIT` is only available if
+``CEC_TRANSMIT`` ioctl. ``CEC_TRANSMIT`` is only available if
 ``CEC_CAP_TRANSMIT`` is set. If there is no more room in the transmit
 queue, then it will return -1 and set errno to the EBUSY error code.
 
@@ -82,9 +82,9 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 
        -  ``len``
 
-       -  The length of the message. For :ref:`CEC_TRANSMIT` this is filled in
+       -  The length of the message. For ``CEC_TRANSMIT`` this is filled in
 	  by the application. The driver will fill this in for
-	  :ref:`CEC_RECEIVE` and for :ref:`CEC_TRANSMIT` it will be filled in with
+	  ``CEC_RECEIVE`` and for ``CEC_TRANSMIT`` it will be filled in with
 	  the length of the reply message if ``reply`` was set.
 
     -  .. row 4
@@ -96,7 +96,7 @@ queue, then it will return -1 and set errno to the EBUSY error code.
        -  The timeout in milliseconds. This is the time the device will wait
 	  for a message to be received before timing out. If it is set to 0,
 	  then it will wait indefinitely when it is called by
-	  :ref:`CEC_RECEIVE`. If it is 0 and it is called by :ref:`CEC_TRANSMIT`,
+	  ``CEC_RECEIVE``. If it is 0 and it is called by ``CEC_TRANSMIT``,
 	  then it will be replaced by 1000 if the ``reply`` is non-zero or
 	  ignored if ``reply`` is 0.
 
@@ -125,9 +125,9 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 
        -  ``msg``\ [16]
 
-       -  The message payload. For :ref:`CEC_TRANSMIT` this is filled in by the
-	  application. The driver will fill this in for :ref:`CEC_RECEIVE` and
-	  for :ref:`CEC_TRANSMIT` it will be filled in with the payload of the
+       -  The message payload. For ``CEC_TRANSMIT`` this is filled in by the
+	  application. The driver will fill this in for ``CEC_RECEIVE`` and
+	  for ``CEC_TRANSMIT`` it will be filled in with the payload of the
 	  reply message if ``reply`` was set.
 
     -  .. row 8
@@ -140,12 +140,12 @@ queue, then it will return -1 and set errno to the EBUSY error code.
 	  ``timeout`` is 0, then don't wait for a reply but return after
 	  transmitting the message. If there was an error as indicated by the
 	  ``tx_status`` field, then ``reply`` and ``timeout`` are
-	  both set to 0 by the driver. Ignored by :ref:`CEC_RECEIVE`. The case
+	  both set to 0 by the driver. Ignored by ``CEC_RECEIVE``. The case
 	  where ``reply`` is 0 (this is the opcode for the Feature Abort
 	  message) and ``timeout`` is non-zero is specifically allowed to
 	  send a message and wait up to ``timeout`` milliseconds for a
 	  Feature Abort reply. In this case ``rx_status`` will either be set
-	  to :ref:`CEC_RX_STATUS_TIMEOUT <CEC-RX-STATUS-TIMEOUT>` or :ref:`CEC_RX_STATUS-FEATURE-ABORT <CEC-RX-STATUS-FEATURE-ABORT>`.
+	  to :ref:`CEC_RX_STATUS_TIMEOUT <CEC-RX-STATUS-TIMEOUT>` or :ref:`CEC_RX_STATUS_FEATURE_ABORT <CEC-RX-STATUS-FEATURE-ABORT>`.
 
     -  .. row 9
 
-- 
2.8.1

