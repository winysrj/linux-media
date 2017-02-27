Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:33665 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751441AbdB0OYy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 09:24:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/9] cec: document the error codes
Date: Mon, 27 Feb 2017 15:20:38 +0100
Message-Id: <20170227142042.37085-6-hverkuil@xs4all.nl>
In-Reply-To: <20170227142042.37085-1-hverkuil@xs4all.nl>
References: <20170227142042.37085-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document all the various error codes returned by the CEC ioctls.

These were never documented, instead the documentation relied on a reference
to the generic error codes, but that's not sufficient.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    | 13 ++++++++
 .../media/uapi/cec/cec-ioc-adap-g-phys-addr.rst    | 13 ++++++++
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   | 11 +++++++
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst    | 12 +++++++
 Documentation/media/uapi/cec/cec-ioc-receive.rst   | 37 ++++++++++++++++++++++
 5 files changed, 86 insertions(+)

diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index 09f09bbe28d4..fcf863ab6f43 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -351,3 +351,16 @@ On success 0 is returned, on error -1 and the ``errno`` variable is set
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
index a3cdc75cec3e..9e49d4be35d5 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
@@ -78,3 +78,16 @@ Return Value
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
index 89ef6c1a2e42..4d3570c2e0b3 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -174,3 +174,14 @@ Return Value
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
index e4ded9df0a84..664f0d47bbcd 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -249,3 +249,15 @@ Return Value
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
index f8a28c303ade..3ce7307f55fa 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -289,3 +289,40 @@ Return Value
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
+EPERM
+    The CEC adapter is not configured, i.e. :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
+    has never been called.
+
+ENONET
+    The CEC adapter is not configured, i.e. :ref:`ioctl CEC_ADAP_S_LOG_ADDRS <CEC_ADAP_S_LOG_ADDRS>`
+    was called, but the physical address is invalid so no logical address was claimed.
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
-- 
2.11.0
