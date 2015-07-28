Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:49970 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751628AbbG1QRy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 12:17:54 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org
Subject: [PATCH 2/2] ARM: shmobile: lager dts: specify default-input for ADV7612
Date: Tue, 28 Jul 2015 17:17:44 +0100
Message-Id: <1438100264-17280-3-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1438100264-17280-1-git-send-email-william.towle@codethink.co.uk>
References: <1438100264-17280-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set 'default-input' property for ADV7612. Enables image/video capture
without the need to have userspace specifying routing.

Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
Tested-by: William Towle <william.towle@codethink.co.uk>
---
 arch/arm/boot/dts/r8a7790-lager.dts |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
index aec7db6..e537052 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -552,6 +552,7 @@
 		port {
 			hdmi_in_ep: endpoint {
 				remote-endpoint = <&vin0ep0>;
+				default-input = <0>;
 			};
 		};
 	};
-- 
1.7.10.4

