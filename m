Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:43536 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069AbcGQQMk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 12:12:40 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 300BF180C37
	for <linux-media@vger.kernel.org>; Sun, 17 Jul 2016 18:12:35 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] doc-rst: cec: update documentation
Message-ID: <1670ce76-1ae7-ca6a-5956-2a612b997c63@xs4all.nl>
Date: Sun, 17 Jul 2016 18:12:34 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update and expand the CEC documentation. Especially w.r.t. non-blocking mode.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
This depends on https://patchwork.linuxtv.org/patch/35506/.
---
diff --git a/Documentation/media/uapi/cec/cec-func-open.rst b/Documentation/media/uapi/cec/cec-func-open.rst
index cbf1176..38fd7e0 100644
--- a/Documentation/media/uapi/cec/cec-func-open.rst
+++ b/Documentation/media/uapi/cec/cec-func-open.rst
@@ -32,12 +32,12 @@ Arguments
     Open flags. Access mode must be ``O_RDWR``.

     When the ``O_NONBLOCK`` flag is given, the
-    :ref:`CEC_RECEIVE <CEC_RECEIVE>` ioctl will return the EAGAIN
-    error code when no message is available, and ioctls
-    :ref:`CEC_TRANSMIT <CEC_TRANSMIT>`,
+    :ref:`CEC_RECEIVE <CEC_RECEIVE>` and :ref:`CEC_DQEVENT <CEC_DQEVENT>` ioctls
+    will return the ``EAGAIN`` error code when no message or event is available, and
+    ioctls :ref:`CEC_TRANSMIT <CEC_TRANSMIT>`,
     :ref:`CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>` and
     :ref:`CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
-    all act in non-blocking mode.
+    all return 0.

     Other flags have no effect.

diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index eab734e..05a4d68 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -45,10 +45,24 @@ To query the current CEC logical addresses, applications call
 To set new logical addresses, applications fill in
 :c:type:`struct cec_log_addrs` and call :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
 with a pointer to this struct. The :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
-is only available if ``CEC_CAP_LOG_ADDRS`` is set (ENOTTY error code is
-returned otherwise). This ioctl will block until all requested logical
-addresses have been claimed. The :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>` can only be called
-by a file handle in initiator mode (see :ref:`CEC_S_MODE`).
+is only available if ``CEC_CAP_LOG_ADDRS`` is set (the ``ENOTTY`` error code is
+returned otherwise). The :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
+can only be called by a file descriptor in initiator mode (see :ref:`CEC_S_MODE`), if not
+the ``EBUSY`` error code will be returned.
+
+To clear existing logical addresses set ``num_log_addrs`` to 0. All other fields
+will be ignored in that case. The adapter will go to the unconfigured state.
+
+If the physical address is valid (see :ref:`ioctl CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>`),
+then this ioctl will block until all requested logical
+addresses have been claimed. If the file descriptor is in non-blocking mode then it will
+not wait for the logical addresses to be claimed, instead it just returns 0.
+
+A :ref:`CEC_EVENT_STATE_CHANGE <CEC-EVENT-STATE-CHANGE>` event is sent when the
+logical addresses are claimed or cleared.
+
+Attempting to call :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>` when
+logical address types are already defined will return with error ``EBUSY``.


 .. _cec-log-addrs:
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
index 07a92d4..b955d04 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
@@ -44,10 +44,21 @@ driver stores the physical address.
 To set a new physical address applications store the physical address in
 a __u16 and call :ref:`ioctl CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>` with a pointer to
 this integer. The :ref:`ioctl CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>` is only available if
-``CEC_CAP_PHYS_ADDR`` is set (ENOTTY error code will be returned
-otherwise). The :ref:`ioctl CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>` can only be called by a file handle
-in initiator mode (see :ref:`CEC_S_MODE`), if not
-EBUSY error code will be returned.
+``CEC_CAP_PHYS_ADDR`` is set (the ``ENOTTY`` error code will be returned
+otherwise). The :ref:`ioctl CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>` can only be called
+by a file descriptor in initiator mode (see :ref:`CEC_S_MODE`), if not
+the ``EBUSY`` error code will be returned.
+
+To clear an existing physical address use ``CEC_PHYS_ADDR_INVALID``.
+The adapter will go to the unconfigured state.
+
+If logical address types have been defined (see :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`),
+then this ioctl will block until all
+requested logical addresses have been claimed. If the file descriptor is in non-blocking mode
+then it will not wait for the logical addresses to be claimed, instead it just returns 0.
+
+A :ref:`CEC_EVENT_STATE_CHANGE <CEC-EVENT-STATE-CHANGE>` event is sent when the physical address
+changes.

 The physical address is a 16-bit number where each group of 4 bits
 represent a digit of the physical address a.b.c.d where the most
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index 2785a4c..8c2b0c1 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -38,7 +38,7 @@ Description
 CEC devices can send asynchronous events. These can be retrieved by
 calling :ref:`ioctl CEC_DQEVENT <CEC_DQEVENT>`. If the file descriptor is in
 non-blocking mode and no event is pending, then it will return -1 and
