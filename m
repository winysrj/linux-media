Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:53357 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbbCLPqX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 11:46:23 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v13 06/13] of: Add Skyworks Solutions, Inc. vendor prefix
Date: Thu, 12 Mar 2015 16:45:07 +0100
Message-id: <1426175114-14876-7-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1426175114-14876-1-git-send-email-j.anaszewski@samsung.com>
References: <1426175114-14876-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use "skyworks" as the vendor prefix for the Skyworks Solutions, Inc.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 27249ad..f8164a1 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -159,6 +159,7 @@ ricoh	Ricoh Co. Ltd.
 rockchip	Fuzhou Rockchip Electronics Co., Ltd
 samsung	Samsung Semiconductor
 sandisk	Sandisk Corporation
+skyworks	Skyworks Solutions, Inc.
 sbs	Smart Battery System
 schindler	Schindler
 seagate	Seagate Technology PLC
-- 
1.7.9.5

