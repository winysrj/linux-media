Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41663 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031092AbbD1XEm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 19:04:42 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	stable@vger.kernel.org
Subject: [PATCH 07/13] s5h1420: fix a buffer overflow when checking userspace params
Date: Tue, 28 Apr 2015 20:04:29 -0300
Message-Id: <d9bd643d311310981ef28a224a3dd3a0ff0c7703.1430262253.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The maximum size for a DiSEqC command is 6, according to the
userspace API. However, the code allows to write up to 7 values:
	drivers/media/dvb-frontends/s5h1420.c:193 s5h1420_send_master_cmd() error: buffer overflow 'cmd->msg' 6 <= 7

Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/s5h1420.c b/drivers/media/dvb-frontends/s5h1420.c
index 93eeaf7118fd..0b4f8fe6bf99 100644
--- a/drivers/media/dvb-frontends/s5h1420.c
+++ b/drivers/media/dvb-frontends/s5h1420.c
@@ -180,7 +180,7 @@ static int s5h1420_send_master_cmd (struct dvb_frontend* fe,
 	int result = 0;
 
 	dprintk("enter %s\n", __func__);
-	if (cmd->msg_len > 8)
+	if (cmd->msg_len > sizeof(cmd->msg))
 		return -EINVAL;
 
 	/* setup for DISEQC */
-- 
2.1.0

