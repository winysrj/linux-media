Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3055 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab3JDOCO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 10:02:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 05/14] cxd2820r_core: fix sparse warnings
Date: Fri,  4 Oct 2013 16:01:43 +0200
Message-Id: <1380895312-30863-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/dvb-frontends/cxd2820r_core.c:34:32: error: cannot size expression
drivers/media/dvb-frontends/cxd2820r_core.c:68:32: error: cannot size expression

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/cxd2820r_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index 7ca5c69..d9eeeb1 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -31,7 +31,7 @@ static int cxd2820r_wr_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 		{
 			.addr = i2c,
 			.flags = 0,
-			.len = sizeof(buf),
+			.len = len + 1,
 			.buf = buf,
 		}
 	};
@@ -65,7 +65,7 @@ static int cxd2820r_rd_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 		}, {
 			.addr = i2c,
 			.flags = I2C_M_RD,
-			.len = sizeof(buf),
+			.len = len,
 			.buf = buf,
 		}
 	};
-- 
1.8.3.2

