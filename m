Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47939 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbeDSJbo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 05:31:44 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: architt@codeaurora.org, a.hajda@samsung.com,
        Laurent.pinchart@ideasonboard.com, airlied@linux.ie
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, daniel@ffwll.ch,
        peda@axentia.se, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] drm: connector: Remove DRM_BUS_FLAG_DATA_* flags
Date: Thu, 19 Apr 2018 11:31:09 +0200
Message-Id: <1524130269-32688-9-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DRM_BUS_FLAG_DATA_* flags, defined in drm_connector.h header file are
used to swap ordering of LVDS RGB format to accommodate DRM objects
that need to handle LVDS components ordering.

Now that the only 2 users of DRM_BUS_FLAG_DATA_* flags have been ported
to use the newly introduced MEDIA_BUS_FMT_RGB888_1X7X*_LE media bus
formats, remove them.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 include/drm/drm_connector.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
index 675cc3f..9e0d6d5 100644
--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -286,10 +286,6 @@ struct drm_display_info {
 #define DRM_BUS_FLAG_PIXDATA_POSEDGE	(1<<2)
 /* drive data on neg. edge */
 #define DRM_BUS_FLAG_PIXDATA_NEGEDGE	(1<<3)
-/* data is transmitted MSB to LSB on the bus */
-#define DRM_BUS_FLAG_DATA_MSB_TO_LSB	(1<<4)
-/* data is transmitted LSB to MSB on the bus */
-#define DRM_BUS_FLAG_DATA_LSB_TO_MSB	(1<<5)
 
 	/**
 	 * @bus_flags: Additional information (like pixel signal polarity) for
-- 
2.7.4
