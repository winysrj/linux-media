Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37165 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730234AbeGROJa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 10:09:30 -0400
From: Jacopo Mondi <jacopo@jmondi.org>
To: hverkuil@xs4all.nl, horms@verge.net.au, magnus.damm@gmail.com
Cc: Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH] ARM: shmobile: defconfig: Remove SOC_CAMERA
Date: Wed, 18 Jul 2018 15:31:12 +0200
Message-Id: <1531920672-31153-1-git-send-email-jacopo@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the soc_camera framework is going to be deprecated soon, remove the
associated configuration options from shmobile defconfig.

Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
---
Hi Simon,
   I expect Hans to collect this patch as he did for SH defconfig ones.
Please let us know if that's not ok with you.

Thanks
   j
---

 arch/arm/configs/shmobile_defconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/configs/shmobile_defconfig b/arch/arm/configs/shmobile_defconfig
index b49887e..239f2c7 100644
--- a/arch/arm/configs/shmobile_defconfig
+++ b/arch/arm/configs/shmobile_defconfig
@@ -141,8 +141,6 @@ CONFIG_MEDIA_CAMERA_SUPPORT=y
 CONFIG_MEDIA_CONTROLLER=y
 CONFIG_VIDEO_V4L2_SUBDEV_API=y
 CONFIG_V4L_PLATFORM_DRIVERS=y
-CONFIG_SOC_CAMERA=y
-CONFIG_SOC_CAMERA_PLATFORM=y
 CONFIG_VIDEO_RCAR_VIN=y
 CONFIG_V4L_MEM2MEM_DRIVERS=y
 CONFIG_VIDEO_RENESAS_JPU=y
--
2.7.4
