Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757498Ab3CYM4F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 08:56:05 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2PCu55N007163
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 08:56:05 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] tuner-core: return afc instead of zero
Date: Mon, 25 Mar 2013 09:55:57 -0300
Message-Id: <1364216159-12707-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1364216159-12707-1-git-send-email-mchehab@redhat.com>
References: <201303251232.31456.hverkuil@xs4all.nl>
 <1364216159-12707-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While the driver gets AFC from the tuner, it doesn't return it
back via V4L2 API due to a mistake at the return. fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/v4l2-core/tuner-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index dd8a803..5e18f44 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -235,7 +235,7 @@ static int fe_get_afc(struct dvb_frontend *fe)
 	if (fe->ops.tuner_ops.get_afc)
 		fe->ops.tuner_ops.get_afc(fe, &afc);
 
-	return 0;
+	return afc;
 }
 
 static int fe_set_config(struct dvb_frontend *fe, void *priv_cfg)
-- 
1.8.1.4

