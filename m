Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53250 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059AbaGOBJp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 21:09:45 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 17/18] rtl2832_sdr: print notice to point SDR API is not 100% stable yet
Date: Tue, 15 Jul 2014 04:09:20 +0300
Message-Id: <1405386561-30450-17-git-send-email-crope@iki.fi>
In-Reply-To: <1405386561-30450-1-git-send-email-crope@iki.fi>
References: <1405386561-30450-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SDR API is very new and surprises may occur. Due to that print
notice to remind possible users.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 06a66eb..ae52974 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -1488,6 +1488,9 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 
 	dev_info(&s->i2c->dev, "%s: Realtek RTL2832 SDR attached\n",
 			KBUILD_MODNAME);
+	dev_notice(&s->udev->dev,
+			"%s: SDR API is still slightly experimental and functionality changes may follow\n",
+			KBUILD_MODNAME);
 	return fe;
 
 err_unregister_v4l2_dev:
-- 
1.9.3

