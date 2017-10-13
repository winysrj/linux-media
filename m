Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:52077 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753192AbdJMWxv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 18:53:51 -0400
From: Pierre-Hugues Husson <phh@phh.me>
To: linux-rockchip@lists.infradead.org
Cc: heiko@sntech.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Pierre-Hugues Husson <phh@phh.me>
Subject: [PATCH 3/3] arm64: dts: rockchip: enable cec pin for rk3399 firefly
Date: Sat, 14 Oct 2017 00:53:37 +0200
Message-Id: <20171013225337.5196-4-phh@phh.me>
In-Reply-To: <20171013225337.5196-1-phh@phh.me>
References: <20171013225337.5196-1-phh@phh.me>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Pierre-Hugues Husson <phh@phh.me>
---
 arch/arm64/boot/dts/rockchip/rk3399-firefly.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts b/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
index f6fbcc05073e..431ff1bb3720 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
@@ -257,6 +257,8 @@
 
 &hdmi {
 	ddc-i2c-bus = <&i2c3>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&hdmi_cec>;
 	status = "okay";
 };
 
-- 
2.14.1
