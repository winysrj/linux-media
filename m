Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:33161 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753555AbdDCOmv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 10:42:51 -0400
Received: by mail-wr0-f181.google.com with SMTP id w43so171973444wrb.0
        for <linux-media@vger.kernel.org>; Mon, 03 Apr 2017 07:42:51 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, architt@codeaurora.org
Cc: Neil Armstrong <narmstrong@baylibre.com>, Jose.Abreu@synopsys.com,
        kieran.bingham@ideasonboard.com, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH v6 5/6] drm: bridge: dw-hdmi: Add Documentation on supported input formats
Date: Mon,  3 Apr 2017 16:42:37 +0200
Message-Id: <1491230558-10804-6-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1491230558-10804-1-git-send-email-narmstrong@baylibre.com>
References: <1491230558-10804-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a new DRM documentation entry and links to the input
format table added in the dw_hdmi header.

Reviewed-by: Archit Taneja <architt@codeaurora.org>
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
