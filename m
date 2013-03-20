Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563Ab3CTOCU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 10:02:20 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2KE2K7N022886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 10:02:20 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/5] [media] dvb-core: don't clear stats at DTV_CLEAR
Date: Wed, 20 Mar 2013 11:02:16 -0300
Message-Id: <1363788136-14393-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363788136-14393-1-git-send-email-mchehab@redhat.com>
References: <1363788136-14393-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The stats are cleared by the frontend. Don't do it at DTV_CLEAR.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index a7317ae..b009b10 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -920,7 +920,7 @@ static int dvb_frontend_clear_cache(struct dvb_frontend *fe)
 	u32 delsys;
 
 	delsys = c->delivery_system;
-	memset(c, 0, sizeof(struct dtv_frontend_properties));
+	memset(c, 0, offsetof(struct dtv_frontend_properties, strength));
 	c->delivery_system = delsys;
 
 	c->state = DTV_CLEAR;
-- 
1.8.1.4

