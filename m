Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab2IOVRR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 17:17:17 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8FLHG5I029280
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 15 Sep 2012 17:17:16 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] MAINTAINERS: Remove entries for drivers that got removed
Date: Sat, 15 Sep 2012 18:17:12 -0300
Message-Id: <1347743833-32689-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those two drivers got removed, as gspca replaced both. So,
remove the old entries.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 MAINTAINERS | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 91b79ba..ada8f05 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7130,14 +7130,6 @@ S:	Maintained
 F:	Documentation/usb/ehci.txt
 F:	drivers/usb/host/ehci*
 
-USB ET61X[12]51 DRIVER
-M:	Luca Risolia <luca.risolia@studio.unibo.it>
-L:	linux-usb@vger.kernel.org
-L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
-W:	http://www.linux-projects.org
-S:	Maintained
-F:	drivers/media/video/et61x251/
 
 USB GADGET/PERIPHERAL SUBSYSTEM
 M:	Felipe Balbi <balbi@ti.com>
@@ -7345,15 +7337,6 @@ W:	http://www.ideasonboard.org/uvc/
 S:	Maintained
 F:	drivers/media/usb/uvc/
 
-USB W996[87]CF DRIVER
-M:	Luca Risolia <luca.risolia@studio.unibo.it>
-L:	linux-usb@vger.kernel.org
-L:	linux-media@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
-W:	http://www.linux-projects.org
-S:	Maintained
-F:	Documentation/video4linux/w9968cf.txt
-F:	drivers/media/video/w996*
 
 USB WIRELESS RNDIS DRIVER (rndis_wlan)
 M:	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
-- 
1.7.11.4

