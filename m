Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:53654 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752871AbbHMLg6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 07:36:58 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: linux-sh@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 3/3] ARM: shmobile: lager dts: specify default-input for ADV7612
Date: Thu, 13 Aug 2015 12:36:51 +0100
Message-Id: <1439465811-936-4-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1439465811-936-1-git-send-email-william.towle@codethink.co.uk>
References: <1439465811-936-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ian Molton <ian.molton@codethink.co.uk>

Set the 'default-input' property for ADV7612, enabling image and video
capture without the need to have userspace specifying routing.

(This version places the property in the adv7612 node, in line with
Ian's documentation)

Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
Signed-off-by: William Towle <william.towle@codethink.co.uk>
---
 arch/arm/boot/dts/r8a7790-lager.dts |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
index 31854bc..12e1cfa 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -547,6 +547,7 @@
 	hdmi-in@4c {
 		compatible = "adi,adv7612";
 		reg = <0x4c>;
+		default-input = <0>;
 
 		port {
 			hdmi_in_ep: endpoint {
-- 
1.7.10.4

