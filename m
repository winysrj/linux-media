Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756535Ab2AKAWP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 19:22:15 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0B0MFo5030279
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 10 Jan 2012 19:22:15 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/6] [media] mb86a20s: implement get_frontend()
Date: Tue, 10 Jan 2012 22:20:23 -0200
Message-Id: <1326241226-6734-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1326241226-6734-1-git-send-email-mchehab@redhat.com>
References: <1326241226-6734-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reports the auto-detected parameters to userspace.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/mb86a20s.c |  196 +++++++++++++++++++++++++++++++-
 1 files changed, 193 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/frontends/mb86a20s.c b/drivers/media/dvb/frontends/mb86a20s.c
index 82d3301..38778a8 100644
--- a/drivers/media/dvb/frontends/mb86a20s.c
+++ b/drivers/media/dvb/frontends/mb86a20s.c
@@ -525,16 +525,206 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 	return rc;
 }
 
+static int mb86a20s_get_modulation(struct mb86a20s_state *state,
+				   unsigned layer)
+{
+	int rc;
+	static unsigned char reg[] = {
+		[0] = 0x86,	/* Layer A */
+		[1] = 0x8a,	/* Layer B */
+		[2] = 0x8e,	/* Layer C */
+	};
+
+	if (layer > ARRAY_SIZE(reg))
+		return -EINVAL;
+	rc = mb86a20s_writereg(state, 0x6d, reg[layer]);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x6e);
+	if (rc < 0)
+		return rc;
+	switch ((rc & 0x70) >> 4) {
+	case 0:
+		return DQPSK;
+	case 1:
+		return QPSK;
+	case 2:
+		return QAM_16;
+	case 3:
+		return QAM_64;
+	default:
+		return QAM_AUTO;
+	}
+}
+
+static int mb86a20s_get_fec(struct mb86a20s_state *state,
+			    unsigned layer)
+{
+	int rc;
+
+	static unsigned char reg[] = {
+		[0] = 0x87,	/* Layer A */
+		[1] = 0x8b,	/* Layer B */
+		[2] = 0x8f,	/* Layer C */
+	};
+
+	if (layer > ARRAY_SIZE(reg))
+		return -EINVAL;
+	rc = mb86a20s_writereg(state, 0x6d, reg[layer]);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x6e);
+	if (rc < 0)
+		return rc;
+	switch (rc) {
+	case 0:
+		return FEC_1_2;
+	case 1:
+		return FEC_2_3;
+	case 2:
+		return FEC_3_4;
+	case 3:
+		return FEC_5_6;
+	case 4:
+		return FEC_7_8;
+	default:
+		return FEC_AUTO;
+	}
+}
+
+static int mb86a20s_get_interleaving(struct mb86a20s_state *state,
+				     unsigned layer)
+{
+	int rc;
+
+	static unsigned char reg[] = {
+		[0] = 0x88,	/* Layer A */
+		[1] = 0x8c,	/* Layer B */
+		[2] = 0x90,	/* Layer C */
+	};
+
+	if (layer > ARRAY_SIZE(reg))
+		return -EINVAL;
+	rc = mb86a20s_writereg(state, 0x6d, reg[layer]);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x6e);
+	if (rc < 0)
+		return rc;
+	if (rc > 3)
+		return -EINVAL;	/* Not used */
+	return rc;
+}
+
+static int mb86a20s_get_segment_count(struct mb86a20s_state *state,
+				      unsigned layer)
+{
+	int rc, count;
+
+	static unsigned char reg[] = {
+		[0] = 0x89,	/* Layer A */
+		[1] = 0x8d,	/* Layer B */
+		[2] = 0x91,	/* Layer C */
+	};
+
+	if (layer > ARRAY_SIZE(reg))
+		return -EINVAL;
+	rc = mb86a20s_writereg(state, 0x6d, reg[layer]);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x6e);
+	if (rc < 0)
+		return rc;
+	count = (rc >> 4) & 0x0f;
+
+	return count;
+}
+
 static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 {
+	struct mb86a20s_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	int i, rc;
 
-	/* FIXME: For now, it does nothing */
-
+	/* Fixed parameters */
+	p->delivery_system = SYS_ISDBT;
 	p->bandwidth_hz = 6000000;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	/* Check for partial reception */
+	rc = mb86a20s_writereg(state, 0x6d, 0x85);
+	if (rc >= 0)
+		rc = mb86a20s_readreg(state, 0x6e);
+	if (rc >= 0)
+		p->isdbt_partial_reception = (rc & 0x10) ? 1 : 0;
+
+	/* Get per-layer data */
+	p->isdbt_layer_enabled = 0;
+	for (i = 0; i < 3; i++) {
+		rc = mb86a20s_get_segment_count(state, i);
+			if (rc >= 0 && rc < 14)
+				p->layer[i].segment_count = rc;
+		if (rc == 0x0f)
+			continue;
+		p->isdbt_layer_enabled |= 1 << i;
+		rc = mb86a20s_get_modulation(state, i);
+			if (rc >= 0)
+				p->layer[i].modulation = rc;
+		rc = mb86a20s_get_fec(state, i);
+			if (rc >= 0)
+				p->layer[i].fec = rc;
+		rc = mb86a20s_get_interleaving(state, i);
+			if (rc >= 0)
+				p->layer[i].interleaving = rc;
+	}
+
+	p->isdbt_sb_mode = 0;
+	rc = mb86a20s_writereg(state, 0x6d, 0x84);
+	if ((rc >= 0) && ((rc & 0x60) == 0x20)) {
+		p->isdbt_sb_mode = 1;
+		/* At least, one segment should exist */
+		if (!p->isdbt_sb_segment_count)
+			p->isdbt_sb_segment_count = 1;
+	} else
+		p->isdbt_sb_segment_count = 0;
+
+	/* Get transmission mode and guard interval */
 	p->transmission_mode = TRANSMISSION_MODE_AUTO;
 	p->guard_interval = GUARD_INTERVAL_AUTO;
-	p->isdbt_partial_reception = 0;
+	rc = mb86a20s_readreg(state, 0x07);
+	if (rc >= 0) {
+		if ((rc & 0x60) == 0x20) {
+			switch (rc & 0x0c >> 2) {
+			case 0:
+				p->transmission_mode = TRANSMISSION_MODE_2K;
+				break;
+			case 1:
+				p->transmission_mode = TRANSMISSION_MODE_4K;
+				break;
+			case 2:
+				p->transmission_mode = TRANSMISSION_MODE_8K;
+				break;
+			}
+		}
+		if (!(rc & 0x10)) {
+			switch (rc & 0x3) {
+			case 0:
+				p->guard_interval = GUARD_INTERVAL_1_4;
+				break;
+			case 1:
+				p->guard_interval = GUARD_INTERVAL_1_8;
+				break;
+			case 2:
+				p->guard_interval = GUARD_INTERVAL_1_16;
+				break;
+			}
+		}
+	}
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
 
 	return 0;
 }
-- 
1.7.7.5

