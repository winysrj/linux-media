Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757183Ab3AOCbf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 21:31:35 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0F2VYWU014226
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Jan 2013 21:31:35 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv10 06/15] mb86a20s: Fix i2c gate on error
Date: Tue, 15 Jan 2013 00:30:52 -0200
Message-Id: <1358217061-14982-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If an error happens, restore tuner I2C gate to the right
value.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index c91e9b9..06e5d35 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -814,10 +814,10 @@ static int mb86a20s_initfe(struct dvb_frontend *fe)
 			goto err;
 	}
 
+err:
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
-err:
 	if (rc < 0) {
 		state->need_init = true;
 		printk(KERN_INFO "mb86a20s: Init failed. Will try again later\n");
@@ -841,6 +841,10 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 
 	dprintk("\n");
 
+	/*
+	 * Gate should already be opened, but it doesn't hurt to
+	 * double-check
+	 */
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	dprintk("Calling tuner set parameters\n");
-- 
1.7.11.7

