Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:36607 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750974AbdJGKrD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 7 Oct 2017 06:47:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Archit Taneja <architt@codeaurora.org>,
        linux-renesas-soc@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 1/2] dt-bindings: adi,adv7511.txt: document cec clock
Date: Sat,  7 Oct 2017 12:46:57 +0200
Message-Id: <20171007104658.14528-2-hverkuil@xs4all.nl>
In-Reply-To: <20171007104658.14528-1-hverkuil@xs4all.nl>
References: <20171007104658.14528-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the cec clock binding.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
index 06668bca7ffc..0047b1394c70 100644
--- a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
+++ b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
@@ -68,6 +68,8 @@ Optional properties:
 - adi,disable-timing-generator: Only for ADV7533. Disables the internal timing
   generator. The chip will rely on the sync signals in the DSI data lanes,
   rather than generate its own timings for HDMI output.
+- clocks: from common clock binding: reference to the CEC clock.
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
2.14.1
