Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35514 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab2HUX46 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 19:56:58 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Thomas Mair <thomas.mair86@googlemail.com>
Subject: [PATCH 2/5] rtl28xxu: fix rtl2832u module reload fails bug
Date: Wed, 22 Aug 2012 02:56:19 +0300
Message-Id: <1345593382-11367-2-git-send-email-crope@iki.fi>
In-Reply-To: <1345593382-11367-1-git-send-email-crope@iki.fi>
References: <1345593382-11367-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is workaround / partial fix.

rtl2832u_power_ctrl() and rtl2832u_frontend_attach() needs to
be go through carefully and fix properly. There is clearly
some logical errors when handling power-management ang GPIOs...

Signed-off-by: Antti Palosaari <crope@iki.fi>
Cc: Thomas Mair <thomas.mair86@googlemail.com>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 1ccb99b..c246c50 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -946,17 +946,6 @@ static int rtl2832u_power_ctrl(struct dvb_usb_device *d, int onoff)
 		if (ret)
 			goto err;
 
-		/* demod HW reset */
-		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL, &val);
-		if (ret)
-			goto err;
-		/* bit 5 to 0 */
-		val &= 0xdf;
-
-		ret = rtl28xx_wr_reg(d, SYS_DEMOD_CTL, val);
-		if (ret)
-			goto err;
-
 		ret = rtl28xx_rd_reg(d, SYS_DEMOD_CTL, &val);
 		if (ret)
 			goto err;
-- 
1.7.11.4

