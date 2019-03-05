Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0659AC43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 13:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6CF520842
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 13:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbfCENXq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 08:23:46 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:45471 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbfCENXq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 08:23:46 -0500
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M8hMn-1gx1J13Kin-004hsO; Tue, 05 Mar 2019 14:23:34 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: i2c: adv748x: select V4L2_FWNODE
Date:   Tue,  5 Mar 2019 14:23:13 +0100
Message-Id: <20190305132332.3788205-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:4hIvftGdIWzBWpVrk4xdlrnzuXQ5gJB/LWm1mxz6mm816qEwY3x
 bahg8Q1lFcnvUA2CsXqR6Bl6+uRybDFDsHdoCmrF0cNg+lnXOYSzcffhrvE1iiosjgSg3aC
 6VuzqYmNruKxZswJe2LfncJL1b8C4099Bl7yv6VJhHJjidrJ9pJgQR9Vn9ZYzQLmOCb9D4b
 7UATxfUEC3mhRcaWkCMyA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:34tkLrJiEpE=:PS+jBSPRSlybCVb3mOXZjP
 NSsYu2Dltj3RvvvYY2sEfSsB6H8K7IiPOPx7ZRA7R4ExYZPmQs8qKnORHwgTwtfnNMMnh1/bZ
 AEwNAnXJ98j/U3gke94x4AHBPYm4HACcpygWydCBUCAMfCKbQQ3R0h1XTF7xNLsBWIPDpYGLa
 ayt4RWMJALdiIr9WXUubsW47t+PrsJ9gKres/+Y/TCDNmphe5qT3hK2absBh13WvrCEtJfofi
 cXJdBjnN7X9HWxyo69stDyL72HXebTR2vQylfhwGcgARc6J/ZiNnJabjeqDxrKQBfByRJDP05
 4xVoG8ruxuoy4M6qcthzgl2Ab7x4fF4qzrMfBDLYLU+mNXf8D4l91oqI5eQBlR3bOvWYaId17
 4v7gF1ZonedsvC0aQkUd2drAy2f04FN+Mpw41htHRj7e9Yx/7qqIC3hfGkT/qj0QPEY16YxKL
 capIMLlyJknPepMPe8rTgMHTex5LQWV4SZybFvKWKhbGaKPananBsXKPJgiLhFUSPZ0slnnJR
 sWgnMeAljONfM5Sh60nFDvoFg3nNl6xKiIl/ZOgmk6t6M25pm+IeXJoneIcCQtuM2Y6pESKyQ
 LP9ch4ePuMtjwidH34czIeKCKjL0lnOFxUroYWta7k/ltvMfbecvx4L2xllm7i6tTIebTbL7y
 t19xHuUaRLOCVtubejrnuqbo0I14HBBog8dMSL1hTWDuooR6+d5y6dlVq1aQIBRNN68V3XW6/
 9ox8NQSjupKRAkoYaEkqOJjMQi5RvwwAe1qAVg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Building adv748x fails now unless V4L2_FWNODE is selected:

drivers/media/i2c/adv748x/adv748x-core.o: In function `adv748x_probe':
adv748x-core.c:(.text+0x1b2c): undefined reference to `v4l2_fwnode_endpoint_parse'

Fixes: 6a18865da8e3 ("media: i2c: adv748x: store number of CSI-2 lanes described in device tree")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/i2c/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 6d32f8dcf83b..3f5dd80e14f8 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -221,6 +221,7 @@ config VIDEO_ADV748X
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	depends on OF
 	select REGMAP_I2C
+	select V4L2_FWNODE
 	---help---
 	  V4L2 subdevice driver for the Analog Devices
 	  ADV7481 and ADV7482 HDMI/Analog video decoders.
-- 
2.20.0

