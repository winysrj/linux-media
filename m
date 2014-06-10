Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:46083 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbaFJK0S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jun 2014 06:26:18 -0400
From: Denis Carikli <denis@eukrea.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
	Denis Carikli <denis@eukrea.com>
Subject: [PATCH v13 08/10] drm/panel: Add Eukrea mbimxsd51 displays.
Date: Tue, 10 Jun 2014 12:25:49 +0200
Message-Id: <1402395951-7988-8-git-send-email-denis@eukrea.com>
In-Reply-To: <1402395951-7988-1-git-send-email-denis@eukrea.com>
References: <1402395951-7988-1-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Denis Carikli <denis@eukrea.com>
---
ChangeLog v12->v13:
- Added a note explaining why the size is zero in
  the eukrea_mbimxsd51_dvi(s)vga structs.
ChangeLog v11->v12:
- Rebased: It now uses the new DRM_MODE_FLAG_POL_DE flags defines names

ChangeLog v10->v11:
- New patch.
---
 .../bindings/panel/eukrea,mbimxsd51-cmo-qvga.txt   |    7 ++
 .../bindings/panel/eukrea,mbimxsd51-dvi-svga.txt   |    7 ++
 .../bindings/panel/eukrea,mbimxsd51-dvi-vga.txt    |    7 ++
 drivers/gpu/drm/panel/panel-simple.c               |   83 ++++++++++++++++++++
 4 files changed, 104 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-cmo-qvga.txt
 create mode 100644 Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-dvi-svga.txt
 create mode 100644 Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-dvi-vga.txt

diff --git a/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-cmo-qvga.txt b/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-cmo-qvga.txt
new file mode 100644
index 0000000..03679d0
--- /dev/null
+++ b/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-cmo-qvga.txt
@@ -0,0 +1,7 @@
+Eukrea CMO-QVGA (320x240 pixels) TFT LCD panel
+
+Required properties:
+- compatible: should be "eukrea,mbimxsd51-cmo-qvga"
+
+This binding is compatible with the simple-panel binding, which is specified
+in simple-panel.txt in this directory.
diff --git a/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-dvi-svga.txt b/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-dvi-svga.txt
new file mode 100644
index 0000000..f408c9a
--- /dev/null
+++ b/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-dvi-svga.txt
@@ -0,0 +1,7 @@
+Eukrea DVI-SVGA (800x600 pixels) DVI output.
+
+Required properties:
+- compatible: should be "eukrea,mbimxsd51-dvi-svga"
+
+This binding is compatible with the simple-panel binding, which is specified
+in simple-panel.txt in this directory.
diff --git a/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-dvi-vga.txt b/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-dvi-vga.txt
new file mode 100644
index 0000000..8ea90da
--- /dev/null
+++ b/Documentation/devicetree/bindings/panel/eukrea,mbimxsd51-dvi-vga.txt
@@ -0,0 +1,7 @@
+Eukrea DVI-VGA (640x480 pixels) DVI output.
+
+Required properties:
+- compatible: should be "eukrea,mbimxsd51-dvi-vga"
+
+This binding is compatible with the simple-panel binding, which is specified
+in simple-panel.txt in this directory.
diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index a251361..adc40a7 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -403,6 +403,80 @@ static const struct panel_desc edt_etm0700g0dh6 = {
 	},
 };
 
+static const struct drm_display_mode eukrea_mbimxsd51_cmoqvga_mode = {
+	.clock = 6500,
+	.hdisplay = 320,
+	.hsync_start = 320 + 38,
+	.hsync_end = 320 + 38 + 20,
+	.htotal = 320 + 38 + 20 + 30,
+	.vdisplay = 240,
+	.vsync_start = 240 + 15,
+	.vsync_end = 240 + 15 + 4,
+	.vtotal = 240 + 15 + 4 + 3,
+	.vrefresh = 60,
+	.pol_flags = DRM_MODE_FLAG_POL_PIXDATA_NEGEDGE |
+		     DRM_MODE_FLAG_POL_DE_LOW,
+};
+
+static const struct panel_desc eukrea_mbimxsd51_cmoqvga = {
+	.modes = &eukrea_mbimxsd51_cmoqvga_mode,
+	.num_modes = 1,
+	.size = {
+		.width = 73,
+		.height = 56,
+	},
+};
+
+static const struct drm_display_mode eukrea_mbimxsd51_dvisvga_mode = {
+	.clock = 44333,
+	.hdisplay = 800,
+	.hsync_start = 800 + 112,
+	.hsync_end = 800 + 112 + 32,
+	.htotal = 800 + 112 + 32 + 80,
+	.vdisplay = 600,
+	.vsync_start = 600 + 3,
+	.vsync_end = 600 + 3 + 17,
+	.vtotal = 600 + 3 + 17 + 4,
+	.vrefresh = 60,
+	.pol_flags = DRM_MODE_FLAG_POL_PIXDATA_POSEDGE |
+		     DRM_MODE_FLAG_POL_DE_HIGH,
+};
+
+static const struct panel_desc eukrea_mbimxsd51_dvisvga = {
+	.modes = &eukrea_mbimxsd51_dvisvga_mode,
+	.num_modes = 1,
+	/* This is a DVI adapter for external displays */
+	.size = {
+		.width = 0,
+		.height = 0,
+	},
+};
+
+static const struct drm_display_mode eukrea_mbimxsd51_dvivga_mode = {
+	.clock = 23750,
+	.hdisplay = 640,
+	.hsync_start = 640 + 80,
+	.hsync_end = 640 + 80 + 16,
+	.htotal = 640 + 80 + 16 + 64,
+	.vdisplay = 480,
+	.vsync_start = 480 + 3,
+	.vsync_end = 480 + 3 + 13,
+	.vtotal  = 480 + 3 + 13 + 4,
+	.vrefresh = 60,
+	.pol_flags = DRM_MODE_FLAG_POL_PIXDATA_POSEDGE |
+		     DRM_MODE_FLAG_POL_DE_HIGH,
+};
+
+static const struct panel_desc eukrea_mbimxsd51_dvivga = {
+	.modes = &eukrea_mbimxsd51_dvivga_mode,
+	.num_modes = 1,
+	/* This is a DVI adapter for external displays */
+	.size = {
+		.width = 0,
+		.height = 0,
+	},
+};
+
 static const struct drm_display_mode lg_lp129qe_mode = {
 	.clock = 285250,
 	.hdisplay = 2560,
@@ -458,6 +532,15 @@ static const struct of_device_id platform_of_match[] = {
 		.compatible = "chunghwa,claa101wa01a",
 		.data = &chunghwa_claa101wa01a
 	}, {
+		.compatible = "eukrea,mbimxsd51-cmo-qvga",
+		.data = &eukrea_mbimxsd51_cmoqvga,
+	}, {
+		.compatible = "eukrea,mbimxsd51-dvi-svga",
+		.data = &eukrea_mbimxsd51_dvisvga,
+	}, {
+		.compatible = "eukrea,mbimxsd51-dvi-vga",
+		.data = &eukrea_mbimxsd51_dvivga,
+	}, {
 		.compatible = "chunghwa,claa101wb01",
 		.data = &chunghwa_claa101wb01
 	}, {
-- 
1.7.9.5

