Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49195 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbaHLVub (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 17:50:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 10/10] Add missing viterbi lock
Date: Tue, 12 Aug 2014 18:50:24 -0300
Message-Id: <1407880224-374-11-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
References: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/as102_fe.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/as102_fe.c b/drivers/media/dvb-frontends/as102_fe.c
index b272e4ea1860..ef4c3c667782 100644
--- a/drivers/media/dvb-frontends/as102_fe.c
+++ b/drivers/media/dvb-frontends/as102_fe.c
@@ -325,11 +325,12 @@ static int as102_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
 		break;
 	case TUNE_STATUS_STREAM_DETECTED:
-		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_SYNC;
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_SYNC |
+			  FE_HAS_VITERBI;
 		break;
 	case TUNE_STATUS_STREAM_TUNED:
 		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_SYNC |
-			FE_HAS_LOCK;
+			  FE_HAS_LOCK | FE_HAS_VITERBI;
 		break;
 	default:
 		*status = TUNE_STATUS_NOT_TUNED;
-- 
1.9.3

