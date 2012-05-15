Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37186 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932922Ab2EOXs7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 19:48:59 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Christopher Pascoe <c.pascoe@itee.uq.edu.au>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] zl10353: change .read_snr() to report SNR as a 0.1 dB
Date: Wed, 16 May 2012 02:48:40 +0300
Message-Id: <1337125720-26332-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Report SNR in 0.1 dB scale instead of raw hardware register values.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/frontends/zl10353.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/zl10353.c b/drivers/media/dvb/frontends/zl10353.c
index ac72378..23fc853 100644
--- a/drivers/media/dvb/frontends/zl10353.c
+++ b/drivers/media/dvb/frontends/zl10353.c
@@ -525,7 +525,7 @@ static int zl10353_read_snr(struct dvb_frontend *fe, u16 *snr)
 		zl10353_dump_regs(fe);
 
 	_snr = zl10353_read_register(state, SNR);
-	*snr = (_snr << 8) | _snr;
+	*snr = 10 * _snr / 8;
 
 	return 0;
 }
-- 
1.7.7.6

