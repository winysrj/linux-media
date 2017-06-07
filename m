Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:44662 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751491AbdFGOqW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 10:46:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 6/9] cec-ioc-adap-g-caps.rst: document CEC_CAP_NEEDS_HPD
Date: Wed,  7 Jun 2017 16:46:13 +0200
Message-Id: <20170607144616.15247-7-hverkuil@xs4all.nl>
In-Reply-To: <20170607144616.15247-1-hverkuil@xs4all.nl>
References: <20170607144616.15247-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the new CEC_CAP_NEEDS_HPD capability.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Andrzej Hajda <a.hajda@samsung.com>
---
 Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
index a0e961f11017..6d7bf7bef3eb 100644
--- a/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
+++ b/Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst
@@ -113,6 +113,14 @@ returns the information to the application. The ioctl never fails.
       - 0x00000020
       - The CEC hardware can monitor all messages, not just directed and
 	broadcast messages.
+    * .. _`CEC-CAP-NEEDS-HPD`:
+
+      - ``CEC_CAP_NEEDS_HPD``
+      - 0x00000040
+      - The CEC hardware is only active if the HDMI Hotplug Detect pin is
+        high. This makes it impossible to use CEC to wake up displays that
+	set the HPD pin low when in standby mode, but keep the CEC bus
+	alive.
 
 
 
-- 
2.11.0
