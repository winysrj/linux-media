Return-path: <linux-media-owner@vger.kernel.org>
Received: from proxy2.bredband.net ([195.54.101.72]:45188 "EHLO
	proxy2.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZGONNZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jul 2009 09:13:25 -0400
Received: from iph2.telenor.se (195.54.127.133) by proxy2.bredband.net (7.3.140.3)
        id 49F59CBD01924ED8 for linux-media@vger.kernel.org; Wed, 15 Jul 2009 14:52:49 +0200
Received: from evermeet.kurelid.se (localhost.localdomain [127.0.0.1])
	by evermeet.kurelid.se (8.14.3/8.13.8) with ESMTP id n6FCqmNO004275
	for <linux-media@vger.kernel.org>; Wed, 15 Jul 2009 14:52:48 +0200
Message-ID: <fbb51e1441fc7d58fa0e4a50df19122b.squirrel@mail.kurelid.se>
Date: Wed, 15 Jul 2009 14:52:48 +0200
Subject: [PATCH] firedtv: add PID filtering for SW zigzag retune
From: "Henrik Kurelid" <henke@kurelid.se>
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

There is a problem in the firedtv driver that causes recordings to stop if the SW zigzag algorithm in dvb-core kicks in with a retune after the
application has set up the PID filters. Since tuning and setting PID filters uses the same AVC command (DSD) and only the replace subfunction is
supported by the card, it is not possible to do a retune without setting the PID filters. This means that the PID filtering has to be sent in each
tune.

This problem applies to C and T cards since S and S2 cards tune using a vendor specific command. The patch below corrects the problem by sending the
PID list in each tune. I have tested it on my T card with a good result. Since I can not test this on a C card I would appreciate if someone could
try it out there as well.

How to trigger problem:
Zap to a channel and output AV to a file, e.g. "tzap -c channels.conf SVT1 -r -o SVT1.ts". After a short while, pull the antenna cable from the
card. The lock on the channel will disappear and the TS file will stop increasing in size. Wait a couple of seconds. Replug the cable again. You
will get a lock on the channel again, but the TS file will never increase in size agains sinze no PIDS are filtered.

Patch:

>From dacd5b98be802176c10026617323f68b76ba19d0 Mon Sep 17 00:00:00 2001
From: Henrik Kurelid <henrik@kurelid.se>
Date: Tue, 14 Jul 2009 22:34:24 +0200
Subject: [PATCH] firedtv: add PID filtering for SW zigzag retune

The AVC protocol uses the same command for tuning and PID filtering
and since dvb-core uses a software zigzagging to do automatic
retuning this could cause all PID filters to be cleared. PID
filter information is now included in all DSD commands to the card.

Signed-off-by: Henrik Kurelid <henrik@kurelid.se>
---
 drivers/media/dvb/firewire/firedtv-avc.c |   43 +++++++++++++++++++++--------
 1 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb/firewire/firedtv-avc.c b/drivers/media/dvb/firewire/firedtv-avc.c
index 32526f1..dccea83 100644
--- a/drivers/media/dvb/firewire/firedtv-avc.c
+++ b/drivers/media/dvb/firewire/firedtv-avc.c
@@ -254,6 +254,27 @@ int avc_recv(struct firedtv *fdtv, void *data, size_t length)
        return 0;
 }

+int add_pid_filter(struct firedtv *fdtv,
+                  u8* operand)
+{
+       int i, n, pos = 1;
+
+       for (i = 0, n = 0; i < 16; i++) {
+               if (test_bit(i, &fdtv->channel_active)) {
+                       operand[pos++] = 0x13; /* flowfunction relay */
+                       operand[pos++] = 0x80; /* dsd_sel_spec_valid_flags -> PID */
+                       operand[pos++] = (fdtv->channel_pid[i] >> 8) & 0x1f;
+                       operand[pos++] = fdtv->channel_pid[i] & 0xff;
+                       operand[pos++] = 0x00; /* tableID */
+                       operand[pos++] = 0x00; /* filter_length */
+                       n++;
+               }
+       }
+       operand[0] = n;
+
+       return pos;
+}
+
 /*
  * tuning command for setting the relative LNB frequency
  * (not supported by the AVC standard)
@@ -316,7 +337,8 @@ static void avc_tuner_tuneqpsk(struct firedtv *fdtv,
        }
 }

-static void avc_tuner_dsd_dvb_c(struct dvb_frontend_parameters *params,
+static void avc_tuner_dsd_dvb_c(struct firedtv *fdtv,
+                               struct dvb_frontend_parameters *params,
                                struct avc_command_frame *c)
 {
        c->opcode = AVC_OPCODE_DSD;
@@ -378,13 +400,12 @@ static void avc_tuner_dsd_dvb_c(struct dvb_frontend_parameters *params,

        c->operand[20] = 0x00;
        c->operand[21] = 0x00;
-       /* Nr_of_dsd_sel_specs = 0 -> no PIDs are transmitted */
-       c->operand[22] = 0x00;
-
-       c->length = 28;
+       /* Add PIDs to filter */
+       c->length = ALIGN(22 + add_pid_filter(fdtv, &c->operand[22]) + 3, 4);
 }

-static void avc_tuner_dsd_dvb_t(struct dvb_frontend_parameters *params,
+static void avc_tuner_dsd_dvb_t(struct firedtv *fdtv,
+                               struct dvb_frontend_parameters *params,
                                struct avc_command_frame *c)
 {
        struct dvb_ofdm_parameters *ofdm = &params->u.ofdm;
@@ -481,10 +502,8 @@ static void avc_tuner_dsd_dvb_t(struct dvb_frontend_parameters *params,

        c->operand[15] = 0x00; /* network_ID[0] */
        c->operand[16] = 0x00; /* network_ID[1] */
-       /* Nr_of_dsd_sel_specs = 0 -> no PIDs are transmitted */
-       c->operand[17] = 0x00;
-
-       c->length = 24;
+       /* Add PIDs to filter */
+       c->length = ALIGN(17 + add_pid_filter(fdtv, &c->operand[17]) + 3, 4);
 }

 int avc_tuner_dsd(struct firedtv *fdtv,
@@ -502,8 +521,8 @@ int avc_tuner_dsd(struct firedtv *fdtv,
        switch (fdtv->type) {
        case FIREDTV_DVB_S:
        case FIREDTV_DVB_S2: avc_tuner_tuneqpsk(fdtv, params, c); break;
-       case FIREDTV_DVB_C: avc_tuner_dsd_dvb_c(params, c); break;
-       case FIREDTV_DVB_T: avc_tuner_dsd_dvb_t(params, c); break;
+       case FIREDTV_DVB_C: avc_tuner_dsd_dvb_c(fdtv, params, c); break;
+       case FIREDTV_DVB_T: avc_tuner_dsd_dvb_t(fdtv, params, c); break;
        default:
                BUG();
        }
-- 
1.6.0.6



Regards,
Henrik
