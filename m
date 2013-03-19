Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933132Ab3CSQuT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:19 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 43/46] [media] siano: add a MAINTAINERS entry for it
Date: Tue, 19 Mar 2013 13:49:32 -0300
Message-Id: <1363711775-2120-44-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nobody is maintaining this driver. The project started by a
developer that used to work at Hauppauge. A Siano developer
assumed its maintainership after that, but he left the company.
Another Siano developer sent several patches updating it, but,
after upstream feedback, it seems he gave up merging the driver,
as he never answered back to the received feedbacks.

As I have a few siano devices here that work with ISDB-T, I
can help to keep it into a good shape. So, better to take its
maintainership.

I don't have any siano SDIO setup here, trough. So, I'll just
apply without any test any patch that looks sane and touches
only drivers/media/mmc/siano. So, let's tag it as "Odd fixes".

Cc: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 90e1797..8d8e762 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7038,6 +7038,17 @@ F:	drivers/media/radio/si470x/radio-si470x-common.c
 F:	drivers/media/radio/si470x/radio-si470x.h
 F:	drivers/media/radio/si470x/radio-si470x-usb.c
 
+SIANO DVB DRIVER
+M:	Mauro Carvalho Chehab <mchehab@redhat.com>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Odd fixes
+F:	drivers/media/common/siano/
+F:	drivers/media/dvb/siano/
+F:	drivers/media/usb/siano/
+F:	drivers/media/mmc/siano
+
 SH_VEU V4L2 MEM2MEM DRIVER
 M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
 L:	linux-media@vger.kernel.org
-- 
1.8.1.4

