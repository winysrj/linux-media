Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab3DAOuu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Apr 2013 10:50:50 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] siano: Fix array boundary at smscore_translate_msg()
Date: Mon,  1 Apr 2013 11:50:45 -0300
Message-Id: <1364827845-20070-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by Dan Carpenter:
	FYI, there are new smatch warnings show up in

	tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next master
	head:   da17d7bda957ae4697b6abc0793f74fb9b50b58f
	commit: 4c3bdb5e2f5612ceb99ac17dbbe673b59a94d105 [media] siano: better debug send/receive messages

	drivers/media/common/siano/smscoreapi.c:396 smscore_translate_msg() error: buffer overflow 'siano_msgs' 401 <= 401

While it is almost impossible for this error to happen in
practice, as it would require the siano's firmware to return
an special invalid answer to a message request, fixing it
is trivial. So, let's do it.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smscoreapi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index ebb9ece..45ac9ee 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -389,7 +389,7 @@ char *smscore_translate_msg(enum msg_types msgtype)
 	int i = msgtype - MSG_TYPE_BASE_VAL;
 	char *msg;
 
-	if (i < 0 || i > ARRAY_SIZE(siano_msgs))
+	if (i < 0 || i >= ARRAY_SIZE(siano_msgs))
 		return "Unknown msg type";
 
 	msg = siano_msgs[i];
-- 
1.8.1.4

