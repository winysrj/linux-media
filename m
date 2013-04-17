Return-path: <linux-media-owner@vger.kernel.org>
Received: from service87.mimecast.com ([91.220.42.44]:34246 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966676Ab3DQPRn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 11:17:43 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Pawel Moll <pawel.moll@arm.com>
Subject: [RFC 05/10] fbmon: Add extra video helper
Date: Wed, 17 Apr 2013 16:17:17 +0100
Message-Id: <1366211842-21497-6-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1366211842-21497-1-git-send-email-pawel.moll@arm.com>
References: <1366211842-21497-1-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function converts the fb_var_screeninfo to the videomode
structure, to be used in fbdev drivers working with the
Common Display Framework.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/video/fbmon.c |   29 +++++++++++++++++++++++++++++
 include/linux/fb.h    |    3 +++
 2 files changed, 32 insertions(+)

diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
index 7f67099..f0ff2bf 100644
--- a/drivers/video/fbmon.c
+++ b/drivers/video/fbmon.c
@@ -1424,6 +1424,35 @@ int fb_videomode_from_videomode(const struct videomo=
de *vm,
 =09return 0;
 }
 EXPORT_SYMBOL_GPL(fb_videomode_from_videomode);
+
+void videomode_from_fb_var_screeninfo(const struct fb_var_screeninfo *var,
+=09=09=09=09      struct videomode *vm)
+{
+=09vm->pixelclock =3D PICOS2KHZ(var->pixclock) * 1000;
+
+=09vm->hactive =3D var->xres;
+=09vm->hfront_porch =3D var->right_margin;
+=09vm->hback_porch =3D var->left_margin;
+=09vm->hsync_len =3D var->hsync_len;
+
+=09vm->vactive =3D var->yres;
+=09vm->vfront_porch =3D var->lower_margin;
+=09vm->vback_porch =3D var->upper_margin;
+=09vm->vsync_len =3D var->vsync_len;
+
+=09vm->dmt_flags =3D 0;
+=09if (var->sync & FB_SYNC_HOR_HIGH_ACT)
+=09=09vm->dmt_flags |=3D VESA_DMT_HSYNC_HIGH;
+=09if (var->sync & FB_SYNC_VERT_HIGH_ACT)
+=09=09vm->dmt_flags |=3D VESA_DMT_VSYNC_HIGH;
+
+=09vm->data_flags =3D 0;
+=09if (var->vmode & FB_VMODE_INTERLACED)
+=09=09vm->data_flags |=3D DISPLAY_FLAGS_INTERLACED;
+=09if (var->vmode & FB_VMODE_DOUBLE)
+=09=09vm->data_flags |=3D DISPLAY_FLAGS_DOUBLESCAN;
+}
+EXPORT_SYMBOL_GPL(videomode_from_fb_var_screeninfo);
 #endif
=20
 #if IS_ENABLED(CONFIG_OF_VIDEOMODE)
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 58b9860..aae2ed3 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -721,6 +721,9 @@ extern int of_get_fb_videomode(struct device_node *np,
 =09=09=09       int index);
 extern int fb_videomode_from_videomode(const struct videomode *vm,
 =09=09=09=09       struct fb_videomode *fbmode);
+extern void videomode_from_fb_var_screeninfo(
+=09=09=09=09const struct fb_var_screeninfo *var,
+=09=09=09=09struct videomode *vm);
=20
 /* drivers/video/modedb.c */
 #define VESA_MODEDB_SIZE 34
--=20
1.7.10.4


