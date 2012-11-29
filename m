Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:53381 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2K2KA5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 05:00:57 -0500
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 2A15640B98
	for <linux-media@vger.kernel.org>; Thu, 29 Nov 2012 11:00:52 +0100 (CET)
Date: Thu, 29 Nov 2012 11:00:52 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: add entries for sh_veu and sh_vou V4L2 drivers
Message-ID: <Pine.LNX.4.64.1211291100230.11210@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

sh_vou might be better described by "Odd Fixes," but mark it "Maintained"
for now. sh_veu is a new driver and might see some development in the
future.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 MAINTAINERS |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9fba9ed..c20199e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6719,6 +6719,20 @@ M:	Robin Holt <holt@sgi.com>
 S:	Maintained
 F:	drivers/misc/sgi-xp/
 
+SH_VEU V4L2 MEM2MEM DRIVER
+M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/platform/sh_veu.c
+F:	include/media/sh_veu.h
+
+SH_VOU V4L2 OUTPUT DRIVER
+M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/platform/sh_vou.c
+F:	include/media/sh_vou.h
+
 SIMPLE FIRMWARE INTERFACE (SFI)
 M:	Len Brown <lenb@kernel.org>
 L:	sfi-devel@simplefirmware.org
-- 
1.7.2.5

