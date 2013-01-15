Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757191Ab3AOCbf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 21:31:35 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0F2VZMC010084
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Jan 2013 21:31:35 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv10 08/15] mb86a20s: fix interleaving and FEC retrival
Date: Tue, 15 Jan 2013 00:30:54 -0200
Message-Id: <1358217061-14982-9-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get the proper bits from the TMCC table registers.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index e069c9b..d14824a 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -360,7 +360,7 @@ static int mb86a20s_get_modulation(struct mb86a20s_state *state,
 	rc = mb86a20s_readreg(state, 0x6e);
 	if (rc < 0)
 		return rc;
-	switch ((rc & 0x70) >> 4) {
+	switch ((rc >> 4) & 0x07) {
 	case 0:
 		return DQPSK;
 	case 1:
@@ -393,7 +393,7 @@ static int mb86a20s_get_fec(struct mb86a20s_state *state,
 	rc = mb86a20s_readreg(state, 0x6e);
 	if (rc < 0)
 		return rc;
-	switch (rc) {
+	switch ((rc >> 4) & 0x07) {
 	case 0:
 		return FEC_1_2;
 	case 1:
@@ -428,9 +428,7 @@ static int mb86a20s_get_interleaving(struct mb86a20s_state *state,
 	rc = mb86a20s_readreg(state, 0x6e);
 	if (rc < 0)
 		return rc;
-	if (rc > 3)
-		return -EINVAL;	/* Not used */
-	return rc;
+	return (rc >> 4) & 0x07;
 }
 
 static int mb86a20s_get_segment_count(struct mb86a20s_state *state,
-- 
1.7.11.7

