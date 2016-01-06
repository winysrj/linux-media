Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:38667 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbcAFXhz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jan 2016 18:37:55 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Benoit Parrot <bparrot@ti.com>
Subject: [Patch v6 2/3] MAINTAINERS: Add ti-vpe maintainer entry
Date: Wed, 6 Jan 2016 17:37:25 -0600
Message-ID: <1452123446-5424-3-git-send-email-bparrot@ti.com>
In-Reply-To: <1452123446-5424-1-git-send-email-bparrot@ti.com>
References: <1452123446-5424-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4635e1d14612..ebbdb410c0f0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10631,6 +10631,14 @@ L:	linux-omap@vger.kernel.org
 S:	Maintained
 F:	drivers/thermal/ti-soc-thermal/
 
+TI VPE/CAL DRIVERS
+M:	Benoit Parrot <bparrot@ti.com>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+Q:	http://patchwork.linuxtv.org/project/linux-media/list/
+S:	Maintained
+F:	drivers/media/platform/ti-vpe/
+
 TI CDCE706 CLOCK DRIVER
 M:	Max Filippov <jcmvbkbc@gmail.com>
 S:	Maintained
-- 
1.8.5.1

