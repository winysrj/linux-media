Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758505Ab3DAOnJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Apr 2013 10:43:09 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 3/5] [media] mb86a20s: fix audio sub-channel check
Date: Mon,  1 Apr 2013 11:41:57 -0300
Message-Id: <1364827319-18332-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1364827319-18332-1-git-send-email-mchehab@redhat.com>
References: <20130401072529.GL18466@mwanda>
 <1364827319-18332-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by Dan Carpenter <dan.carpenter@oracle.com>

FYI, there are new smatch warnings show up in:

	tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next master
	head:   da17d7bda957ae4697b6abc0793f74fb9b50b58f
	commit: 04fa725e7b1c22c583dd71a8cd85b8d997edfce3 [media] mb86a20s: Implement set_frontend cache logic

	New smatch warnings:
	drivers/media/dvb-frontends/mb86a20s.c:1897 mb86a20s_set_frontend() error: buffer overflow 'mb86a20s_subchannel' 8 <= 8

	04fa725e Mauro Carvalho Chehab 2013-03-04  1894  		if (c->isdbt_sb_subchannel > ARRAY_SIZE(mb86a20s_subchannel))
	04fa725e Mauro Carvalho Chehab 2013-03-04  1895  			c->isdbt_sb_subchannel = 0;
	04fa725e Mauro Carvalho Chehab 2013-03-04  1896
	04fa725e Mauro Carvalho Chehab 2013-03-04 @1897  		state->subchannel = mb86a20s_subchannel[c->isdbt_sb_subchannel];

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 6ff1375..2666ff4 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -1915,7 +1915,7 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 	if (!c->isdbt_sb_mode) {
 		state->subchannel = 0;
 	} else {
-		if (c->isdbt_sb_subchannel > ARRAY_SIZE(mb86a20s_subchannel))
+		if (c->isdbt_sb_subchannel >= ARRAY_SIZE(mb86a20s_subchannel))
 			c->isdbt_sb_subchannel = 0;
 
 		state->subchannel = mb86a20s_subchannel[c->isdbt_sb_subchannel];
-- 
1.8.1.4

