Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:34221 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbbJOUVm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2015 16:21:42 -0400
From: Insu Yun <wuninsu@gmail.com>
To: mkrufky@linuxtv.org, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu,
	Insu Yun <wuninsu@gmail.com>
Subject: [PATCH] mxl111sf: missing return values validation
Date: Thu, 15 Oct 2015 20:22:45 +0000
Message-Id: <1444940565-30730-1-git-send-email-wuninsu@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return values of mxl111sf_enable_usb_output and mxl1x1sf_top_master_ctrl 
are not validated.

Signed-off-by: Insu Yun <wuninsu@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index bec12b0..b71b2e6 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -288,9 +288,9 @@ static int mxl111sf_adap_fe_init(struct dvb_frontend *fe)
 	err = mxl1x1sf_set_device_mode(state, adap_state->device_mode);
 
 	mxl_fail(err);
-	mxl111sf_enable_usb_output(state);
+	err = mxl111sf_enable_usb_output(state);
 	mxl_fail(err);
-	mxl1x1sf_top_master_ctrl(state, 1);
+	err = mxl1x1sf_top_master_ctrl(state, 1);
 	mxl_fail(err);
 
 	if ((MXL111SF_GPIO_MOD_DVBT != adap_state->gpio_mode) &&
-- 
1.9.1

