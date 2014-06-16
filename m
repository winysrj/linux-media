Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:47656 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbaFPKMK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 06:12:10 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 300BF2D8F3
	for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 12:12:06 +0200 (CEST)
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
Subject: [PATCH v14 06/10] drm: drm_display_mode: add signal polarity flags
Date: Mon, 16 Jun 2014 12:11:20 +0200
Message-Id: <1402913484-25910-6-git-send-email-denis@eukrea.com>
In-Reply-To: <1402913484-25910-1-git-send-email-denis@eukrea.com>
References: <1402913484-25910-1-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need a way to pass signal polarity informations
  between DRM panels, and the display drivers.

To do that, a pol_flags field was added to drm_display_mode.

Signed-off-by: Denis Carikli <denis@eukrea.com>
---
ChangeLog v13->v14:
- Fixed DRM_MODE_FLAG_POL_DE_HIGH's description.
ChangeLog v12->v13:
- Added Docbook documentation for pol_flags the struct field.
- Removed the _PRESERVE	defines: it was used by patches
  against the imx_drm driver. Now theses patches have been
  adapted not to require that defines.
ChangeLog v11->v12:
- Rebased: This patch now applies against drm_modes.h
- Rebased: It now uses the new DRM_MODE_FLAG_POL_DE flags defines names

ChangeLog v10->v11:
- Since the imx-drm won't be able to retrive its regulators
  from the device tree when using display-timings nodes,
  and that I was told that the drm simple-panel driver 
  already supported that, I then, instead, added what was
  lacking to make the eukrea displays work with the
  drm-simple-panel driver.

  That required a way to get back the display polarity
  informations from the imx-drm driver without affecting
  userspace.
---
 Documentation/DocBook/drm.tmpl |   30 ++++++++++++++++++++++++++++++
 include/drm/drm_modes.h        |    6 ++++++
 2 files changed, 36 insertions(+)

diff --git a/Documentation/DocBook/drm.tmpl b/Documentation/DocBook/drm.tmpl
index 7df3134..22d435f 100644
--- a/Documentation/DocBook/drm.tmpl
+++ b/Documentation/DocBook/drm.tmpl
@@ -2292,6 +2292,36 @@ void intel_crt_init(struct drm_device *dev)
             and <structfield>height_mm</structfield> fields are only used internally
             during EDID parsing and should not be set when creating modes manually.
           </para>
+          <para>
+            The <structfield>pol_flags</structfield> value represents the display
+            signal polarity flags, it can be a combination of
+            <variablelist>
+              <varlistentry>
+                <term>DRM_MODE_FLAG_POL_PIXDATA_NEGEDGE</term>
+                 <listitem><para>
+                     drive pixel data on falling edge, sample data on rising edge.
+                 </para></listitem>
+              </varlistentry>
+              <varlistentry>
+                <term>DRM_MODE_FLAG_POL_PIXDATA_POSEDGE</term>
+                <listitem><para>
+                  Drive pixel data on rising edge, sample data on falling edge.
+                </para></listitem>
+              </varlistentry>
+              <varlistentry>
+                <term>DRM_MODE_FLAG_POL_DE_LOW</term>
+                <listitem><para>
+                  data-enable pulse is active low
+                </para></listitem>
+              </varlistentry>
+              <varlistentry>
+                <term>DRM_MODE_FLAG_POL_DE_HIGH</term>
+                <listitem><para>
+                  data-enable pulse is active high
+                </para></listitem>
+              </varlistentry>
+            </variablelist>
+          </para>
         </listitem>
         <listitem>
           <synopsis>int (*mode_valid)(struct drm_connector *connector,
diff --git a/include/drm/drm_modes.h b/include/drm/drm_modes.h
index 91d0582..c5cbe31 100644
--- a/include/drm/drm_modes.h
+++ b/include/drm/drm_modes.h
@@ -93,6 +93,11 @@ enum drm_mode_status {
 
 #define DRM_MODE_FLAG_3D_MAX	DRM_MODE_FLAG_3D_SIDE_BY_SIDE_HALF
 
+#define DRM_MODE_FLAG_POL_PIXDATA_NEGEDGE	BIT(1)
+#define DRM_MODE_FLAG_POL_PIXDATA_POSEDGE	BIT(2)
+#define DRM_MODE_FLAG_POL_DE_LOW		BIT(3)
+#define DRM_MODE_FLAG_POL_DE_HIGH		BIT(4)
+
 struct drm_display_mode {
 	/* Header */
 	struct list_head head;
@@ -144,6 +149,7 @@ struct drm_display_mode {
 	int vrefresh;		/* in Hz */
 	int hsync;		/* in kHz */
 	enum hdmi_picture_aspect picture_aspect_ratio;
+	unsigned int pol_flags;
 };
 
 /* mode specified on the command line */
-- 
1.7.9.5

