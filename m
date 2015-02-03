Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50787 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965948AbbBCSlC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 13:41:02 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/3] [media] rtl28xxu: properly initialize pdata
Date: Tue,  3 Feb 2015 16:40:51 -0200
Message-Id: <e181b1f19045a5843aefafa561207fbea8bd2973.1422988845.git.mchehab@osg.samsung.com>
In-Reply-To: <d858b0e787a8eef66457bcbbd9a758a327102b94.1422988845.git.mchehab@osg.samsung.com>
References: <d858b0e787a8eef66457bcbbd9a758a327102b94.1422988845.git.mchehab@osg.samsung.com>
In-Reply-To: <d858b0e787a8eef66457bcbbd9a758a327102b94.1422988845.git.mchehab@osg.samsung.com>
References: <d858b0e787a8eef66457bcbbd9a758a327102b94.1422988845.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As complained by smatch:
	drivers/media/usb/dvb-usb-v2/rtl28xxu.c:1159 rtl2832u_tuner_attach() info: 'pdata' is not actually initialized (unreached code).

Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index d88f7994bc7c..77dcfdf547ac 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1055,10 +1055,13 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 	struct i2c_board_info info;
 	struct i2c_client *client;
 	struct v4l2_subdev *subdev = NULL;
+	struct platform_device *pdev;
+	struct rtl2832_sdr_platform_data pdata;
 
 	dev_dbg(&d->intf->dev, "\n");
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
+	memset(&pdata, 0, sizeof(pdata));
 
 	switch (dev->tuner) {
 	case TUNER_RTL2832_FC0012:
@@ -1155,9 +1158,6 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 
 	/* register SDR */
 	switch (dev->tuner) {
-		struct platform_device *pdev;
-		struct rtl2832_sdr_platform_data pdata = {};
-
 	case TUNER_RTL2832_FC0012:
 	case TUNER_RTL2832_FC0013:
 	case TUNER_RTL2832_E4000:
-- 
2.1.0

