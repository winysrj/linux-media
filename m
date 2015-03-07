Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33301 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750892AbbCGVmP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2015 16:42:15 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, pali.rohar@gmail.com
Subject: [RFC 02/18] omap3isp: Avoid a BUG_ON() in media_entity_create_link()
Date: Sat,  7 Mar 2015 23:40:59 +0200
Message-Id: <1425764475-27691-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If an uninitialised v4l2_subdev struct was passed to
media_entity_create_link(), one of the BUG_ON()'s in the function will be
hit since media_entity.num_pads will be zero. Avoid this by checking whether
the num_pads field is non-zero for the interface.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/platform/omap3isp/isp.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index fb193b6..4ab674d 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1946,6 +1946,19 @@ static int isp_register_entities(struct isp_device *isp)
 			goto done;
 		}
 
+		/*
+		 * Not all interfaces are available on all revisions
+		 * of the ISP. The sub-devices of those interfaces
+		 * aren't initialised in such a case. Check this by
+		 * ensuring the num_pads is non-zero.
+		 */
+		if (!input->num_pads) {
+			dev_err(isp->dev, "%s: invalid input %u\n",
+				entity->name, subdevs->interface);
+			ret = -EINVAL;
+			goto done;
+		}
+
 		for (i = 0; i < sensor->entity.num_pads; i++) {
 			if (sensor->entity.pads[i].flags & MEDIA_PAD_FL_SOURCE)
 				break;
-- 
1.7.10.4

