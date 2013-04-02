Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47061 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759947Ab3DBHxQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 03:53:16 -0400
Date: Tue, 2 Apr 2013 10:51:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [RFC] [media] dvb-core: check ->msg_len for diseqc_send_master_cmd()
Message-ID: <20130402075102.GA11233@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'd like to send this patch except that it "breaks"
cx24116_send_diseqc_msg().  The cx24116 driver accepts ->msg_len values
up to 24 but it looks like it's just copying 16 bytes past the end of
the ->msg[] array so it's already broken.

cmd->msg_len is an unsigned char.  The comment next to the struct
declaration says that valid values are are 3-6.  Some of the drivers
check that this is true, but most don't and it could cause memory
corruption.

Some examples of functions which don't check are:
ttusbdecfe_dvbs_diseqc_send_master_cmd()
cx24123_send_diseqc_msg()
ds3000_send_diseqc_msg()
etc.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 57601c0..3d1eee6 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2265,7 +2265,13 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 
 	case FE_DISEQC_SEND_MASTER_CMD:
 		if (fe->ops.diseqc_send_master_cmd) {
-			err = fe->ops.diseqc_send_master_cmd(fe, (struct dvb_diseqc_master_cmd*) parg);
+			struct dvb_diseqc_master_cmd *cmd = parg;
+
+			if (cmd->msg_len >= 3 && cmd->msg_len <= 6)
+				err = fe->ops.diseqc_send_master_cmd(fe, cmd);
+			else
+				err = -EINVAL;
+
 			fepriv->state = FESTATE_DISEQC;
 			fepriv->status = 0;
 		}
