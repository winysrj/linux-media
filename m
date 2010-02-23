Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1190 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360Ab0BWRIV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 12:08:21 -0500
Subject: [PATCH - next] MAINTAINERS: Telegent tlg2300 section fix
From: Joe Perches <joe@perches.com>
To: Huang Shijie <shijie8@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Feb 2010 09:08:20 -0800
Message-ID: <1266944900.9265.28.camel@Joe-Laptop.home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

linux-next commit 2ff8223957d901999bf76aaf2c6183e33a6ad14e
exposes an infinite loop defect in scripts/get_maintainer.pl

Fix the incorrect format of the MAINTAINERS "M:" entries.

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/MAINTAINERS b/MAINTAINERS
index 57305f6..e633460 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4775,13 +4775,12 @@ F:	drivers/media/video/*7146*
 F:	include/media/*7146*
 
 TLG2300 VIDEO4LINUX-2 DRIVER
-M 	Huang Shijie	<shijie8@gmail.com>
-M 	Kang Yong	<kangyong@telegent.com>
-M 	Zhang Xiaobing	<xbzhang@telegent.com>
+M:	Huang Shijie <shijie8@gmail.com>
+M:	Kang Yong <kangyong@telegent.com>
+M:	Zhang Xiaobing <xbzhang@telegent.com>
 S:	Supported
 F:	drivers/media/video/tlg2300
 
-
 SC1200 WDT DRIVER
 M:	Zwane Mwaikambo <zwane@arm.linux.org.uk>
 S:	Maintained


