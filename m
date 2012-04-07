Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:48334 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752115Ab2DGOem (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2012 10:34:42 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Subject: [PATCH v2] af9033: implement ber and ucb functions
Date: Sat, 7 Apr 2012 16:34:34 +0200
Cc: linux-media@vger.kernel.org,
	Michael =?iso-8859-1?q?B=FCsch?= <m@bues.ch>,
	Gianluca Gennari <gennarone@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204071634.34179.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

af9033: implement read_ber and read_ucblocks functions. Version 2 of patch that
reflects my findings on the behaviour of abort_cnt, err_cnt and bit_cnt:

- bit_cnt is always 0x2710 (10000)
- abort_cnt is between 0 and 0x2710
- err_cnt is between 0 and 640000 (= 0x2710 * 8 * 8)

in the current implementation BER is calculated as the number of bit errors per
processed bits, ignoring those bits that are already discarded and counted in
abort_cnt, i.e. UCBLOCKS.

Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>

 drivers/media/dvb/frontends/af9033.c |   65 +++++++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 2 deletions(-)

diff -Nupr a/drivers/media/dvb/frontends/af9033.c b/drivers/media/dvb/frontends/af9033.c
--- a/drivers/media/dvb/frontends/af9033.c	2012-04-07 16:00:45.615402757 +0200
+++ b/drivers/media/dvb/frontends/af9033.c	2012-04-07 16:27:21.534741880 +0200
@@ -29,6 +29,10 @@ struct af9033_state {
 	u32 bandwidth_hz;
 	bool ts_mode_parallel;
 	bool ts_mode_serial;
+
+	u32 ber;
+	u32 ucb;
+	unsigned long last_stat_check;
 };
 
 /* write multiple registers */
@@ -772,16 +776,73 @@ err:
 	return ret;
 }
 
+static int af9033_update_ch_stat(struct af9033_state *state)
+{
+	int ret = 0;
+	u32 err_cnt, bit_cnt;
+	u16 abort_cnt;
+	u8 buf[7];
+
+	/* only update data every half second */
+	if (time_after(jiffies, state->last_stat_check + msecs_to_jiffies(500))) {
+		ret = af9033_rd_regs(state, 0x800032, buf, sizeof(buf));
+		if (ret < 0)
+			goto err;
+		/* in 8 byte packets? */
+		abort_cnt = (buf[1] << 8) + buf[0];
+		/* in bits */
+		err_cnt = (buf[4] << 16) + (buf[3] << 8) + buf[2];
+		/* in 8 byte packets? always(?) 0x2710 = 10000 */
+		bit_cnt = (buf[6] << 8) + buf[5];
+
+		if (bit_cnt < abort_cnt) {
+			abort_cnt = 1000;
+			state->ber = 0xffffffff;
+		} else {
+			/* 8 byte packets, that have not been rejected already */
+			bit_cnt -= (u32)abort_cnt;
+			if (bit_cnt == 0) {
+				state->ber = 0xffffffff;
+			} else {
+				err_cnt -= (u32)abort_cnt * 8 * 8;
+				bit_cnt *= 8 * 8;
+				state->ber = err_cnt * (0xffffffff / bit_cnt);
+			}
+		}
+		state->ucb += abort_cnt;
+		state->last_stat_check = jiffies;
+	}
+
+	return 0;
+err:
+	pr_debug("%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
 static int af9033_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
-	*ber = 0;
+	struct af9033_state *state = fe->demodulator_priv;
+	int ret;
+
+	ret = af9033_update_ch_stat(state);
+	if (ret < 0)
+		return ret;
+
+	*ber = state->ber;
 
 	return 0;
 }
 
 static int af9033_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
-	*ucblocks = 0;
+	struct af9033_state *state = fe->demodulator_priv;
+	int ret;
+
+	ret = af9033_update_ch_stat(state);
+	if (ret < 0)
+		return ret;
+
+	*ucblocks = state->ucb;
 
 	return 0;
 }

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
