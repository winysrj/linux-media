Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933410Ab0DHThe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 15:37:34 -0400
Date: Thu, 8 Apr 2010 16:37:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 6/8] V4L/DVB: ir-core: fix gcc warning noise
Message-ID: <20100408163717.322a8d9c@pedra>
In-Reply-To: <cover.1270754989.git.mchehab@redhat.com>
References: <cover.1270754989.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/IR/ir-sysfs.c: In function ‘store_protocol’:
drivers/media/IR/ir-sysfs.c:93: warning: suggest parentheses around assignment used as truth value

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index 9d132d0..17d4341 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -90,7 +90,7 @@ static ssize_t store_protocol(struct device *d,
 	unsigned long flags;
 	char *buf;
 
-	while (buf = strsep((char **) &data, " \n")) {
+	while ((buf = strsep((char **) &data, " \n")) != NULL) {
 		if (!strcasecmp(buf, "rc-5") || !strcasecmp(buf, "rc5"))
 			ir_type |= IR_TYPE_RC5;
 		if (!strcasecmp(buf, "pd") || !strcasecmp(buf, "pulse-distance"))
-- 
1.6.6.1


