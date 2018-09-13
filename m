Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:54886 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727127AbeIMQ4o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 12:56:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 4/5] drm/bridge/synopsys/dw-hdmi.h: rename ADOBE to OP
Date: Thu, 13 Sep 2018 13:47:30 +0200
Message-Id: <20180913114731.16500-5-hverkuil@xs4all.nl>
In-Reply-To: <20180913114731.16500-1-hverkuil@xs4all.nl>
References: <20180913114731.16500-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

The CTA-861 standard renamed this from ADOBE to OP. Make the
same change to sync with the standard.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.h b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.h
index 9d90eb9c46e5..56f37134d748 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.h
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.h
@@ -791,8 +791,8 @@ enum {
 	HDMI_FC_AVICONF2_EXT_COLORIMETRY_XVYCC601 = 0x00,
 	HDMI_FC_AVICONF2_EXT_COLORIMETRY_XVYCC709 = 0x10,
 	HDMI_FC_AVICONF2_EXT_COLORIMETRY_SYCC601 = 0x20,
-	HDMI_FC_AVICONF2_EXT_COLORIMETRY_ADOBE_YCC601 = 0x30,
-	HDMI_FC_AVICONF2_EXT_COLORIMETRY_ADOBE_RGB = 0x40,
+	HDMI_FC_AVICONF2_EXT_COLORIMETRY_OPYCC601 = 0x30,
+	HDMI_FC_AVICONF2_EXT_COLORIMETRY_OPRGB = 0x40,
 	HDMI_FC_AVICONF2_IT_CONTENT_MASK = 0x80,
 	HDMI_FC_AVICONF2_IT_CONTENT_NO_DATA = 0x00,
 	HDMI_FC_AVICONF2_IT_CONTENT_VALID = 0x80,
-- 
2.18.0
