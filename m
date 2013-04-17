Return-path: <linux-media-owner@vger.kernel.org>
Received: from service87.mimecast.com ([91.220.42.44]:38822 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab3DQPSU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 11:18:20 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Pawel Moll <pawel.moll@arm.com>
Subject: [RFC 02/10] video: display: Update the display with the video mode data
Date: Wed, 17 Apr 2013 16:17:14 +0100
Message-Id: <1366211842-21497-3-git-send-email-pawel.moll@arm.com>
In-Reply-To: <1366211842-21497-1-git-send-email-pawel.moll@arm.com>
References: <1366211842-21497-1-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The display entity (sink) may need to know about the mode being
changed, eg. to update timings.

Alternatively there could be a separate set_mode() operation...

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/video/display/display-core.c |    5 +++--
 include/video/display.h              |    6 ++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/video/display/display-core.c b/drivers/video/display/d=
isplay-core.c
index d2daa15..4b8e45a 100644
--- a/drivers/video/display/display-core.c
+++ b/drivers/video/display/display-core.c
@@ -69,12 +69,13 @@ EXPORT_SYMBOL_GPL(display_entity_set_state);
  *
  * Return 0 on success or a negative error code otherwise.
  */
-int display_entity_update(struct display_entity *entity)
+int display_entity_update(struct display_entity *entity,
+=09=09=09     const struct videomode *mode)
 {
 =09if (!entity->ops.ctrl || !entity->ops.ctrl->update)
 =09=09return 0;
=20
-=09return entity->ops.ctrl->update(entity);
+=09return entity->ops.ctrl->update(entity, mode);
 }
 EXPORT_SYMBOL_GPL(display_entity_update);
=20
diff --git a/include/video/display.h b/include/video/display.h
index 90d18ca..64f84d5 100644
--- a/include/video/display.h
+++ b/include/video/display.h
@@ -77,7 +77,8 @@ struct display_entity_interface_params {
 struct display_entity_control_ops {
 =09int (*set_state)(struct display_entity *ent,
 =09=09=09 enum display_entity_state state);
-=09int (*update)(struct display_entity *ent);
+=09int (*update)(struct display_entity *ent,
+=09=09=09 const struct videomode *mode);
 =09int (*get_modes)(struct display_entity *ent,
 =09=09=09 const struct videomode **modes);
 =09int (*get_params)(struct display_entity *ent,
@@ -111,7 +112,8 @@ struct display_entity {
=20
 int display_entity_set_state(struct display_entity *entity,
 =09=09=09     enum display_entity_state state);
-int display_entity_update(struct display_entity *entity);
+int display_entity_update(struct display_entity *entity,
+=09=09=09     const struct videomode *mode);
 int display_entity_get_modes(struct display_entity *entity,
 =09=09=09     const struct videomode **modes);
 int display_entity_get_params(struct display_entity *entity,
--=20
1.7.10.4


