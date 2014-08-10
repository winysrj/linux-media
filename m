Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55272 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaHJArh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 20:47:37 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 17/18] [media] xc5000: add a resume function
Date: Sat,  9 Aug 2014 21:47:23 -0300
Message-Id: <1407631644-11990-18-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
References: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If a device suspends/hibertates with a station tuned, restore
the tuner station at resume.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/xc5000.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index 78695ed4549c..140c537bcfcc 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -1354,6 +1354,7 @@ static const struct dvb_tuner_ops xc5000_tuner_ops = {
 	.init		   = xc5000_init,
 	.sleep		   = xc5000_sleep,
 	.suspend	   = xc5000_suspend,
+	.resume		   = xc5000_apply_params,
 
 	.set_config	   = xc5000_set_config,
 	.set_params	   = xc5000_set_params,
-- 
1.9.3

