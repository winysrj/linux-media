Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36590 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933289AbdCaOZe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 10:25:34 -0400
Received: by mail-wm0-f51.google.com with SMTP id o81so89339wmb.1
        for <linux-media@vger.kernel.org>; Fri, 31 Mar 2017 07:25:32 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, architt@codeaurora.org
Cc: Neil Armstrong <narmstrong@baylibre.com>, Jose.Abreu@synopsys.com,
        kieran.bingham@ideasonboard.com, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH v5.1 5/6] drm: bridge: dw-hdmi: Add Documentation on supported input formats
Date: Fri, 31 Mar 2017 16:25:18 +0200
Message-Id: <1490970319-24981-6-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1490970319-24981-1-git-send-email-narmstrong@baylibre.com>
References: <1490970319-24981-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a new DRM documentation entry and links to the input
format table added in the dw_hdmi header.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 Documentation/gpu/bridge/dw-hdmi.rst | 15 +++++++++++++++
 Documentation/gpu/index.rst          |  1 +
 2 files changed, 16 insertions(+)
 create mode 100644 Documentation/gpu/bridge/dw-hdmi.rst

diff --git a/Documentation/gpu/bridge/dw-hdmi.rst b/Documentation/gpu/bridge/dw-hdmi.rst
new file mode 100644
index 0000000..486faad
--- /dev/null
+++ b/Documentation/gpu/bridge/dw-hdmi.rst
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
index e998ee0..d81c6ff 100644
--- a/Documentation/gpu/index.rst
+++ b/Documentation/gpu/index.rst
@@ -15,6 +15,7 @@ Linux GPU Driver Developer's Guide
    vc4
    vga-switcheroo
    vgaarbiter
+   bridge/dw-hdmi
    todo
 
 .. only::  subproject and html
-- 
1.9.1
