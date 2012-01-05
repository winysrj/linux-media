Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325Ab2AEBBM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:12 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511Cai016400
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:12 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 46/47] [media] drxk: Improve a few debug messages
Date: Wed,  4 Jan 2012 23:00:57 -0200
Message-Id: <1325725258-27934-47-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/drxk_hard.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 67a1e39..817d3ec 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -368,10 +368,10 @@ static int i2c_read(struct i2c_adapter *adap,
 	}
 	if (debug > 2) {
 		int i;
-		dprintk(2, ": read from ");
+		dprintk(2, ": read from");
 		for (i = 0; i < len; i++)
 			printk(KERN_CONT " %02x", msg[i]);
-		printk(KERN_CONT "Value = ");
+		printk(KERN_CONT ", value = ");
 		for (i = 0; i < alen; i++)
 			printk(KERN_CONT " %02x", answ[i]);
 		printk(KERN_CONT "\n");
@@ -947,6 +947,9 @@ static int GetDeviceCapabilities(struct drxk_state *state)
 	status = read32(state, SIO_TOP_JTAGID_LO__A, &sioTopJtagidLo);
 	if (status < 0)
 		goto error;
+
+printk(KERN_ERR "drxk: status = 0x%08x\n", sioTopJtagidLo);
+
 	/* driver 0.9.0 */
 	switch ((sioTopJtagidLo >> 29) & 0xF) {
 	case 0:
@@ -964,7 +967,8 @@ static int GetDeviceCapabilities(struct drxk_state *state)
 	default:
 		state->m_deviceSpin = DRXK_SPIN_UNKNOWN;
 		status = -EINVAL;
-		printk(KERN_ERR "drxk: Spin unknown\n");
+		printk(KERN_ERR "drxk: Spin %d unknown\n",
+		       (sioTopJtagidLo >> 29) & 0xF);
 		goto error2;
 	}
 	switch ((sioTopJtagidLo >> 12) & 0xFF) {
@@ -6452,6 +6456,8 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 		goto error;
 	*fe_t = &state->t_frontend;
 
+	printk(KERN_INFO "drxk: frontend initialized.\n");
+
 	return &state->c_frontend;
 
 error:
-- 
1.7.7.5

