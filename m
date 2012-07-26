Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.matrix-vision.com ([85.214.244.251]:45770 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2GZP3L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 11:29:11 -0400
Received: from mail2.matrix-vision.com (localhost [127.0.0.1])
	by mail2.matrix-vision.com (Postfix) with ESMTP id D277D3F669
	for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 17:29:10 +0200 (CEST)
Received: from erinome (g2.matrix-vision.com [80.152.136.245])
	by mail2.matrix-vision.com (Postfix) with ESMTPA id ACF123F652
	for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 17:29:10 +0200 (CEST)
Received: from erinome (localhost [127.0.0.1])
	by erinome (Postfix) with ESMTP id 57DE76F8A
	for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 17:29:10 +0200 (CEST)
Received: from ap437-joe.intern.matrix-vision.de (host65-86.intern.matrix-vision.de [192.168.65.86])
	by erinome (Postfix) with ESMTPA id 29AEB6F8A
	for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 17:29:10 +0200 (CEST)
From: Michael Jones <michael.jones@matrix-vision.de>
To: linux-media@vger.kernel.org
Subject: [PATCH] omap3isp: #include videodev2.h in omap3isp.h
Date: Thu, 26 Jul 2012 17:31:51 +0200
Message-Id: <1343316711-22196-1-git-send-email-michael.jones@matrix-vision.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

include/linux/omap3isp.h uses BASE_VIDIOC_PRIVATE from include/linux/videodev2.h
but didn't include this file.

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---
 include/linux/omap3isp.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/omap3isp.h b/include/linux/omap3isp.h
index c73a34c..e7a79db 100644
--- a/include/linux/omap3isp.h
+++ b/include/linux/omap3isp.h
@@ -28,6 +28,7 @@
 #define OMAP3_ISP_USER_H
 
 #include <linux/types.h>
+#include <linux/videodev2.h>
 
 /*
  * Private IOCTLs
-- 
1.7.4.1


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
