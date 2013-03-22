Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933711Ab3CVQQJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 12:16:09 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2MGG9xW023551
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 22 Mar 2013 12:16:09 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] [media] drxk: fix CNR calculus
Date: Fri, 22 Mar 2013 13:16:01 -0300
Message-Id: <1363968963-7841-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changeset 8f3741e accidentally broke the CNR estimation. It should
be calculated as "a + b - c". However, previously, the subtraction
by c only occurred if SNR would be positive, due to a bad binding
to DVBv3 API.

This also fixes the following warning:
	drivers/media/dvb-frontends/drxk_hard.c:2556:6: warning: variable 'c' set but not used [-Wunused-but-set-variable]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/drxk_hard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index fc93bd3..55a4c22 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -2628,7 +2628,7 @@ static int GetDVBTSignalToNoise(struct drxk_state *state,
 		/* log(x) x = (16bits + 16bits) << 15 ->32 bits  */
 		c = Log10Times100(SqrErrIQ);
 
-		iMER = a + b;
+		iMER = a + b - c;
 	}
 	*pSignalToNoise = iMER;
 
-- 
1.8.1.4

