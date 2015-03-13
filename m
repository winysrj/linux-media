Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40745 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbbCMADa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 20:03:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: =?UTF-8?q?Carlos=20Sanmart=C3=ADn=20Bustos?= <carsanbu@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 1/2] of: Add vendor prefix for Aptina Imaging
Date: Fri, 13 Mar 2015 02:03:27 +0200
Message-Id: <1426205008-6160-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

Aptina has recently been acquired by ON Semiconductor, but the name Aptina is
still widely used. Should the onnn prefix be used instead ?

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 389ca13..4326f52 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -20,6 +20,7 @@ amlogic	Amlogic, Inc.
 ams	AMS AG
 amstaos	AMS-Taos Inc.
 apm	Applied Micro Circuits Corporation (APM)
+aptina	Aptina Imaging
 arm	ARM Ltd.
 armadeus	ARMadeus Systems SARL
 asahi-kasei	Asahi Kasei Corp.
-- 
Regards,

Laurent Pinchart

