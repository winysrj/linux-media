Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499Ab3CCP65 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Mar 2013 10:58:57 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r23FwvNT021684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 3 Mar 2013 10:58:57 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 04/11] [media] mb86a20s: Fix signal strength calculus
Date: Sun,  3 Mar 2013 12:58:44 -0300
Message-Id: <1362326331-17541-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1362326331-17541-1-git-send-email-mchehab@redhat.com>
References: <1362326331-17541-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A register typo made the calculation to not work. Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index e222e55..983fb3b 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -335,7 +335,7 @@ static int mb86a20s_read_signal_strength(struct dvb_frontend *fe)
 		rc = mb86a20s_writereg(state, 0x04, 0x20);
 		if (rc < 0)
 			return rc;
-		rc = mb86a20s_writereg(state, 0x04, rf);
+		rc = mb86a20s_writereg(state, 0x05, rf);
 		if (rc < 0)
 			return rc;
 
-- 
1.8.1.4

