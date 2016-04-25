Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36650 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbcDYA2P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 20:28:15 -0400
From: Eric Engestrom <eric@engestrom.ch>
To: linux-kernel@vger.kernel.org
Cc: Eric Engestrom <eric@engestrom.ch>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Michal Simek <michal.simek@xilinx.com>,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 14/41] Documentation: dt: media: fix spelling mistake
Date: Mon, 25 Apr 2016 01:24:11 +0100
Message-Id: <1461543878-3639-15-git-send-email-eric@engestrom.ch>
In-Reply-To: <1461543878-3639-1-git-send-email-eric@engestrom.ch>
References: <1461543878-3639-1-git-send-email-eric@engestrom.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Eric Engestrom <eric@engestrom.ch>
---
 Documentation/devicetree/bindings/media/xilinx/video.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/xilinx/video.txt b/Documentation/devicetree/bindings/media/xilinx/video.txt
index cbd46fa..68ac210 100644
--- a/Documentation/devicetree/bindings/media/xilinx/video.txt
+++ b/Documentation/devicetree/bindings/media/xilinx/video.txt
@@ -20,7 +20,7 @@ The following properties are common to all Xilinx video IP cores.
 - xlnx,video-format: This property represents a video format transmitted on an
   AXI bus between video IP cores, using its VF code as defined in "AXI4-Stream
   Video IP and System Design Guide" [UG934]. How the format relates to the IP
-  core is decribed in the IP core bindings documentation.
+  core is described in the IP core bindings documentation.
 
 - xlnx,video-width: This property qualifies the video format with the sample
   width expressed as a number of bits per pixel component. All components must
-- 
2.8.0

