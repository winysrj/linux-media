Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:43838 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752305AbdJTKHh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 06:07:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/4] arm: dts: rockchip: define the two possible CEC pins
Date: Fri, 20 Oct 2017 12:07:33 +0200
Message-Id: <20171020100734.17064-4-hverkuil@xs4all.nl>
In-Reply-To: <20171020100734.17064-1-hverkuil@xs4all.nl>
References: <20171020100734.17064-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The CEC line can be routed to two possible pins. Define those pins.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index a48352aa1591..2421913bc1fd 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -1431,6 +1431,14 @@
 				rockchip,pins = <7 19 RK_FUNC_2 &pcfg_pull_none>,
 						<7 20 RK_FUNC_2 &pcfg_pull_none>;
 			};
+
+			hdmi_cec_c0: hdmi-cec-c0 {
+				rockchip,pins = <7 RK_PC0 RK_FUNC_2 &pcfg_pull_none>;
+			};
+
+			hdmi_cec_c7: hdmi-cec-c7 {
+				rockchip,pins = <7 RK_PC7 RK_FUNC_4 &pcfg_pull_none>;
+			};
 		};
 
 		pcfg_pull_up: pcfg-pull-up {
-- 
2.14.1