-set errno to the EAGAIN error code.
+set errno to the ``EAGAIN`` error code.

 The internal event queues are per-filehandle and per-event type. If
 there is no more room in a queue then the last event is overwritten with
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index d071108..f0084d8 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -108,7 +108,7 @@ Available initiator modes are:
        -  This is an exclusive initiator and this file descriptor is the
 	  only one that can transmit CEC messages and make changes to the
 	  CEC adapter. If someone else is already the exclusive initiator
-	  then an attempt to become one will return the EBUSY error code
+	  then an attempt to become one will return the ``EBUSY`` error code
 	  error.


@@ -140,7 +140,7 @@ Available follower modes are:
        -  This is a follower and it will receive CEC messages unless there
 	  is an exclusive follower. You cannot become a follower if
 	  :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>` is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`
-	  was specified, EINVAL error code is returned in that case.
+	  was specified, the ``EINVAL`` error code is returned in that case.

     -  .. _`CEC-MODE-EXCL-FOLLOWER`:

@@ -151,9 +151,9 @@ Available follower modes are:
        -  This is an exclusive follower and only this file descriptor will
 	  receive CEC messages for processing. If someone else is already
 	  the exclusive follower then an attempt to become one will return
-	  the EBUSY error code error. You cannot become a follower if
+	  the ``EBUSY`` error code. You cannot become a follower if
 	  :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>` is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`
-	  was specified, EINVAL error code is returned in that case.
+	  was specified, the ``EINVAL`` error code is returned in that case.

     -  .. _`CEC-MODE-EXCL-FOLLOWER-PASSTHRU`:

@@ -166,10 +166,10 @@ Available follower modes are:
 	  CEC device into passthrough mode, allowing the exclusive follower
 	  to handle most core messages instead of relying on the CEC
 	  framework for that. If someone else is already the exclusive
-	  follower then an attempt to become one will return the EBUSY error
-	  code error. You cannot become a follower if :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>`
-	  is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>` was specified, EINVAL
-	  error code is returned in that case.
+	  follower then an attempt to become one will return the ``EBUSY`` error
+	  code. You cannot become a follower if :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>`
+	  is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>` was specified,
+	  the ``EINVAL`` error code is returned in that case.

     -  .. _`CEC-MODE-MONITOR`:

@@ -184,7 +184,7 @@ Available follower modes are:
 	  messages and directed messages for one its logical addresses) will
 	  be reported. This is very useful for debugging. This is only
 	  allowed if the process has the ``CAP_NET_ADMIN`` capability. If
-	  that is not set, then EPERM error code is returned.
+	  that is not set, then the ``EPERM`` error code is returned.

     -  .. _`CEC-MODE-MONITOR-ALL`:

@@ -193,15 +193,15 @@ Available follower modes are:
        -  0xf0

        -  Put the file descriptor into 'monitor all' mode. Can only be used
-	  in combination with :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`, otherwise EINVAL
-	  error code will be returned. In 'monitor all' mode all messages
+	  in combination with :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`, otherwise
+	  the ``EINVAL`` error code will be returned. In 'monitor all' mode all messages
 	  this CEC device transmits and all messages it receives, including
 	  directed messages for other CEC devices will be reported. This is
 	  very useful for debugging, but not all devices support this. This
 	  mode requires that the :ref:`CEC_CAP_MONITOR_ALL <CEC-CAP-MONITOR-ALL>` capability is set,
-	  otherwise EINVAL error code is returned. This is only allowed if
+	  otherwise the ``EINVAL`` error code is returned. This is only allowed if
 	  the process has the ``CAP_NET_ADMIN`` capability. If that is not
