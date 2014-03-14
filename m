Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47454 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904AbaCNTZq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 15:25:46 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] rtl2832_sdr: do not use dynamic stack allocation
Date: Fri, 14 Mar 2014 21:25:28 +0200
Message-Id: <1394825128-8584-2-git-send-email-crope@iki.fi>
In-Reply-To: <1394825128-8584-1-git-send-email-crope@iki.fi>
References: <1394825128-8584-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not use dynamic stack allocation.

>> drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c:181:1:
warning: 'rtl2832_sdr_wr' uses dynamic stack allocation [enabled by default]

Reported-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index b09f7d8..104ee8a 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -156,7 +156,9 @@ static int rtl2832_sdr_wr(struct rtl2832_sdr_state *s, u8 reg, const u8 *val,
 		int len)
 {
 	int ret;
-	u8 buf[1 + len];
+#define MAX_WR_LEN 24
+#define MAX_WR_XFER_LEN (MAX_WR_LEN + 1)
+	u8 buf[MAX_WR_XFER_LEN];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = s->cfg->i2c_addr,
@@ -166,6 +168,9 @@ static int rtl2832_sdr_wr(struct rtl2832_sdr_state *s, u8 reg, const u8 *val,
 		}
 	};
 
+	if (WARN_ON(len > MAX_WR_LEN))
+		return -EINVAL;
+
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
-- 
1.8.5.3

