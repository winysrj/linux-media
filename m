Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab3AVLQJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 06:16:09 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0MBG9OY018375
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 06:16:09 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/7] [media] mb86a20s: fix interleaving and FEC retrival
Date: Tue, 22 Jan 2013 09:15:30 -0200
Message-Id: <1358853333-21554-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358853333-21554-1-git-send-email-mchehab@redhat.com>
References: <1358853333-21554-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get the proper bits from the TMCC table registers.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 40c6183..8f4fff1 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -413,7 +413,7 @@ static int mb86a20s_get_modulation(struct mb86a20s_state *state,
 	rc = mb86a20s_readreg(state, 0x6e);
 	if (rc < 0)
 		return rc;
-	switch ((rc & 0x70) >> 4) {
+	switch ((rc >> 4) & 0x07) {
 	case 0:
 		return DQPSK;
 	case 1:
@@ -446,7 +446,7 @@ static int mb86a20s_get_fec(struct mb86a20s_state *state,
 	rc = mb86a20s_readreg(state, 0x6e);
 	if (rc < 0)
 		return rc;
-	switch (rc) {
+	switch ((rc >> 4) & 0x07) {
 	case 0:
 		return FEC_1_2;
 	case 1:
@@ -481,9 +481,21 @@ static int mb86a20s_get_interleaving(struct mb86a20s_state *state,
 	rc = mb86a20s_readreg(state, 0x6e);
 	if (rc < 0)
 		return rc;
-	if (rc > 3)
-		return -EINVAL;	/* Not used */
-	return rc;
+
+	switch ((rc >> 4) & 0x07) {
+	case 1:
+		return GUARD_INTERVAL_1_4;
+	case 2:
+		return GUARD_INTERVAL_1_8;
+	case 3:
+		return GUARD_INTERVAL_1_16;
+	case 4:
+		return GUARD_INTERVAL_1_32;
+
+	default:
+	case 0:
+		return GUARD_INTERVAL_AUTO;
+	}
 }
 
 static int mb86a20s_get_segment_count(struct mb86a20s_state *state,
-- 
1.7.11.7

