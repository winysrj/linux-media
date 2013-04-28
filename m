Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab3D1Pr5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Apr 2013 11:47:57 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3SFlv4q013720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 28 Apr 2013 11:47:57 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/9] [media] drxk_hard: don't split strings across lines
Date: Sun, 28 Apr 2013 12:47:46 -0300
Message-Id: <1367164071-11468-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1367164071-11468-1-git-send-email-mchehab@redhat.com>
References: <1367164071-11468-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	WARNING: quoted string split across lines
	#5416: FILE: media/dvb-frontends/drxk_hard.c:5416:
	+		dprintk(1, "Could not set demodulator parameters. Make "
	+			"sure qam_demod_parameter_count (%d) is correct for "

	WARNING: quoted string split across lines
	#5423: FILE: media/dvb-frontends/drxk_hard.c:5423:
	+		dprintk(1, "Auto-probing the correct QAM demodulator command "
	+			"parameters was successful - using %d parameters.\n",

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/drxk_hard.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 552bce5..fdbe23a 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -168,7 +168,7 @@ MODULE_PARM_DESC(debug, "enable debug messages");
 
 #define dprintk(level, fmt, arg...) do {			\
 if (debug >= level)						\
-	printk(KERN_DEBUG "drxk: %s" fmt, __func__, ## arg);	\
+	pr_debug(fmt, ##arg);					\
 } while (0)
 
 
@@ -258,8 +258,8 @@ static int i2c_write(struct drxk_state *state, u8 adr, u8 *data, int len)
 	if (debug > 2) {
 		int i;
 		for (i = 0; i < len; i++)
-			printk(KERN_CONT " %02x", data[i]);
-		printk(KERN_CONT "\n");
+			pr_cont(" %02x", data[i]);
+		pr_cont("\n");
 	}
 	status = drxk_i2c_transfer(state, &msg, 1);
 	if (status >= 0 && status != 1)
@@ -285,7 +285,7 @@ static int i2c_read(struct drxk_state *state,
 	status = drxk_i2c_transfer(state, msgs, 2);
 	if (status != 2) {
 		if (debug > 2)
-			printk(KERN_CONT ": ERROR!\n");
+			pr_cont(": ERROR!\n");
 		if (status >= 0)
 			status = -EIO;
 
@@ -296,11 +296,11 @@ static int i2c_read(struct drxk_state *state,
 		int i;
 		dprintk(2, ": read from");
 		for (i = 0; i < len; i++)
-			printk(KERN_CONT " %02x", msg[i]);
-		printk(KERN_CONT ", value = ");
+			pr_cont(" %02x", msg[i]);
+		pr_cont(", value = ");
 		for (i = 0; i < alen; i++)
-			printk(KERN_CONT " %02x", answ[i]);
-		printk(KERN_CONT "\n");
+			pr_cont(" %02x", answ[i]);
+		pr_cont("\n");
 	}
 	return 0;
 }
@@ -470,8 +470,8 @@ static int write_block(struct drxk_state *state, u32 address,
 			int i;
 			if (p_block)
 				for (i = 0; i < chunk; i++)
-					printk(KERN_CONT " %02x", p_block[i]);
-			printk(KERN_CONT "\n");
+					pr_cont(" %02x", p_block[i]);
+			pr_cont("\n");
 		}
 		status = i2c_write(state, state->demod_address,
 				   &state->chunk[0], chunk + adr_length);
@@ -5412,15 +5412,15 @@ static int set_qam(struct drxk_state *state, u16 intermediate_freqk_hz,
 	}
 
 	if (status < 0) {
-		dprintk(1, "Could not set demodulator parameters. Make "
-			"sure qam_demod_parameter_count (%d) is correct for "
-			"your firmware (%s).\n",
+		dprintk(1, "Could not set demodulator parameters.\n");
+		dprintk(1,
+			"Make sure qam_demod_parameter_count (%d) is correct for your firmware (%s).\n",
 			state->qam_demod_parameter_count,
 			state->microcode_name);
 		goto error;
 	} else if (!state->qam_demod_parameter_count) {
-		dprintk(1, "Auto-probing the correct QAM demodulator command "
-			"parameters was successful - using %d parameters.\n",
+		dprintk(1,
+			"Auto-probing the QAM command parameters was successful - using %d parameters.\n",
 			qam_demod_param_count);
 
 		/*
-- 
1.8.1.4

