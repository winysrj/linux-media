Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56470 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbbESLXx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 07:23:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jemma Denson <jdenson@gmail.com>,
	Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH 1/3] cx24120: don't initialize a var that won't be used
Date: Tue, 19 May 2015 08:23:36 -0300
Message-Id: <8bf9e159ce96223ad404207d94e8e3742f2474de.1432034614.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
drivers/media/dvb-frontends/cx24120.c: In function 'cx24120_message_send':
drivers/media/dvb-frontends/cx24120.c:368:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
  int ret, ficus;
      ^

The values written by cx24120 are never checked. So, remove the
check here too. That's said, the best would be to do the reverse,
but globally: to properly handle the error codes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/cx24120.c b/drivers/media/dvb-frontends/cx24120.c
index da50b9e1e9f8..3ab8582e233b 100644
--- a/drivers/media/dvb-frontends/cx24120.c
+++ b/drivers/media/dvb-frontends/cx24120.c
@@ -365,17 +365,17 @@ static void cx24120_check_cmd(struct cx24120_state *state, u8 id)
 static int cx24120_message_send(struct cx24120_state *state,
 				struct cx24120_cmd *cmd)
 {
-	int ret, ficus;
+	int ficus;
 
 	if (state->mpeg_enabled) {
 		/* Disable mpeg out on certain commands */
 		cx24120_check_cmd(state, cmd->id);
 	}
 
-	ret = cx24120_writereg(state, CX24120_REG_CMD_START, cmd->id);
-	ret = cx24120_writeregs(state, CX24120_REG_CMD_ARGS, &cmd->arg[0],
-				cmd->len, 1);
-	ret = cx24120_writereg(state, CX24120_REG_CMD_END, 0x01);
+	cx24120_writereg(state, CX24120_REG_CMD_START, cmd->id);
+	cx24120_writeregs(state, CX24120_REG_CMD_ARGS, &cmd->arg[0],
+			  cmd->len, 1);
+	cx24120_writereg(state, CX24120_REG_CMD_END, 0x01);
 
 	ficus = 1000;
 	while (cx24120_readreg(state, CX24120_REG_CMD_END)) {
-- 
2.1.0

