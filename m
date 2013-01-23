Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab3AWUsM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 15:48:12 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0NKmCFO017895
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 23 Jan 2013 15:48:12 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] dvb_frontend: print a msg if a property doesn't exist
Date: Wed, 23 Jan 2013 18:48:08 -0200
Message-Id: <1358974088-10622-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If userspace calls a property that doesn't exist, it currently
just returns -EINVAL. However, this is more likely a problem at
the userspace application, calling it with a non-existing property.

So, add a debug message to help tracking it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index f8943c2..36bee91 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1479,6 +1479,9 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 		tvp->u.st = c->block_count;
 		break;
 	default:
+		dev_dbg(fe->dvb->device,
+			"%s: FE property %d doesn't exist\n",
+			__func__, tvp->cmd);
 		return -EINVAL;
 	}
 
-- 
1.8.1

