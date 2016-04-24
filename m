Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35704 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbcDXVK0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:26 -0400
Received: by mail-wm0-f66.google.com with SMTP id e201so17587325wme.2
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:25 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
Subject: [RFC PATCH 12/24] dt: bindings: Add CSI1/CCP2 related properties to video-interfaces.txt
Date: Mon, 25 Apr 2016 00:08:12 +0300
Message-Id: <1461532104-24032-13-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Document the CSI1/CCP2 properties strobe_clk_inv and strobe_clock
properties. The former tells whether the strobe/clock signal is inverted,
while the latter signifies the clock or strobe mode.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index f5b61bd..f0523f7 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -114,9 +114,10 @@ Optional endpoint properties
   lane and followed by the data lanes in the same order as in data-lanes.
   Valid values are 0 (normal) and 1 (inverted). The length of the array
   should be the combined length of data-lanes and clock-lanes properties.
-  If the lane-polarities property is omitted, the value must be interpreted
-  as 0 (normal). This property is valid for serial busses only.
-
+- clock-inv: Clock or strobe signal inversion.
+  Possible values: 0 -- not inverted; 1 -- inverted
+- strobe: Whether the clock signal is used as clock or strobe. Used
+  with CCP2, for instance.
 
 Example
 -------
-- 
1.9.1

