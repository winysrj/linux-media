Return-path: <linux-media-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:59536 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbbDPM3z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 08:29:55 -0400
From: weiyj_lk@163.com
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media@vger.kernel.org
Subject: [PATCH] [media] rtl28xxu: fix return value check in rtl2832u_tuner_attach()
Date: Thu, 16 Apr 2015 20:22:46 +0800
Message-Id: <1429186966-21163-1-git-send-email-weiyj_lk@163.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function platform_device_register_data() returns
ERR_PTR() and never returns NULL. The NULL test in the return value check
should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 87fc0fe..1723407 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1176,7 +1176,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 						     "rtl2832_sdr",
 						     PLATFORM_DEVID_AUTO,
 						     &pdata, sizeof(pdata));
-		if (pdev == NULL || pdev->dev.driver == NULL)
+		if (IS_ERR(pdev) || pdev->dev.driver == NULL)
 			break;
 		dev->platform_device_sdr = pdev;
 		break;

