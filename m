Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:34216 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752976AbcJZI4G (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 04:56:06 -0400
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [RFC PATCH v2 2/9] drm: mali-dp: Clear CVAL when leaving config mode
Date: Wed, 26 Oct 2016 09:55:01 +0100
Message-Id: <1477472108-27222-3-git-send-email-brian.starkey@arm.com>
In-Reply-To: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
References: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's possible for CVAL to get set whilst we are in config mode. If this
happens, afer we leave config mode the HW will latch whatever
configuration is in the registers at the next vsync. Most likely this
will be a partial configuration, as we'll be racing against the ongoing
atomic_commit.

To avoid this, clear CVAL before leaving config mode.

Signed-off-by: Brian Starkey <brian.starkey@arm.com>
---
 drivers/gpu/drm/arm/malidp_hw.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/arm/malidp_hw.c b/drivers/gpu/drm/arm/malidp_hw.c
index 7f4a0bd..65e667b 100644
--- a/drivers/gpu/drm/arm/malidp_hw.c
+++ b/drivers/gpu/drm/arm/malidp_hw.c
@@ -125,6 +125,7 @@ static void malidp500_leave_config_mode(struct malidp_hw_device *hwdev)
 {
 	u32 status, count = 100;
 
+	malidp_hw_clearbits(hwdev, MALIDP_CFG_VALID, MALIDP500_CONFIG_VALID);
 	malidp_hw_clearbits(hwdev, MALIDP500_DC_CONFIG_REQ, MALIDP500_DC_CONTROL);
 	while (count) {
 		status = malidp_hw_read(hwdev, hwdev->map.dc_base + MALIDP_REG_STATUS);
@@ -271,6 +272,7 @@ static void malidp550_leave_config_mode(struct malidp_hw_device *hwdev)
 {
 	u32 status, count = 100;
 
+	malidp_hw_clearbits(hwdev, MALIDP_CFG_VALID, MALIDP550_CONFIG_VALID);
 	malidp_hw_clearbits(hwdev, MALIDP550_DC_CONFIG_REQ, MALIDP550_DC_CONTROL);
 	while (count) {
 		status = malidp_hw_read(hwdev, hwdev->map.dc_base + MALIDP_REG_STATUS);
-- 
1.7.9.5

