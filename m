Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757598Ab3CYM4G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 08:56:06 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2PCu5ba009049
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 08:56:05 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/3] tuner-core: handle errors when getting signal strength/afc
Date: Mon, 25 Mar 2013 09:55:59 -0300
Message-Id: <1364216159-12707-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1364216159-12707-1-git-send-email-mchehab@redhat.com>
References: <201303251232.31456.hverkuil@xs4all.nl>
 <1364216159-12707-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If those callbacks fail, it should return zero, and not a random
value.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/v4l2-core/tuner-core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index f1e8b40..cf9a9af 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -220,18 +220,20 @@ static void fe_standby(struct dvb_frontend *fe)
 
 static int fe_has_signal(struct dvb_frontend *fe)
 {
-	u16 strength = 0;
+	u16 strength;
 
-	fe->ops.tuner_ops.get_rf_strength(fe, &strength);
+	if (fe->ops.tuner_ops.get_rf_strength(fe, &strength) < 0)
+		return 0;
 
 	return strength;
 }
 
 static int fe_get_afc(struct dvb_frontend *fe)
 {
-	s32 afc = 0;
+	s32 afc;
 
-	fe->ops.tuner_ops.get_afc(fe, &afc);
+	if (fe->ops.tuner_ops.get_afc(fe, &afc) < 0)
+		return 0;
 
 	return afc;
 }
-- 
1.8.1.4

