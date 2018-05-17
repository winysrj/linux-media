Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:57704 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750819AbeEQEAt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 00:00:49 -0400
From: bingbu.cao@intel.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, bingbu.cao@linux.intel.com,
        tian.shu.qiu@linux.intel.com, rajmohan.mani@intel.com,
        mchehab@kernel.org
Subject: [PATCH 1/3] dt-bindings: Add vendor prefix for AKM
Date: Thu, 17 May 2018 12:03:12 +0800
Message-Id: <1526529794-25569-1-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bingbu Cao <bingbu.cao@intel.com>

Asahi Kasei Microdevices (AKM) offer a variety of
advanced sensing devices based on compound semiconductor
technology and sophisticated IC products featuring
analog/digital mixed-signal technology.

Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
---
 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index b5f978a4cac6..0e6159665e66 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -14,6 +14,7 @@ adh	AD Holdings Plc.
 adi	Analog Devices, Inc.
 advantech	Advantech Corporation
 aeroflexgaisler	Aeroflex Gaisler AB
+akm	Asahi Kasei Microdevices
 al	Annapurna Labs
 allo	Allo.com
 allwinner	Allwinner Technology Co., Ltd.
-- 
1.9.1
