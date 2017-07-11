Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:54588 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755262AbdGKGav (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 02:30:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 07/11] cec: document the new CEC pin capability, events and mode
Date: Tue, 11 Jul 2017 08:30:40 +0200
Message-Id: <20170711063044.29849-8-hverkuil@xs4all.nl>
In-Reply-To: <20170711063044.29849-1-hverkuil@xs4all.nl>
References: <20170711063044.29849-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document CEC_CAP_MONITOR_PIN, CEC_EVENT_PIN_LOW/HIGH,
CEC_EVENT_FL_DROPPED_EVENTS and CEC_MODE_MONITOR_PIN.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst |  7 +++++++
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst     | 20 ++++++++++++++++++++
 Documentation/media/uapi/cec/cec-ioc-g-mode.rst      | 19 +++++++++++++++++--
 3 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index 6d7bf7bef3eb..882d6e025747 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -121,6 +121,13 @@ returns the information to the application. The ioctl never fails.
         high. This makes it impossible to use CEC to wake up displays that
 	set the HPD pin low when in standby mode, but keep the CEC bus
 	alive.
+    * .. _`CEC-CAP-MONITOR-PIN`:
+
+      - ``CEC_CAP_MONITOR_PIN``
+      - 0x00000080
+      - The CEC hardware can monitor CEC pin changes from low to high voltage
+        and vice versa. When in pin monitoring mode the application will
+	receive ``CEC_EVENT_PIN_LOW`` and ``CEC_EVENT_PIN_HIGH`` events.
 
 
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index 4d3570c2e0b3..3e2cd5fefd38 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -146,6 +146,20 @@ it is guaranteed that the state did change in between the two events.
       - 2
       - Generated if one or more CEC messages were lost because the
 	application didn't dequeue CEC messages fast enough.
+    * .. _`CEC-EVENT-PIN-LOW`:
+
+      - ``CEC_EVENT_PIN_LOW``
+      - 3
+      - Generated if the CEC pin goes from a high voltage to a low voltage.
+        Only applies to adapters that have the ``CEC_CAP_MONITOR_PIN``
+	capability set.
+    * .. _`CEC-EVENT-PIN-HIGH`:
+
+      - ``CEC_EVENT_PIN_HIGH``
+      - 4
+      - Generated if the CEC pin goes from a low voltage to a high voltage.
+        Only applies to adapters that have the ``CEC_CAP_MONITOR_PIN``
+	capability set.
 
 
 .. tabularcolumns:: |p{6.0cm}|p{0.6cm}|p{10.9cm}|
@@ -165,6 +179,12 @@ it is guaranteed that the state did change in between the two events.
 	opened. See the table above for which events do this. This allows
 	applications to learn the initial state of the CEC adapter at
 	open() time.
+    * .. _`CEC-EVENT-FL-DROPPED-EVENTS`:
+
+      - ``CEC_EVENT_FL_DROPPED_EVENTS``
+      - 2
+      - Set if one or more events of the given event type have been dropped.
+        This is an indication that the application cannot keep up.
 
 
 
diff --git a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
index 664f0d47bbcd..3e907c74338f 100644
--- a/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-g-mode.rst
@@ -149,13 +149,28 @@ Available follower modes are:
 	code. You cannot become a follower if :ref:`CEC_CAP_TRANSMIT <CEC-CAP-TRANSMIT>`
 	is not set or if :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>` was specified,
 	the ``EINVAL`` error code is returned in that case.
+    * .. _`CEC-MODE-MONITOR-PIN`:
+
+      - ``CEC_MODE_MONITOR_PIN``
+      - 0xd0
+      - Put the file descriptor into pin monitoring mode. Can only be used in
+	combination with :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`,
+	otherwise the ``EINVAL`` error code will be returned.
+	This mode requires that the :ref:`CEC_CAP_MONITOR_PIN <CEC-CAP-MONITOR-PIN>`
+	capability is set, otherwise the ``EINVAL`` error code is returned.
+	While in pin monitoring mode this file descriptor can receive the
+	``CEC_EVENT_PIN_LOW`` and ``CEC_EVENT_PIN_HIGH`` events to see the
+	low-level CEC pin transitions. This is very useful for debugging.
+	This mode is only allowed if the process has the ``CAP_NET_ADMIN``
+	capability. If that is not set, then the ``EPERM`` error code is returned.
     * .. _`CEC-MODE-MONITOR`:
 
       - ``CEC_MODE_MONITOR``
       - 0xe0
       - Put the file descriptor into monitor mode. Can only be used in
-	combination with :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`, otherwise EINVAL error
-	code will be returned. In monitor mode all messages this CEC
+	combination with :ref:`CEC_MODE_NO_INITIATOR <CEC-MODE-NO-INITIATOR>`,i
+	otherwise the ``EINVAL`` error code will be returned.
+	In monitor mode all messages this CEC
 	device transmits and all messages it receives (both broadcast
 	messages and directed messages for one its logical addresses) will
 	be reported. This is very useful for debugging. This is only
-- 
2.11.0
