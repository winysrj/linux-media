Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:52521 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdJLQEB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 12:04:01 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] dt-bindings: media: xilinx: fix typo in example
Date: Fri, 13 Oct 2017 01:03:34 +0900
Message-Id: <1507824214-17744-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix typo s/:/;/

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Hyun Kwon <hyun.kwon@xilinx.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 Documentation/devicetree/bindings/media/xilinx/xlnx,v-tpg.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/xilinx/xlnx,v-tpg.txt b/Documentation/devicetree/bindings/media/xilinx/xlnx,v-tpg.txt
index 9dd86b3..439351a 100644
--- a/Documentation/devicetree/bindings/media/xilinx/xlnx,v-tpg.txt
+++ b/Documentation/devicetree/bindings/media/xilinx/xlnx,v-tpg.txt
@@ -66,6 +66,6 @@ Example:
 				tpg1_out: endpoint {
 					remote-endpoint = <&switch_in0>;
 				};
-			}:
+			};
 		};
 	};
-- 
2.7.4
