Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:58745 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751240AbdBTUV0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 15:21:26 -0500
To: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec rst: document the error codes
Message-ID: <7ed9da5a-bb37-8439-4ef6-83f4cd88bad7@xs4all.nl>
Date: Mon, 20 Feb 2017 12:21:19 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document all the various error codes returned by the CEC ioctls.

These were never documented, instead the documentation relied on a reference
to the generic error codes, but that's not sufficient.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index b878637..3faf9c5 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -356,3 +356,16 @@ On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
 
+The :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>` can return the following
+error codes:
+
+ENOTTY
+    The ``CEC_CAP_LOG_ADDRS`` capability wasn't set, so this ioctl is not supported.
+
+EBUSY
+    The CEC adapter is currently configuring itself, or it is already configured and
+    ``num_log_addrs`` is non-zero, or another filehandle is in exclusive follower or
+    initiator mode, or the filehandle is in mode ``CEC_MODE_NO_INITIATOR``.
+
+EINVAL
+    The contents of struct :c:type:`cec_log_addrs` is invalid.
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
index 3357deb..8dfd84d 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
@@ -83,3 +83,16 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
+
+The :ref:`ioctl CEC_ADAP_S_PHYS_ADDR <CEC_ADAP_S_PHYS_ADDR>` can return the following
+error codes:
+
+ENOTTY
+    The ``CEC_CAP_PHYS_ADDR`` capability wasn't set, so this ioctl is not supported.
+
+EBUSY
+    Another filehandle is in exclusive follower or initiator mode, or the filehandle
+    is in mode ``CEC_MODE_NO_INITIATOR``.
+
+EINVAL
+    The physical address is malformed.
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index e256c66..728364e 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -179,3 +179,14 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
+
+The :ref:`ioctl CEC_DQEVENT <CEC_DQEVENT>` can return the following
+error codes:
+
+EAGAIN
+    This is returned when the filehandle is in non-blocking mode and there
+    are no pending events.
+
+ERESTARTSYS
+    An interrupt (e.g. Ctrl-C) arrived while in blocking mode waiting for
+    events to arrive.
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index 4f5818b..67fba88 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -254,3 +254,15 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
+
+The :ref:`ioctl CEC_S_MODE <CEC_S_MODE>` can return the following
+error codes:
+
+EINVAL
+    The requested mode is invalid.
+
+EPERM
+    Monitor mode is requested without having root permissions
+
+EBUSY
+    Someone else is already an exclusive follower or initiator.
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index bdf015b..30cbcc9 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -294,3 +294,35 @@ Return Value
 On success 0 is returned, on error -1 and the ``errno`` variable is set
 appropriately. The generic error codes are described at the
 :ref:`Generic Error Codes <gen-errors>` chapter.
+
+The :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>` can return the following
+error codes:
+
+EAGAIN
+    No messages are in the receive queue, and the filehandle is in non-blocking mode.
+
+ETIMEDOUT
+    The ``timeout`` was reached while waiting for a message.
+
+ERESTARTSYS
+    The wait for a message was interrupted (e.g. by Ctrl-C).
+
+The :ref:`ioctl CEC_TRANSMIT <CEC_TRANSMIT>` can return the following
+error codes:
+
+ENOTTY
+    The ``CEC_CAP_TRANSMIT`` capability wasn't set, so this ioctl is not supported.
+
+ENONET
+    The CEC adapter is not configured.
+
+EBUSY
+    Another filehandle is in exclusive follower or initiator mode, or the filehandle
+    is in mode ``CEC_MODE_NO_INITIATOR``. This is also returned if the transmit
+    queue is full.
+
+EINVAL
+    The contents of struct :c:type:`cec_msg` is invalid.
+
+ERESTARTSYS
+    The wait for a successful transmit was interrupted (e.g. by Ctrl-C).
