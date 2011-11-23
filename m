Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab1KWVXw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 16:23:52 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pANLNp5L011293
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 23 Nov 2011 16:23:51 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 1/2] [media] ir-nec-decoder: Report what bit failed at debug msg
Date: Wed, 23 Nov 2011 19:23:38 -0200
Message-Id: <1322083419-27457-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/rc/ir-nec-decoder.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 63ee722..a825318 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -193,8 +193,8 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		return 0;
 	}
 
-	IR_dprintk(1, "NEC decode failed at state %d (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	IR_dprintk(1, "NEC decode failed at count %d state %d (%uus %s)\n",
+		   data->count, data->state, TO_US(ev.duration), TO_STR(ev.pulse));
 	data->state = STATE_INACTIVE;
 	return -EINVAL;
 }
-- 
1.7.7.1

