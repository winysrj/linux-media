Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:34681 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932250AbcGKDXQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 23:23:16 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 54E071836A0
	for <linux-media@vger.kernel.org>; Mon, 11 Jul 2016 05:23:11 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: af9033: fix compiler warnings
Message-ID: <dab4ad2f-7f32-58f8-e509-e90466db5402@xs4all.nl>
Date: Mon, 11 Jul 2016 05:23:11 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix two warnings:

af9033.c: In function 'af9033_read_status':
af9033.c:883:25: warning: 'snr_lut' may be used uninitialized in this function [-Wmaybe-uninitialized]
   const struct val_snr *snr_lut;
                         ^
af9033.c:952:25: warning: 'tmp' may be used uninitialized in this function [-Wmaybe-uninitialized]
   c->cnr.stat[0].svalue = tmp;
                         ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 6c2f9b8..9a8157a 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -816,7 +816,7 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret, i, tmp;
+	int ret, i, tmp = 0;
 	u8 u8tmp, buf[7];

 	dev_dbg(&dev->client->dev, "\n");
@@ -880,7 +880,7 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	/* CNR */
 	if (dev->fe_status & FE_HAS_VITERBI) {
 		u32 snr_val, snr_lut_size;
-		const struct val_snr *snr_lut;
+		const struct val_snr *snr_lut = NULL;

 		/* read value */
 		ret = af9033_rd_regs(dev, 0x80002c, buf, 3);
