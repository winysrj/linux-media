Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:36584 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752484AbZLMSy4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2009 13:54:56 -0500
Received: by ewy19 with SMTP id 19so2702809ewy.21
        for <linux-media@vger.kernel.org>; Sun, 13 Dec 2009 10:54:54 -0800 (PST)
Subject: [PATCH] MAINTAINERS file
From: Olivier Lorin <olorin75@gmail.com>
To: V4L Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain
Date: Sun, 13 Dec 2009 19:54:48 +0100
Message-Id: <1260730488.24064.3.camel@miniol>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch of the MAINTAINERS file to include the gspca_gl860 driver

Signed-off-by: Olivier Lorin <olorin75@gmail.com>
Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

---
diff ../orgn/MAINTAINERS MAINTAINERS -rupN
--- ../orgn/MAINTAINERS	2009-12-05 22:21:59.000000000 +0100
+++ MAINTAINERS	2009-09-20 03:35:18.000000000 +0200
@@ -2224,6 +2224,13 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 F:	drivers/media/video/gspca/finepix.c
 
+GSPCA GL860 SUBDRIVER
+M:	Olivier Lorin <olorin75@gmail.com>
+L:	linux-media@vger.kernel.org
+T:	git
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+S:	Maintained
+F:	drivers/media/video/gspca/gl860/
+
 GSPCA M5602 SUBDRIVER
 M:	Erik Andren <erik.andren@gmail.com>
 L:	linux-media@vger.kernel.org


