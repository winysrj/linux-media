Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756379Ab2J0UmU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:20 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKgKg3020481
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:20 -0400
Received: from pedra (vpn1-4-98.gru2.redhat.com [10.97.4.98])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q9RKg4Jd017366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:20 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 40/68] [media] dt3155v4l: vb2_queue_init() can now fail. Check is required
Date: Sat, 27 Oct 2012 18:40:58 -0200
Message-Id: <1351370486-29040-41-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/staging/media/dt3155v4l/dt3155v4l.c: In function 'dt3155_open':
drivers/staging/media/dt3155v4l/dt3155v4l.c:399:17: warning: ignoring return value of 'vb2_queue_init', declared with attribute warn_unused_result [-Wunused-result]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 2e7b711..54f1813 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -396,7 +396,9 @@ dt3155_open(struct file *filp)
 		pd->q->drv_priv = pd;
 		pd->curr_buf = NULL;
 		pd->field_count = 0;
-		vb2_queue_init(pd->q); /* cannot fail */
+		ret = vb2_queue_init(pd->q);
+		if (ret < 0)
+			return ret;
 		INIT_LIST_HEAD(&pd->dmaq);
 		spin_lock_init(&pd->lock);
 		/* disable all irqs, clear all irq flags */
-- 
1.7.11.7

