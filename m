Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:45970 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751503AbdFGOqW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 10:46:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>, devicetree@vger.kernel.org
Subject: [PATCH 7/9] dt-bindings: media/s5p-cec.txt: document needs-hpd property
Date: Wed,  7 Jun 2017 16:46:14 +0200
Message-Id: <20170607144616.15247-8-hverkuil@xs4all.nl>
In-Reply-To: <20170607144616.15247-1-hverkuil@xs4all.nl>
References: <20170607144616.15247-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Needed for boards that wire the CEC pin in such a way that it
is unavailable when the HPD is low.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: devicetree@vger.kernel.org
---
 Documentation/devicetree/bindings/media/s5p-cec.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/s5p-cec.txt b/Documentation/devicetree/bindings/media/s5p-cec.txt
index 4bb08d9d940b..261af4d1a791 100644
--- a/Documentation/devicetree/bindings/media/s5p-cec.txt
+++ b/Documentation/devicetree/bindings/media/s5p-cec.txt
@@ -17,6 +17,12 @@ Required properties:
   - samsung,syscon-phandle - phandle to the PMU system controller
   - hdmi-phandle - phandle to the HDMI controller
 
+Optional:
+  - needs-hpd : if present the CEC support is only available when the HPD
+    is high. Some boards only let the CEC pin through if the HPD is high, for
+    example if there is a level converter that uses the HPD to power up
+    or down.
+
 Example:
 
 hdmicec: cec@100B0000 {
-- 
2.11.0
