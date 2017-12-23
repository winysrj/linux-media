Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:2757 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756729AbdLWBwd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Dec 2017 20:52:33 -0500
From: Wei Yongjun <weiyongjun1@huawei.com>
To: Songjun Wu <songjun.wu@microchip.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
CC: Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -next] media: atmel-isc: Make local symbol fmt_configs_list static
Date: Sat, 23 Dec 2017 01:57:04 +0000
Message-ID: <1513994224-86350-1-git-send-email-weiyongjun1@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following sparse warning:

drivers/media/platform/atmel/atmel-isc.c:338:19: warning:
 symbol 'fmt_configs_list' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/media/platform/atmel/atmel-isc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 0c26356..2dd72fc 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -335,7 +335,7 @@ struct isc_device {
 	},
 };
 
-struct fmt_config fmt_configs_list[] = {
+static struct fmt_config fmt_configs_list[] = {
 	{
 		.fourcc		= V4L2_PIX_FMT_SBGGR8,
 		.pfe_cfg0_bps	= ISC_PFE_CFG0_BPS_EIGHT,
