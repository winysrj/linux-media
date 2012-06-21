Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451Ab2FUNH6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 09:07:58 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5LD7vTG008251
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 09:07:57 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] smiapp-core: fix compilation build error
Date: Thu, 21 Jun 2012 10:07:48 -0300
Message-Id: <1340284068-7854-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

smiapp-core.c:2472:3: error: implicit declaration of function 'kzalloc' [-Werror=implicit-function-declaration]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/smiapp/smiapp-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/video/smiapp/smiapp-core.c b/drivers/media/video/smiapp/smiapp-core.c
index f518026..297acaf 100644
--- a/drivers/media/video/smiapp/smiapp-core.c
+++ b/drivers/media/video/smiapp/smiapp-core.c
@@ -31,6 +31,7 @@
 #include <linux/device.h>
 #include <linux/gpio.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/regulator/consumer.h>
 #include <linux/v4l2-mediabus.h>
 #include <media/v4l2-device.h>
-- 
1.7.10.2

