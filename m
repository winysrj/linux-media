Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50492 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756959AbdLQARX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Dec 2017 19:17:23 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        Russell King <linux@armlinux.org.uk>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH/RFC 4/4] drm: rcar-du: Add support for color keying on Gen3
Date: Sun, 17 Dec 2017 02:17:24 +0200
Message-Id: <20171217001724.1348-5-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20171217001724.1348-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20171217001724.1348-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gen3 hardware supports color keying with replacement of the pixel value.
Implement it using the standard KMS colorkey properties.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index 882d1f7a328b..54deb9567cd3 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -198,6 +198,13 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
 		}
 	}
 
+	/* Convert the colorkey from 16 bits to 8 bits per component. */
+	cfg.colorkey.enabled = state->state.colorkey.mode;
+	cfg.colorkey.alpha = state->state.colorkey.value >> 56;
+	cfg.colorkey.key = ((state->state.colorkey.min >> 24) & 0x00ff0000)
+			 | ((state->state.colorkey.min >> 16) & 0x0000ff00)
+			 | ((state->state.colorkey.min >>  8) & 0x000000ff);
+
 	vsp1_du_atomic_update(plane->vsp->vsp, crtc->vsp_pipe,
 			      plane->index, &cfg);
 }
@@ -383,6 +390,11 @@ static const struct drm_plane_funcs rcar_du_vsp_plane_funcs = {
 	.atomic_get_property = rcar_du_vsp_plane_atomic_get_property,
 };
 
+static const struct drm_prop_enum_list colorkey_modes[] = {
+	{ 0, "disabled" },
+	{ 1, "source" },
+};
+
 int rcar_du_vsp_init(struct rcar_du_vsp *vsp, struct device_node *np,
 		     unsigned int crtcs)
 {
@@ -441,6 +453,10 @@ int rcar_du_vsp_init(struct rcar_du_vsp *vsp, struct device_node *np,
 					   rcdu->props.alpha, 255);
 		drm_plane_create_zpos_property(&plane->plane, 1, 1,
 					       vsp->num_planes - 1);
+		drm_plane_create_colorkey_properties(&plane->plane,
+						     colorkey_modes,
+						     ARRAY_SIZE(colorkey_modes),
+						     true);
 	}
 
 	return 0;
-- 
Regards,

Laurent Pinchart
