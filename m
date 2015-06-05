Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49053 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbbFEO2G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 10:28:06 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 01/11] [media] drxk: better handle errors
Date: Fri,  5 Jun 2015 11:27:34 -0300
Message-Id: <2f60f13c14b45b311843d2ca09b5e3ef94c16f71.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/dvb-frontends/drxk_hard.c:3277 dvbt_sc_command() warn: missing break? reassigning 'status'

This is basically because the error handling logic there was crappy.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index ad35264a3819..b1fc4bd44a2b 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -3262,6 +3262,7 @@ static int dvbt_sc_command(struct drxk_state *state,
 	}
 
 	/* Write needed parameters and the command */
+	status = 0;
 	switch (cmd) {
 		/* All commands using 5 parameters */
 		/* All commands using 4 parameters */
@@ -3270,16 +3271,16 @@ static int dvbt_sc_command(struct drxk_state *state,
 	case OFDM_SC_RA_RAM_CMD_PROC_START:
 	case OFDM_SC_RA_RAM_CMD_SET_PREF_PARAM:
 	case OFDM_SC_RA_RAM_CMD_PROGRAM_PARAM:
-		status = write16(state, OFDM_SC_RA_RAM_PARAM1__A, param1);
+		status |= write16(state, OFDM_SC_RA_RAM_PARAM1__A, param1);
 		/* All commands using 1 parameters */
 	case OFDM_SC_RA_RAM_CMD_SET_ECHO_TIMING:
 	case OFDM_SC_RA_RAM_CMD_USER_IO:
-		status = write16(state, OFDM_SC_RA_RAM_PARAM0__A, param0);
+		status |= write16(state, OFDM_SC_RA_RAM_PARAM0__A, param0);
 		/* All commands using 0 parameters */
 	case OFDM_SC_RA_RAM_CMD_GET_OP_PARAM:
 	case OFDM_SC_RA_RAM_CMD_NULL:
 		/* Write command */
-		status = write16(state, OFDM_SC_RA_RAM_CMD__A, cmd);
+		status |= write16(state, OFDM_SC_RA_RAM_CMD__A, cmd);
 		break;
 	default:
 		/* Unknown command */
-- 
2.4.2

