Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933037Ab3CSQuR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:17 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 45/46] [media] siano: remove doubled new line
Date: Tue, 19 Mar 2013 13:49:34 -0300
Message-Id: <1363711775-2120-46-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

sms_debug() and sms_info() already adds a '\n' at the printed
strings. No need to add more.

That helps to cleanup stuff like:
	[ 4868.205648] smscore_onresponse: message not handled.

	[ 4868.205898] smscore_onresponse: message not handled.

and:
	[ 5467.959769] smscore_onresponse:
	data rate 143069 bytes/secs

While here, provides the message name, when the message is not
handled by the smsmdtv core.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c  | 6 ++++--
 drivers/media/common/siano/smsdvb-main.c | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 5bfeeee..244928b 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -1496,7 +1496,7 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 		last_sample_time = time_now;
 
 	if (time_now - last_sample_time > 10000) {
-		sms_debug("\ndata rate %d bytes/secs",
+		sms_debug("data rate %d bytes/secs",
 			  (int)((data_total * 1000) /
 				(time_now - last_sample_time)));
 
@@ -1607,7 +1607,9 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 			break;
 
 		default:
-			sms_debug("message not handled.\n");
+			sms_debug("message %s(%d) not handled.",
+				  smscore_translate_msg(phdr->msgType),
+				  phdr->msgType);
 			break;
 		}
 		smscore_putbuffer(coredev, cb);
diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index ce6ba7b..7f84b5c 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -948,7 +948,7 @@ static int smsdvb_isdbt_set_frontend(struct dvb_frontend *fe)
 
 	c->bandwidth_hz = 6000000;
 
-	sms_info("%s: freq %d segwidth %d segindex %d\n", __func__,
+	sms_info("%s: freq %d segwidth %d segindex %d", __func__,
 		 c->frequency, c->isdbt_sb_segment_count,
 		 c->isdbt_sb_segment_idx);
 
-- 
1.8.1.4

