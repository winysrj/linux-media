Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882Ab3AOCbg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 21:31:36 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0F2VaKa003049
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Jan 2013 21:31:36 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv10 07/15] mb86a20s: improve debug for RF level
Date: Tue, 15 Jan 2013 00:30:53 -0200
Message-Id: <1358217061-14982-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 06e5d35..e069c9b 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -333,7 +333,8 @@ static int mb86a20s_read_signal_strength(struct dvb_frontend *fe)
 
 			/* Rescale it from 2^12 (4096) to 2^16 */
 			rf <<= (16 - 12);
-			dprintk("signal strength = %d\n", rf);
+			dprintk("signal strength = %d (%d < RF=%d < %d)\n", rf,
+				rf_min, rf, rf_max);
 			return (rf);
 		}
 	} while (1);
-- 
1.7.11.7

