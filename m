Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:45252 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751353AbdABMPy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jan 2017 07:15:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH for v4.10 1/2] cec rst: remove "This API is not yet finalized" notice
Date: Mon,  2 Jan 2017 13:15:44 +0100
Message-Id: <1483359345-24652-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1483359345-24652-1-git-send-email-hverkuil@xs4all.nl>
References: <1483359345-24652-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

The API is now finalized, so this notice should be dropped.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 Documentation/media/uapi/cec/cec-func-close.rst           | 5 -----
 Documentation/media/uapi/cec/cec-func-ioctl.rst           | 5 -----
 Documentation/media/uapi/cec/cec-func-open.rst            | 5 -----
 Documentation/media/uapi/cec/cec-func-poll.rst            | 5 -----
 Documentation/media/uapi/cec/cec-intro.rst                | 5 -----
 Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst      | 5 -----
 Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst | 5 -----
 Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst | 5 -----
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst          | 5 -----
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst           | 5 -----
 Documentation/media/uapi/cec/cec-ioc-receive.rst          | 5 -----
 11 files changed, 55 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-func-close.rst b/Documentation/media/uapi/cec/cec-func-close.rst
index 8267c31..895d9c2 100644
--- a/Documentation/media/uapi/cec/cec-func-close.rst
+++ b/Documentation/media/uapi/cec/cec-func-close.rst
@@ -33,11 +33,6 @@ Arguments
 Description
 ===========
 
-.. note::
-
-   This documents the proposed CEC API. This API is not yet finalized
-   and is currently only available as a staging kernel module.
-
 Closes the cec device. Resources associated with the file descriptor are
 freed. The device configuration remain unchanged.
 
diff --git a/Documentation/media/uapi/cec/cec-func-ioctl.rst b/Documentation/media/uapi/cec/cec-func-ioctl.rst
index 9e8dbb1..7dcfd17 100644
--- a/Documentation/media/uapi/cec/cec-func-ioctl.rst
+++ b/Documentation/media/uapi/cec/cec-func-ioctl.rst
@@ -39,11 +39,6 @@ Arguments
 Description
 ===========
 
-.. note::
-
-   This documents the proposed CEC API. This API is not yet finalized
-   and is currently only available as a staging kernel module.
-
 The :c:func:`ioctl()` function manipulates cec device parameters. The
 argument ``fd`` must be an open file descriptor.
 
diff --git a/Documentation/media/uapi/cec/cec-func-open.rst b/Documentation/media/uapi/cec/cec-func-open.rst
index af3f5b5..0304388 100644
--- a/Documentation/media/uapi/cec/cec-func-open.rst
+++ b/Documentation/media/uapi/cec/cec-func-open.rst
@@ -46,11 +46,6 @@ Arguments
 Description
 ===========
 
-.. note::
-
-   This documents the proposed CEC API. This API is not yet finalized
-   and is currently only available as a staging kernel module.
-
 To open a cec device applications call :c:func:`open()` with the
 desired device name. The function has no side effects; the device
 configuration remain unchanged.
diff --git a/Documentation/media/uapi/cec/cec-func-poll.rst b/Documentation/media/uapi/cec/cec-func-poll.rst
index cfb73e6..6a863cf 100644
--- a/Documentation/media/uapi/cec/cec-func-poll.rst
+++ b/Documentation/media/uapi/cec/cec-func-poll.rst
@@ -39,11 +39,6 @@ Arguments
 Description
 ===========
 
-.. note::
-
-   This documents the proposed CEC API. This API is not yet finalized
-   and is currently only available as a staging kernel module.
-
 With the :c:func:`poll()` function applications can wait for CEC
 events.
 
diff --git a/Documentation/media/uapi/cec/cec-intro.rst b/Documentation/media/uapi/cec/cec-intro.rst
index 4a19ea5..7d31d37 100644
--- a/Documentation/media/uapi/cec/cec-intro.rst
+++ b/Documentation/media/uapi/cec/cec-intro.rst
@@ -3,11 +3,6 @@
 Introduction
 ============
 
-.. note::
-
-   This documents the proposed CEC API. This API is not yet finalized
-   and is currently only available as a staging kernel module.
-
 HDMI connectors provide a single pin for use by the Consumer Electronics
 Control protocol. This protocol allows different devices connected by an
 HDMI cable to communicate. The protocol for CEC version 1.4 is defined
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index 2b0ddb1..a0e961f 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -29,11 +29,6 @@ Arguments
 Description
 ===========
 
-.. note::
-
-   This documents the proposed CEC API. This API is not yet finalized
-   and is currently only available as a staging kernel module.
-
 All cec devices must support :ref:`ioctl CEC_ADAP_G_CAPS <CEC_ADAP_G_CAPS>`. To query
 device information, applications call the ioctl with a pointer to a
 struct :c:type:`cec_caps`. The driver fills the structure and
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
index b878637..09f09bb 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-log-addrs.rst
@@ -35,11 +35,6 @@ Arguments
 Description
 ===========
 
-.. note::
-
-   This documents the proposed CEC API. This API is not yet finalized
-   and is currently only available as a staging kernel module.
-
 To query the current CEC logical addresses, applications call
 :ref:`ioctl CEC_ADAP_G_LOG_ADDRS <CEC_ADAP_G_LOG_ADDRS>` with a pointer to a
 struct :c:type:`cec_log_addrs` where the driver stores the logical addresses.
diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
index 3357deb..a3cdc75 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-phys-addr.rst
@@ -35,11 +35,6 @@ Arguments
 Description
 ===========
 
-.. note::
-
-   This documents the proposed CEC API. This API is not yet finalized
-   and is currently only available as a staging kernel module.
-
 To query the current physical address applications call
 :ref:`ioctl CEC_ADAP_G_PHYS_ADDR <CEC_ADAP_G_PHYS_ADDR>` with a pointer to a __u16 where the
 driver stores the physical address.
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index e256c66..6e589a1 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -30,11 +30,6 @@ Arguments
 Description
 ===========
 
-.. note::
-
-   This documents the proposed CEC API. This API is not yet finalized
-   and is currently only available as a staging kernel module.
-
 CEC devices can send asynchronous events. These can be retrieved by
 calling :c:func:`CEC_DQEVENT`. If the file descriptor is in
 non-blocking mode and no event is pending, then it will return -1 and
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index 4f5818b..e4ded9d 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -31,11 +31,6 @@ Arguments
 Description
 ===========
 
-.. note::
-
-   This documents the proposed CEC API. This API is not yet finalized
-   and is currently only available as a staging kernel module.
-
 By default any filehandle can use :ref:`CEC_TRANSMIT`, but in order to prevent
 applications from stepping on each others toes it must be possible to
 obtain exclusive access to the CEC adapter. This ioctl sets the
diff --git a/Documentation/media/uapi/cec/cec-ioc-receive.rst b/Documentation/media/uapi/cec/cec-ioc-receive.rst
index bdf015b..dc2adb3 100644
--- a/Documentation/media/uapi/cec/cec-ioc-receive.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-receive.rst
@@ -34,11 +34,6 @@ Arguments
 Description
 ===========
 
-.. note::
-
-   This documents the proposed CEC API. This API is not yet finalized
-   and is currently only available as a staging kernel module.
-
 To receive a CEC message the application has to fill in the
 ``timeout`` field of struct :c:type:`cec_msg` and pass it to
 :ref:`ioctl CEC_RECEIVE <CEC_RECEIVE>`.
-- 
2.8.1

