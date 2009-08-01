Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:46648 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbZHALFY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Aug 2009 07:05:24 -0400
Date: Sat, 1 Aug 2009 13:02:38 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/3 update] firedtv: add PID filtering for SW zigzag retune
To: Henrik Kurelid <henke@kurelid.se>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
cc: linux-media@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.54463abf6a774c27@s5r6.in-berlin.de>
Message-ID: <tkrat.2933b45909e8fb83@s5r6.in-berlin.de>
References: <2f15391f4f76f6a3126c0e8a9d61562c.squirrel@mail.kurelid.se>
 <tkrat.54463abf6a774c27@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Henrik Kurelid <henke@kurelid.se>

The AVC protocol uses the same command for tuning and PID filtering and
since dvb-core uses a software zigzagging to do automatic retuning this
could cause all PID filters to be cleared.  PID filter information is
now included in all DSD commands to the card.

Background:

There is a problem in the firedtv driver that causes recordings to stop
if the SW zigzag algorithm in dvb-core kicks in with a retune after the
application has set up the PID filters.  Since tuning and setting PID
filters uses the same AVC command (DSD) and only the replace subfunction
is supported by the card, it is not possible to do a retune without
setting the PID filters.  This means that the PID filtering has to be
sent in each tune.

This problem applies to C and T cards since S and S2 cards tune using a
vendor specific command.  The patch corrects the problem by sending the
PID list in each tune.  I have tested it on my T card with a good
result.

How to trigger problem:  Zap to a channel and output AV to a file, e.g.
"tzap -c channels.conf SVT1 -r -o SVT1.ts".  After a short while, pull
the antenna cable from the card.  The lock on the channel will disappear
and the TS file will stop increasing in size. Wait a couple of seconds.
Replug the cable again.  You will get a lock on the channel again, but
the TS file will never increase in size agains sinze no PIDS are
filtered.

Signed-off-by: Henrik Kurelid <henrik@kurelid.se>

Tested with kaffeine with DVB-T and DVB-C:  Fixes retuning after antenna
was plugged out and back in with DVB-T.  Does not fix this with DVB-C,
but also doesn't regress on DVB-C.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Update (Stefan R):
Make a function static, small whitespace changes, extended changelog.

 drivers/media/dvb/firewire/firedtv-avc.c |   40 +++++++++++++++++------
 1 file changed, 30 insertions(+), 10 deletions(-)

Index: b/drivers/media/dvb/firewire/firedtv-avc.c
===================================================================
--- a/drivers/media/dvb/firewire/firedtv-avc.c
+++ b/drivers/media/dvb/firewire/firedtv-avc.c
@@ -254,6 +254,26 @@ int avc_recv(struct firedtv *fdtv, void 
 	return 0;
 }
 
+static int add_pid_filter(struct firedtv *fdtv, u8 *operand)
+{
+	int i, n, pos = 1;
+
+	for (i = 0, n = 0; i < 16; i++) {
+		if (test_bit(i, &fdtv->channel_active)) {
+			operand[pos++] = 0x13; /* flowfunction relay */
+			operand[pos++] = 0x80; /* dsd_sel_spec_valid_flags -> PID */
+			operand[pos++] = (fdtv->channel_pid[i] >> 8) & 0x1f;
+			operand[pos++] = fdtv->channel_pid[i] & 0xff;
+			operand[pos++] = 0x00; /* tableID */
+			operand[pos++] = 0x00; /* filter_length */
+			n++;
+		}
+	}
+	operand[0] = n;
+
+	return pos;
+}
+
 /*
  * tuning command for setting the relative LNB frequency
  * (not supported by the AVC standard)
@@ -316,7 +336,8 @@ static void avc_tuner_tuneqpsk(struct fi
 	}
 }
 
-static void avc_tuner_dsd_dvb_c(struct dvb_frontend_parameters *params,
+static void avc_tuner_dsd_dvb_c(struct firedtv *fdtv,
+				struct dvb_frontend_parameters *params,
 				struct avc_command_frame *c)
 {
 	c->opcode = AVC_OPCODE_DSD;
@@ -378,13 +399,13 @@ static void avc_tuner_dsd_dvb_c(struct d
 
 	c->operand[20] = 0x00;
 	c->operand[21] = 0x00;
-	/* Nr_of_dsd_sel_specs = 0 -> no PIDs are transmitted */
-	c->operand[22] = 0x00;
 
-	c->length = 28;
+	/* Add PIDs to filter */
+	c->length = ALIGN(22 + add_pid_filter(fdtv, &c->operand[22]) + 3, 4);
 }
 
-static void avc_tuner_dsd_dvb_t(struct dvb_frontend_parameters *params,
+static void avc_tuner_dsd_dvb_t(struct firedtv *fdtv,
+				struct dvb_frontend_parameters *params,
 				struct avc_command_frame *c)
 {
 	struct dvb_ofdm_parameters *ofdm = &params->u.ofdm;
@@ -481,10 +502,9 @@ static void avc_tuner_dsd_dvb_t(struct d
 
 	c->operand[15] = 0x00; /* network_ID[0] */
 	c->operand[16] = 0x00; /* network_ID[1] */
-	/* Nr_of_dsd_sel_specs = 0 -> no PIDs are transmitted */
-	c->operand[17] = 0x00;
 
-	c->length = 24;
+	/* Add PIDs to filter */
+	c->length = ALIGN(17 + add_pid_filter(fdtv, &c->operand[17]) + 3, 4);
 }
 
 int avc_tuner_dsd(struct firedtv *fdtv,
@@ -502,8 +522,8 @@ int avc_tuner_dsd(struct firedtv *fdtv,
 	switch (fdtv->type) {
 	case FIREDTV_DVB_S:
 	case FIREDTV_DVB_S2: avc_tuner_tuneqpsk(fdtv, params, c); break;
-	case FIREDTV_DVB_C: avc_tuner_dsd_dvb_c(params, c); break;
-	case FIREDTV_DVB_T: avc_tuner_dsd_dvb_t(params, c); break;
+	case FIREDTV_DVB_C: avc_tuner_dsd_dvb_c(fdtv, params, c); break;
+	case FIREDTV_DVB_T: avc_tuner_dsd_dvb_t(fdtv, params, c); break;
 	default:
 		BUG();
 	}

-- 
Stefan Richter
-=====-==--= =--- ----=
http://arcgraph.de/sr/

