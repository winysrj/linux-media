Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49589 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbaBIIt6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:49:58 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 31/86] rtl2832_sdr: switch FM to DAB mode
Date: Sun,  9 Feb 2014 10:48:36 +0200
Message-Id: <1391935771-18670-32-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It seems to perform a little bit better on weak signals when mode
is DAB. It looks like weak signals are faded out by squelch(?) in
FM mode as voice was silenced under one sec when tuned to weak FM
station.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index d101409..fccb16f 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -748,12 +748,12 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 	if (ret)
 		goto err;
 
-	/* mode */
 	ret = rtl2832_sdr_wr_regs(s, 0x017, "\x11\x10", 2);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_sdr_wr_regs(s, 0x019, "\x21", 1);
+	/* mode */
+	ret = rtl2832_sdr_wr_regs(s, 0x019, "\x05", 1);
 	if (ret)
 		goto err;
 
-- 
1.8.5.3

