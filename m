Return-path: <linux-media-owner@vger.kernel.org>
Received: from service87.mimecast.com ([91.220.42.44]:45916 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3DQPSy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 11:18:54 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Pawel Moll <pawel.moll@arm.com>
Subject: [RFC 07/10] mfd: vexpress: Allow external drivers to parse site ids
Date: Wed, 17 Apr 2013 16:17:19 +0100
Message-Id: <1366211842-21497-8-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1366211842-21497-1-git-send-email-pawel.moll@arm.com>
References: <1366211842-21497-1-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

... by providing a function translating the MASTER
value into the currently valid site number and
a _LAST constant providing all possible site id values.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/mfd/vexpress-sysreg.c |    5 +++++
 include/linux/vexpress.h      |    2 ++
 2 files changed, 7 insertions(+)

diff --git a/drivers/mfd/vexpress-sysreg.c b/drivers/mfd/vexpress-sysreg.c
index bf75e96..4158e26 100644
--- a/drivers/mfd/vexpress-sysreg.c
+++ b/drivers/mfd/vexpress-sysreg.c
@@ -81,6 +81,11 @@ void vexpress_flags_set(u32 data)
 =09writel(data, vexpress_sysreg_base + SYS_FLAGSSET);
 }
=20
+u32 vexpress_get_site(int site)
+{
+=09return site =3D=3D VEXPRESS_SITE_MASTER ? vexpress_master_site : site;
+}
+
 u32 vexpress_get_procid(int site)
 {
 =09if (site =3D=3D VEXPRESS_SITE_MASTER)
diff --git a/include/linux/vexpress.h b/include/linux/vexpress.h
index 7581874..1ebbcf5 100644
--- a/include/linux/vexpress.h
+++ b/include/linux/vexpress.h
@@ -19,6 +19,7 @@
 #define VEXPRESS_SITE_MB=09=090
 #define VEXPRESS_SITE_DB1=09=091
 #define VEXPRESS_SITE_DB2=09=092
+#define __VEXPRESS_SITE_LAST=09=093
 #define VEXPRESS_SITE_MASTER=09=090xf
=20
 #define VEXPRESS_CONFIG_STATUS_DONE=090
@@ -103,6 +104,7 @@ int vexpress_config_write(struct vexpress_config_func *=
func, int offset,
=20
 /* Platform control */
=20
+u32 vexpress_get_site(int site);
 u32 vexpress_get_procid(int site);
 u32 vexpress_get_hbi(int site);
 void *vexpress_get_24mhz_clock_base(void);
--=20
1.7.10.4


