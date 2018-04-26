Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bl2nam02on0134.outbound.protection.outlook.com ([104.47.38.134]:10082
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751508AbeDZGe6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 02:34:58 -0400
From: <Yasunari.Takiguchi@sony.com>
To: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tbird20d@gmail.com>, <frowand.list@gmail.com>,
        <Yasunari.Takiguchi@sony.com>, <Masayuki.Yamamoto@sony.com>,
        <Hideki.Nozawa@sony.com>, <Kota.Yonezawa@sony.com>,
        <Toshihiko.Matsumoto@sony.com>, <Satoshi.C.Watanabe@sony.com>
Subject: [PATCH 1/3] [media] cxd2880-spi: Modified how to declare structure
Date: Thu, 26 Apr 2018 15:39:17 +0900
Message-ID: <20180426063917.32068-1-Yasunari.Takiguchi@sony.com>
In-Reply-To: <20180426063635.31923-1-Yasunari.Takiguchi@sony.com>
References: <20180426063635.31923-1-Yasunari.Takiguchi@sony.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>

This is the modification of structure declaration for spi_transfer. 

Signed-off-by: Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Signed-off-by: Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>
Signed-off-by: Hideki Nozawa <Hideki.Nozawa@sony.com>
Signed-off-by: Kota Yonezawa <Kota.Yonezawa@sony.com>
Signed-off-by: Toshihiko Matsumoto <Toshihiko.Matsumoto@sony.com>
Signed-off-by: Satoshi Watanabe <Satoshi.C.Watanabe@sony.com>
---
[Change list]
   drivers/media/spi/cxd2880-spi.c
      -modified how to declare spi_transfer structure

 drivers/media/spi/cxd2880-spi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/spi/cxd2880-spi.c b/drivers/media/spi/cxd2880-spi.c
index 4df3bd312f48..754940f7e964 100644
--- a/drivers/media/spi/cxd2880-spi.c
+++ b/drivers/media/spi/cxd2880-spi.c
@@ -60,14 +60,13 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 static int cxd2880_write_spi(struct spi_device *spi, u8 *data, u32 size)
 {
 	struct spi_message msg;
-	struct spi_transfer tx;
+	struct spi_transfer tx = {};
 
 	if (!spi || !data) {
 		pr_err("invalid arg\n");
 		return -EINVAL;
 	}
 
-	memset(&tx, 0, sizeof(tx));
 	tx.tx_buf = data;
 	tx.len = size;
 
@@ -130,7 +129,7 @@ static int cxd2880_spi_read_ts(struct spi_device *spi,
 	int ret;
 	u8 data[3];
 	struct spi_message message;
-	struct spi_transfer transfer[2];
+	struct spi_transfer transfer[2] = {};
 
 	if (!spi || !read_data || !packet_num) {
 		pr_err("invalid arg\n");
@@ -146,7 +145,6 @@ static int cxd2880_spi_read_ts(struct spi_device *spi,
 	data[2] = packet_num;
 
 	spi_message_init(&message);
-	memset(transfer, 0, sizeof(transfer));
 
 	transfer[0].len = 3;
 	transfer[0].tx_buf = data;
@@ -383,7 +381,7 @@ static int cxd2880_start_feed(struct dvb_demux_feed *feed)
 			}
 		}
 		if (i == CXD2880_MAX_FILTER_SIZE) {
-			pr_err("PID filter is full. Assumed bug.\n");
+			pr_err("PID filter is full.\n");
 			return -EINVAL;
 		}
 		if (!dvb_spi->all_pid_feed_count)
-- 
2.15.1
