Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:53052 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752933Ab2DAVTT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 17:19:19 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] AF9033 read_ber and read_ucblocks implementation
Date: Sun, 1 Apr 2012 23:19:12 +0200
Cc: linux-media@vger.kernel.org
References: <4F75A7FE.8090405@iki.fi> <201204012011.29830.hfvogt@gmx.net> <201204012307.31742.hfvogt@gmx.net>
In-Reply-To: <201204012307.31742.hfvogt@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204012319.12575.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implementation of af9033_read_ber and af9033_read_ucblocks functions.

Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>

 drivers/media/dvb/dvb-usb/af9033.c |   68 +++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 2 deletions(-)

diff -Nupr a/drivers/media/dvb/dvb-usb/af9033.c b/drivers/media/dvb/dvb-usb/af9033.c
--- a/drivers/media/dvb/dvb-usb/af9033.c	2012-04-01 22:41:45.378193253 +0200
+++ b/drivers/media/dvb/dvb-usb/af9033.c	2012-04-01 23:12:19.212643650 +0200
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
@@ -594,16 +598,76 @@ err:
 	return ret;
 }
 
+static int af9033_update_ch_stat(struct af9033_state *state)
+{
+	int ret = 0;
+	u32 post_err_cnt, post_bit_cnt;
+	u16 abort_cnt;
+	u8 buf[7];
+	static u8 sw = 0;
+
+	/* only update data every half second */
+	if (time_after(jiffies, state->last_stat_check + 500 * HZ / 1000)) {
+		ret = af9033_rd_regs(state, 0x800032, buf, sizeof(buf));
+		if (ret < 0)
+			goto err;
+		abort_cnt = (buf[1] << 8) + buf[0];
+		post_err_cnt = (buf[4] << 16) + (buf[3] << 8) + buf[2];
+		post_bit_cnt = (buf[6] << 8) + buf[5];
+		if (post_bit_cnt == 0) {
+			abort_cnt = 1000;
+			post_err_cnt = 1;
+			post_bit_cnt = 2;
+		} else {
+			post_bit_cnt -= (u32)abort_cnt;
+			if (post_bit_cnt == 0) {
+				post_err_cnt = 1;
+				post_bit_cnt = 2;
+			} else {
+				post_err_cnt -= (u32)abort_cnt * 8 * 8;
+				post_bit_cnt *= 204 * 8;
+			}
+		}
+		state->ber = post_err_cnt * (0xffffffff / post_bit_cnt);
+		/* reset ucblocks value every second call */
+		if (sw)
+			state->ucb = abort_cnt;
+		else
+			state->ucb = +abort_cnt;
+		sw = ~sw;
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
