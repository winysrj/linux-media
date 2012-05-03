Return-path: <linux-media-owner@vger.kernel.org>
Received: from libri.sur5r.net ([217.8.61.68]:47809 "EHLO libri.sur5r.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab2ECAjG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 May 2012 20:39:06 -0400
Received: from samsa.ccchd.dn42 (localhost [127.0.0.1])
	by samsa (Postfix) with ESMTP id A368D2D9032
	for <linux-media@vger.kernel.org>; Thu,  3 May 2012 02:33:29 +0200 (CEST)
Date: Thu, 3 May 2012 02:33:27 +0200
From: Jakob Haufe <sur5r@sur5r.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] Add quirk for camera of Lenovo Thinkpad X220 Tablet
Message-ID: <20120503023327.085062b7@samsa.ccchd.dn42>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 lib/libv4lconvert/control/libv4lcontrol.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/libv4lconvert/control/libv4lcontrol.c
b/lib/libv4lconvert/control/libv4lcontrol.c index e802a90..f9fda71 100644
--- a/lib/libv4lconvert/control/libv4lcontrol.c
+++ b/lib/libv4lconvert/control/libv4lcontrol.c
@@ -134,6 +134,8 @@ static const struct v4lcontrol_flags_info
v4lcontrol_flags[] = { "FUJITSU", "LIFEBOOK NH751" },
 	{ 0x04f2, 0xb217, 0, "LENOVO", "42992QG",
 		V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED },
+	{ 0x04f2, 0xb217, 0, "LENOVO", "42982YG",
+		V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED },
 	{ 0x04f2, 0xb27c, 0, "LENOVO", "12973MG",
 		V4LCONTROL_HFLIPPED | V4LCONTROL_VFLIPPED, 0, NULL, NULL,
NULL, "ThinkPad Edge E325" },
-- 
1.7.10
