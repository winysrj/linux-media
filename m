Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:47244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792Ab1GKCAH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 22:00:07 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B206sv014376
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 22:00:07 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKk030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 22:00:06 -0400
Date: Sun, 10 Jul 2011 22:59:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 20/21] [media] drxk: Improve the scu_command error message
Message-ID: <20110710225906.055d58c1@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Now, it outputs:

[10927.639641] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[10927.646283] drxk: 02 00 00 00 10 00 07 00 03 02                    ..........

Better than ERROR -3. This happens with Terratec H5 firmware.

It adds 2 new error conditions, and something useful to track
what the heck is that.

I suspect that the scu_command is dependent on the firmware
revision.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index bb8627f..5745f52 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -1521,6 +1521,8 @@ static int scu_command(struct drxk_state *state,
 	unsigned long end;
 	u8 buffer[34];
 	int cnt = 0, ii;
+	const char *p;
+	char errname[30];
 
 	dprintk(1, "\n");
 
@@ -1567,31 +1569,36 @@ static int scu_command(struct drxk_state *state,
 
 		/* Check if an error was reported by SCU */
 		err = (s16)result[0];
+		if (err >= 0)
+			goto error;
 
-		/* check a few fixed error codes */
-		if (err == SCU_RESULT_UNKSTD) {
-			printk(KERN_ERR "drxk: SCU_RESULT_UNKSTD\n");
-			status = -EINVAL;
-			goto error2;
-		} else if (err == SCU_RESULT_UNKCMD) {
-			printk(KERN_ERR "drxk: SCU_RESULT_UNKCMD\n");
-			status = -EINVAL;
-			goto error2;
-		} else if (err < 0) {
-			/*
-			 * here it is assumed that a nagative result means
-			 *  error, and positive no error
-			 */
-			printk(KERN_ERR "drxk: %s ERROR: %d\n", __func__, err);
-			status = -EINVAL;
-			goto error2;
+		/* check for the known error codes */
+		switch (err) {
+		case SCU_RESULT_UNKCMD:
+			p = "SCU_RESULT_UNKCMD";
+			break;
+		case SCU_RESULT_UNKSTD:
+			p = "SCU_RESULT_UNKSTD";
+			break;
+		case SCU_RESULT_SIZE:
+			p = "SCU_RESULT_SIZE";
+			break;
+		case SCU_RESULT_INVPAR:
+			p = "SCU_RESULT_INVPAR";
+			break;
+		default: /* Other negative values are errors */
+			sprintf(errname, "ERROR: %d\n", err);
+			p = errname;
 		}
+		printk(KERN_ERR "drxk: %s while sending cmd 0x%04x with params:", p, cmd);
+		print_hex_dump_bytes("drxk: ", DUMP_PREFIX_NONE, buffer, cnt);
+		status = -EINVAL;
+		goto error2;
 	}
 
 error:
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
-
 error2:
 	mutex_unlock(&state->mutex);
 	return status;
diff --git a/drivers/media/dvb/frontends/drxk_hard.h b/drivers/media/dvb/frontends/drxk_hard.h
index a20a19d..a05c32e 100644
--- a/drivers/media/dvb/frontends/drxk_hard.h
+++ b/drivers/media/dvb/frontends/drxk_hard.h
@@ -20,6 +20,8 @@
 #define DRX_SCU_READY   0
 #define DRXK_MAX_WAITTIME (200)
 #define SCU_RESULT_OK      0
+#define SCU_RESULT_SIZE   -4
+#define SCU_RESULT_INVPAR -3
 #define SCU_RESULT_UNKSTD -2
 #define SCU_RESULT_UNKCMD -1
 
-- 
1.7.1


