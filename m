Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:44804 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751657AbdKDUUY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Nov 2017 16:20:24 -0400
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH v6 3/9] i2c: dev: mark RDWR buffers as DMA_SAFE
Date: Sat,  4 Nov 2017 21:20:03 +0100
Message-Id: <20171104202009.3818-4-wsa+renesas@sang-engineering.com>
In-Reply-To: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
References: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/i2c/i2c-dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index 6f638bbc922db4..bbc7aadb4c899d 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -280,6 +280,8 @@ static noinline int i2cdev_ioctl_rdwr(struct i2c_client *client,
 			res = PTR_ERR(rdwr_pa[i].buf);
 			break;
 		}
+		/* memdup_user allocates with GFP_KERNEL, so DMA is ok */
+		rdwr_pa[i].flags |= I2C_M_DMA_SAFE;
 
 		/*
 		 * If the message length is received from the slave (similar
-- 
2.11.0
