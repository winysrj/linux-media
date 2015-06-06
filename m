Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19974 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbbFFQzw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2015 12:55:52 -0400
Date: Sat, 6 Jun 2015 19:55:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Akihiro Tsukada <tskd08@gmail.com>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] [media] dvb-core: prevent some corruption the legacy ioctl
Message-ID: <20150606165521.GB28331@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quite a few of the ->diseqc_send_master_cmd() implementations don't
check cmd->msg_len so it can lead to memory corruption.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I don't think it ever makes sense for ->msg_len to be longer than ->msg
but I am a newbie to this code.

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index a894d4c..aa6b48f 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2403,7 +2403,13 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 
 	case FE_DISEQC_SEND_MASTER_CMD:
 		if (fe->ops.diseqc_send_master_cmd) {
-			err = fe->ops.diseqc_send_master_cmd(fe, (struct dvb_diseqc_master_cmd*) parg);
+			struct dvb_diseqc_master_cmd *cmd = parg;
+
+			if (cmd->msg_len > sizeof(cmd->msg)) {
+				err = -EINVAL;
+				break;
+			}
+			err = fe->ops.diseqc_send_master_cmd(fe, cmd);
 			fepriv->state = FESTATE_DISEQC;
 			fepriv->status = 0;
 		}
