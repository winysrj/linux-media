Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:38681 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754307AbdCGRku (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 12:40:50 -0500
Received: by mail-wm0-f42.google.com with SMTP id t189so11343915wmt.1
        for <linux-media@vger.kernel.org>; Tue, 07 Mar 2017 09:40:37 -0800 (PST)
From: Neil Armstrong <narmstrong@baylibre.com>
To: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, architt@codeaurora.org
Cc: Neil Armstrong <narmstrong@baylibre.com>, Jose.Abreu@synopsys.com,
        kieran.bingham@ideasonboard.com, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH v3 5/6] drm: bridge: dw-hdmi: Add Documentation on supported input formats
Date: Tue,  7 Mar 2017 17:42:23 +0100
Message-Id: <1488904944-14285-6-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1488904944-14285-1-git-send-email-narmstrong@baylibre.com>
References: <1488904944-14285-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a new DRM documentation entry and links to the input
format table added in the dw_hdmi header.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 Documentation/gpu/dw-hdmi.rst | 15 +++++++++++++++
 Documentation/gpu/index.rst   |  1 +
 2 files changed, 16 insertions(+)
 create mode 100644 Documentation/gpu/dw-hdmi.rst

diff --git a/Documentation/gpu/dw-hdmi.rst b/Documentation/gpu/dw-hdmi.rst
new file mode 100644
index 0000000..486faad
--- /dev/null
+++ b/Documentation/gpu/dw-hdmi.rst
@@ -0,0 +1,15 @@
+=======================================================
+ drm/bridge/dw-hdmi Synopsys DesignWare HDMI Controller
+=======================================================
+
+Synopsys DesignWare HDMI Controller
+===================================
+
+This section covers everything related to the Synopsys DesignWare HDMI
+Controller implemented as a DRM bridge.
+
+Supported Input Formats and Encodings
+-------------------------------------
+
+.. kernel-doc:: include/drm/bridge/dw_hdmi.h
+   :doc: Supported input formats and encodings
diff --git a/Documentation/gpu/index.rst b/Documentation/gpu/index.rst
index e998ee0..0725449 100644
--- a/Documentation/gpu/index.rst
+++ b/Documentation/gpu/index.rst
@@ -10,6 +10,7 @@ Linux GPU Driver Developer's Guide
    drm-kms
    drm-kms-helpers
    drm-uapi
+   dw-hdmi
    i915
    tinydrm
    vc4
-- 
1.9.1
