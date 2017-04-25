Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37347 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1176038AbdDYHjs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 03:39:48 -0400
Received: by mail-wm0-f50.google.com with SMTP id m123so87711867wma.0
        for <linux-media@vger.kernel.org>; Tue, 25 Apr 2017 00:39:48 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: khilman@baylibre.com, carlo@caione.org
Cc: Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM64: defconfig: enable IR core, decoders and Meson IR device
Date: Tue, 25 Apr 2017 09:39:40 +0200
Message-Id: <1493105980-19724-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enables the MEDIA Infrared RC Decoders and Meson Infrared
decoder for ARM64 defconfig.
These drivers are selected as modules by default.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 arch/arm64/configs/defconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index c021aefa..59c400f 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -321,6 +321,11 @@ CONFIG_MEDIA_CAMERA_SUPPORT=y
 CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
 CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
 CONFIG_MEDIA_CONTROLLER=y
+CONFIG_MEDIA_RC_SUPPORT=y
+CONFIG_RC_CORE=y
+CONFIG_RC_DEVICES=y
+CONFIG_RC_DECODERS=y
+CONFIG_IR_MESON=m
 CONFIG_VIDEO_V4L2_SUBDEV_API=y
 # CONFIG_DVB_NET is not set
 CONFIG_V4L_MEM2MEM_DRIVERS=y
-- 
1.9.1
