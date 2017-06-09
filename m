Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:55622 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751720AbdFIRyF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 13:54:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH 1/2] dt-bindings: add media/cec.txt
Date: Fri,  9 Jun 2017 19:54:00 +0200
Message-Id: <20170609175401.40204-2-hverkuil@xs4all.nl>
In-Reply-To: <20170609175401.40204-1-hverkuil@xs4all.nl>
References: <20170609175401.40204-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document common HDMI CEC bindings. Add this to the MAINTAINERS file
as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: devicetree@vger.kernel.org
---
 Documentation/devicetree/bindings/media/cec.txt | 8 ++++++++
 MAINTAINERS                                     | 1 +
 2 files changed, 9 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/cec.txt

diff --git a/Documentation/devicetree/bindings/media/cec.txt b/Documentation/devicetree/bindings/media/cec.txt
new file mode 100644
index 000000000000..22d7aae3d3d7
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/cec.txt
@@ -0,0 +1,8 @@
+Common bindings for HDMI CEC adapters
+
+- hdmi-phandle: phandle to the HDMI controller.
+
+- needs-hpd: if present the CEC support is only available when the HPD
+  is high. Some boards only let the CEC pin through if the HPD is high,
+  for example if there is a level converter that uses the HPD to power
+  up or down.
diff --git a/MAINTAINERS b/MAINTAINERS
index 053c3bdd1fe5..4ac340d189a3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3137,6 +3137,7 @@ F:	include/media/cec.h
 F:	include/media/cec-notifier.h
 F:	include/uapi/linux/cec.h
 F:	include/uapi/linux/cec-funcs.h
+F:	Documentation/devicetree/bindings/media/cec.txt
 
 CELL BROADBAND ENGINE ARCHITECTURE
 M:	Arnd Bergmann <arnd@arndb.de>
-- 
2.11.0
