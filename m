Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385Ab3D1PsE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Apr 2013 11:48:04 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3SFm4FC028452
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 28 Apr 2013 11:48:04 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/9] [media] drxk_hard: use usleep_range()
Date: Sun, 28 Apr 2013 12:47:47 -0300
Message-Id: <1367164071-11468-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1367164071-11468-1-git-send-email-mchehab@redhat.com>
References: <1367164071-11468-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following checkpatch.pl warnings:

WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt
+			msleep(10);
WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt
+		msleep(1);
WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt
+			msleep(1);
WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt
+		msleep(1);
WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt
+		msleep(1);
WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt
+		msleep(1);
WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt
+		msleep(1);
WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt
+		msleep(1);

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/drxk_hard.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index fdbe23a..1fd74f2 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -505,7 +505,7 @@ static int power_up_device(struct drxk_state *state)
 			data = 0;
 			status = i2c_write(state, state->demod_address,
 					   &data, 1);
-			msleep(10);
+			usleep_range(10000, 11000);
 			retry_count++;
 			if (status < 0)
 				continue;
@@ -1017,7 +1017,7 @@ static int hi_command(struct drxk_state *state, u16 cmd, u16 *p_result)
 	if (status < 0)
 		goto error;
 	if (cmd == SIO_HI_RA_RAM_CMD_RESET)
-		msleep(1);
+		usleep_range(1000, 2000);
 
 	powerdown_cmd =
 	    (bool) ((cmd == SIO_HI_RA_RAM_CMD_CONFIG) &&
@@ -1030,7 +1030,7 @@ static int hi_command(struct drxk_state *state, u16 cmd, u16 *p_result)
 		u16 wait_cmd;
 
 		do {
-			msleep(1);
+			usleep_range(1000, 2000);
 			retry_count += 1;
 			status = read16(state, SIO_HI_RA_RAM_CMD__A,
 					  &wait_cmd);
@@ -1279,7 +1279,7 @@ static int bl_chain_cmd(struct drxk_state *state,
 
 	end = jiffies + msecs_to_jiffies(time_out);
 	do {
-		msleep(1);
+		usleep_range(1000, 2000);
 		status = read16(state, SIO_BL_STATUS__A, &bl_status);
 		if (status < 0)
 			goto error;
@@ -1392,7 +1392,7 @@ static int dvbt_enable_ofdm_token_ring(struct drxk_state *state, bool enable)
 		status = read16(state, SIO_OFDM_SH_OFDM_RING_STATUS__A, &data);
 		if ((status >= 0 && data == desired_status) || time_is_after_jiffies(end))
 			break;
-		msleep(1);
+		usleep_range(1000, 2000);
 	} while (1);
 	if (data != desired_status) {
 		pr_err("SIO not ready\n");
@@ -1471,7 +1471,7 @@ static int scu_command(struct drxk_state *state,
 	/* Wait until SCU has processed command */
 	end = jiffies + msecs_to_jiffies(DRXK_MAX_WAITTIME);
 	do {
-		msleep(1);
+		usleep_range(1000, 2000);
 		status = read16(state, SCU_RAM_COMMAND__A, &cur_cmd);
 		if (status < 0)
 			goto error;
@@ -3187,7 +3187,7 @@ static int dvbt_sc_command(struct drxk_state *state,
 	/* Wait until sc is ready to receive command */
 	retry_cnt = 0;
 	do {
-		msleep(1);
+		usleep_range(1000, 2000);
 		status = read16(state, OFDM_SC_RA_RAM_CMD__A, &cur_cmd);
 		retry_cnt++;
 	} while ((cur_cmd != 0) && (retry_cnt < DRXK_MAX_RETRIES));
@@ -3239,7 +3239,7 @@ static int dvbt_sc_command(struct drxk_state *state,
 	/* Wait until sc is ready processing command */
 	retry_cnt = 0;
 	do {
-		msleep(1);
+		usleep_range(1000, 2000);
 		status = read16(state, OFDM_SC_RA_RAM_CMD__A, &cur_cmd);
 		retry_cnt++;
 	} while ((cur_cmd != 0) && (retry_cnt < DRXK_MAX_RETRIES));
@@ -5947,7 +5947,7 @@ static int init_drxk(struct drxk_state *state)
 		if (status < 0)
 			goto error;
 		/* TODO is this needed, if yes how much delay in worst case scenario */
-		msleep(1);
+		usleep_range(1000, 2000);
 		state->m_drxk_a3_patch_code = true;
 		status = get_device_capabilities(state);
 		if (status < 0)
-- 
1.8.1.4

