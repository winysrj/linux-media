Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758771Ab0DAR6c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 13:58:32 -0400
Date: Thu, 1 Apr 2010 14:56:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 01/15] V4L/DVB: ir-core: be less pedantic with RC protocol
 name
Message-ID: <20100401145632.0734d918@pedra>
In-Reply-To: <cover.1270142346.git.mchehab@redhat.com>
References: <cover.1270142346.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index bbddf2f..ee6b36d 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -92,7 +92,7 @@ static ssize_t store_protocol(struct device *d,
 
 	buf = strsep((char **) &data, "\n");
 
-	if (!strcasecmp(buf, "rc-5"))
+	if (!strcasecmp(buf, "rc-5") || !strcasecmp(buf, "rc5"))
 		ir_type = IR_TYPE_RC5;
 	else if (!strcasecmp(buf, "pd"))
 		ir_type = IR_TYPE_PD;
-- 
1.6.6.1


