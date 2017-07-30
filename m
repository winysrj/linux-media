Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:41230 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750991AbdG3NHy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Jul 2017 09:07:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/4] dt-bindings: adi,adv7511.txt: document cec clock
Date: Sun, 30 Jul 2017 15:07:40 +0200
Message-Id: <20170730130743.19681-2-hverkuil@xs4all.nl>
In-Reply-To: <20170730130743.19681-1-hverkuil@xs4all.nl>
References: <20170730130743.19681-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the cec clock binding.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
index 06668bca7ffc..4497ae054d49 100644
--- a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
+++ b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
@@ -68,6 +68,8 @@ Optional properties:
 - adi,disable-timing-generator: Only for ADV7533. Disables the internal timing
   generator. The chip will rely on the sync signals in the DSI data lanes,
   rather than generate its own timings for HDMI output.
+- clocks: from common clock binding: handle to CEC clock.
+- clock-names: from common clock binding: must be "cec".
 
 Required nodes:
 
@@ -89,6 +91,8 @@ Example
 		reg = <39>;
 		interrupt-parent = <&gpio3>;
 		interrupts = <29 IRQ_TYPE_EDGE_FALLING>;
+		clocks = <&cec_clock>;
+		clock-names = "cec";
 
 		adi,input-depth = <8>;
 		adi,input-colorspace = "rgb";
-- 
2.13.1
