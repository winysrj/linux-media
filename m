Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:59536 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaKQMSI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 07:18:08 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [REVIEW PATCH 5/5] MAINTAINERS: Add myself as img-ir maintainer
Date: Mon, 17 Nov 2014 12:17:49 +0000
Message-ID: <1416226669-2983-6-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1416226669-2983-1-git-send-email-james.hogan@imgtec.com>
References: <1416226669-2983-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add myself as the maintainer for the Imagination Technologies Infrared
Decoder driver.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ea4d0058fd1b..814cf15448ad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4757,6 +4757,11 @@ L:	linux-security-module@vger.kernel.org
 S:	Supported
 F:	security/integrity/ima/
 
+IMGTEC IR DECODER DRIVER
+M:	James Hogan <james.hogan@imgtec.com>
+S:	Maintained
+F:	drivers/media/rc/img-ir/
+
 IMS TWINTURBO FRAMEBUFFER DRIVER
 L:	linux-fbdev@vger.kernel.org
 S:	Orphan
-- 
2.0.4