-	  set, then EPERM error code is returned.
+	  set, then the ``EPERM`` error code is returned.


 Core message processing details:
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index 3faec51..ec56efd 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -37,19 +37,38 @@ Description
    and is currently only available as a staging kernel module.

 To receive a CEC message the application has to fill in the
-:c:type:`struct cec_msg` and pass it to :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`.
-The :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>` is only available if ``CEC_CAP_RECEIVE`` is set.
+``timeout`` field of :c:type:`struct cec_msg` and pass it to :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`.
 If the file descriptor is in non-blocking mode and there are no received
-messages pending, then it will return -1 and set errno to the EAGAIN
+messages pending, then it will return -1 and set errno to the ``EAGAIN``
 error code. If the file descriptor is in blocking mode and ``timeout``
 is non-zero and no message arrived within ``timeout`` milliseconds, then
-it will return -1 and set errno to the ETIMEDOUT error code.
+it will return -1 and set errno to the ``ETIMEDOUT`` error code.
+
+A received message can be:
+
+1. a message received from another CEC device (the ``sequence`` field will
+   be 0).
+2. the result of an earlier non-blocking transmit (the ``sequence`` field will
+   be non-zero).

 To send a CEC message the application has to fill in the
 :c:type:`struct cec_msg` and pass it to
 :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>`. The :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` is only available if
 ``CEC_CAP_TRANSMIT`` is set. If there is no more room in the transmit
-queue, then it will return -1 and set errno to the EBUSY error code.
+queue, then it will return -1 and set errno to the ``EBUSY`` error code.
+The transmit queue has enough room for 18 messages (about 1 second worth
+of 2-byte messages). Note that the CEC kernel framework will also reply
+to core messages (see :ref:cec-core-processing), so it is not a good
+idea to fully fill up the transmit queue.
+
+If the file descriptor is in non-blocking mode then the transmit will
+return 0 and the result of the transmit will be available via
+:ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>` once the transmit has finished
+(including waiting for a reply, if requested).
+
+The ``sequence`` field is filled in for every transmit and this can be
+checked against the received messages to find the corresponding transmit
+result.


 .. _cec-msg:
@@ -106,10 +125,11 @@ queue, then it will return -1 and set errno to the EBUSY error code.

        -  ``sequence``

-       -  The sequence number is automatically assigned by the CEC framework
-	  for all transmitted messages. It can be later used by the
-	  framework to generate an event if a reply for a message was
-	  requested and the message was transmitted in a non-blocking mode.
+       -  A non-zero sequence number is automatically assigned by the CEC framework
+	  for all transmitted messages. It is used by the CEC framework when it queues
+	  the transmit result (when transmit was called in non-blocking mode). This
+	  allows the application to associate the received message with the original
+	  transmit.

     -  .. row 6

@@ -148,14 +168,13 @@ queue, then it will return -1 and set errno to the EBUSY error code.

        -  Wait until this message is replied. If ``reply`` is 0 and the
 	  ``timeout`` is 0, then don't wait for a reply but return after
-	  transmitting the message. If there was an error as indicated by the
-	  ``tx_status`` field, then ``reply`` and ``timeout`` are
-	  both set to 0 by the driver. Ignored by :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`. The case
-	  where ``reply`` is 0 (this is the opcode for the Feature Abort
-	  message) and ``timeout`` is non-zero is specifically allowed to
-	  send a message and wait up to ``timeout`` milliseconds for a
+	  transmitting the message. Ignored by :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`.
+	  The case where ``reply`` is 0 (this is the opcode for the Feature Abort
+	  message) and ``timeout`` is non-zero is specifically allowed to make it
+	  possible to send a message and wait up to ``timeout`` milliseconds for a
 	  Feature Abort reply. In this case ``rx_status`` will either be set
-	  to :ref:`CEC_RX_STATUS_TIMEOUT <CEC-RX-STATUS-TIMEOUT>` or :ref:`CEC_RX_STATUS_FEATURE_ABORT <CEC-RX-STATUS-FEATURE-ABORT>`.
+	  to :ref:`CEC_RX_STATUS_TIMEOUT <CEC-RX-STATUS-TIMEOUT>` or
+	  :ref:`CEC_RX_STATUS_FEATURE_ABORT <CEC-RX-STATUS-FEATURE-ABORT>`.

     -  .. row 9

