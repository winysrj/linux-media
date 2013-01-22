Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab3AVLQJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 06:16:09 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0MBG98d000526
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 06:16:09 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/7] [media] mb86a20s: Fix i2c gate on error
Date: Tue, 22 Jan 2013 09:15:28 -0200
Message-Id: <1358853333-21554-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358853333-21554-1-git-send-email-mchehab@redhat.com>
References: <1358853333-21554-1-git-send-email-mchehab@redhat.com>
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
index 4ff3a0c..3c8587e 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -262,10 +262,10 @@ static int mb86a20s_initfe(struct dvb_frontend *fe)
 			goto err;
 	}
 
+err:
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
-err:
 	if (rc < 0) {
 		state->need_init = true;
 		printk(KERN_INFO "mb86a20s: Init failed. Will try again later\n");
@@ -363,6 +363,10 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 
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

