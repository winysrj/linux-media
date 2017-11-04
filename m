Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:44789 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751477AbdKDUUY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Nov 2017 16:20:24 -0400
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH v6 1/9] i2c: add a message flag for DMA safe buffers
Date: Sat,  4 Nov 2017 21:20:01 +0100
Message-Id: <20171104202009.3818-2-wsa+renesas@sang-engineering.com>
In-Reply-To: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
References: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I2C has no requirement that the buffer of a message needs to be DMA
safe. In case it is, it can now be flagged, so drivers wishing to
do DMA can use the buffer directly.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 include/uapi/linux/i2c.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/i2c.h b/include/uapi/linux/i2c.h
index 009e27bb9abe19..1c683cb319e4b7 100644
--- a/include/uapi/linux/i2c.h
+++ b/include/uapi/linux/i2c.h
@@ -71,6 +71,9 @@ struct i2c_msg {
 #define I2C_M_RD		0x0001	/* read data, from slave to master */
 					/* I2C_M_RD is guaranteed to be 0x0001! */
 #define I2C_M_TEN		0x0010	/* this is a ten bit chip address */
+#define I2C_M_DMA_SAFE		0x0200	/* the buffer of this message is DMA safe */
+					/* makes only sense in kernelspace */
+					/* userspace buffers are copied anyway */
 #define I2C_M_RECV_LEN		0x0400	/* length will be first received byte */
 #define I2C_M_NO_RD_ACK		0x0800	/* if I2C_FUNC_PROTOCOL_MANGLING */
 #define I2C_M_IGNORE_NAK	0x1000	/* if I2C_FUNC_PROTOCOL_MANGLING */
-- 
2.11.0
