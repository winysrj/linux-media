Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57056 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633AbaLWUuf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:35 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 44/66] rtl2832: provide register IO callbacks
Date: Tue, 23 Dec 2014 22:49:37 +0200
Message-Id: <1419367799-14263-44-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide register read and write callbacks for SDR module.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 3 +++
 drivers/media/dvb-frontends/rtl2832.h | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 202186d..649d333 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -1284,6 +1284,9 @@ static int rtl2832_probe(struct i2c_client *client,
 	pdata->enable_slave_ts = rtl2832_enable_slave_ts;
 	pdata->pid_filter = rtl2832_pid_filter;
 	pdata->pid_filter_ctrl = rtl2832_pid_filter_ctrl;
+	pdata->bulk_read = rtl2832_bulk_read;
+	pdata->bulk_write = rtl2832_bulk_write;
+	pdata->update_bits = rtl2832_update_bits;
 
 	dev_info(&client->dev, "Realtek RTL2832 successfully attached\n");
 	return 0;
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index e79c479..f86af6f 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -80,6 +80,10 @@ struct rtl2832_platform_data {
 	int (*enable_slave_ts)(struct i2c_client *);
 	int (*pid_filter)(struct dvb_frontend *, u8, u16, int);
 	int (*pid_filter_ctrl)(struct dvb_frontend *, int);
+	/* Register access for SDR module */
+	int (*bulk_read)(struct i2c_client *, unsigned int, void *, size_t);
+	int (*bulk_write)(struct i2c_client *, unsigned int, const void *, size_t);
+	int (*update_bits)(struct i2c_client *, unsigned int, unsigned int, unsigned int);
 };
 
 #endif /* RTL2832_H */
-- 
http://palosaari.fi/

