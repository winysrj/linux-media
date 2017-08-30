Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:53914 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751409AbdH3QKs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 12:10:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 2/5] cec-ioc-dqevent.rst: document new CEC_EVENT_PIN_HPD_LOW/HIGH events
Date: Wed, 30 Aug 2017 18:10:41 +0200
Message-Id: <20170830161044.26571-3-hverkuil@xs4all.nl>
In-Reply-To: <20170830161044.26571-1-hverkuil@xs4all.nl>
References: <20170830161044.26571-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document these new CEC events.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
index db615e3405c0..32b47763f5a6 100644
--- a/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-dqevent.rst
@@ -160,6 +160,24 @@ it is guaranteed that the state did change in between the two events.
       - Generated if the CEC pin goes from a low voltage to a high voltage.
         Only applies to adapters that have the ``CEC_CAP_MONITOR_PIN``
 	capability set.
+    * .. _`CEC-EVENT-PIN-HPD-LOW`:
+
+      - ``CEC_EVENT_PIN_HPD_LOW``
+      - 5
+      - Generated if the HPD pin goes from a high voltage to a low voltage.
+        Only applies to adapters that have the ``CEC_CAP_MONITOR_PIN``
+	capability set. When open() is called, the HPD pin can be read and
+	the HPD is low, then an initial event will be generated for that
+	filehandle.
+    * .. _`CEC-EVENT-PIN-HPD-HIGH`:
+
+      - ``CEC_EVENT_PIN_HPD_HIGH``
+      - 6
+      - Generated if the HPD pin goes from a low voltage to a high voltage.
+        Only applies to adapters that have the ``CEC_CAP_MONITOR_PIN``
+	capability set. When open() is called, the HPD pin can be read and
+	the HPD is high, then an initial event will be generated for that
+	filehandle.
 
 
 .. tabularcolumns:: |p{6.0cm}|p{0.6cm}|p{10.9cm}|
-- 
2.14.1
