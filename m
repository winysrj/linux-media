Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:50718 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755941AbbFCOAL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2015 10:00:11 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: guennadi liakhovetski <g.liakhovetski@gmx.de>,
	sergei shtylyov <sergei.shtylyov@cogentembedded.com>,
	hans verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 07/15] ARM: shmobile: lager dts: specify default-input for ADV7612
Date: Wed,  3 Jun 2015 14:59:54 +0100
Message-Id: <1433340002-1691-8-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk>
References: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk>
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
index 90c4531..6946e9a 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -544,6 +544,7 @@
 		port {
 			hdmi_in_ep: endpoint {
 				remote-endpoint = <&vin0ep0>;
+				default-input = <0>;
 			};
 		};
 	};
-- 
1.7.10.4

