Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742Ab2HERo7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Aug 2012 13:44:59 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q75HixjD015382
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 5 Aug 2012 13:44:59 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] az6007: Update copyright
Date: Sun,  5 Aug 2012 14:44:55 -0300
Message-Id: <1344188695-9558-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update copyright comments after dvb-usb-v2 conversion.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb-v2/az6007.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb-v2/az6007.c b/drivers/media/dvb/dvb-usb-v2/az6007.c
index 420cb62..54f1221 100644
--- a/drivers/media/dvb/dvb-usb-v2/az6007.c
+++ b/drivers/media/dvb/dvb-usb-v2/az6007.c
@@ -7,9 +7,9 @@
  *	http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz
  * The original driver's license is GPL, as declared with MODULE_LICENSE()
  *
- * Copyright (c) 2010-2011 Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010-2012 Mauro Carvalho Chehab <mchehab@redhat.com>
  *	Driver modified by in order to work with upstream drxk driver, and
- *	tons of bugs got fixed.
+ *	tons of bugs got fixed, and converted to use dvb-usb-v2.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
-- 
1.7.11.2

