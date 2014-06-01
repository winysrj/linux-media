Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:64186 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbaFAM20 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Jun 2014 08:28:26 -0400
Received: by mail-we0-f172.google.com with SMTP id k48so3999954wev.31
        for <linux-media@vger.kernel.org>; Sun, 01 Jun 2014 05:28:25 -0700 (PDT)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: usb: dvb-usb-v2: mxl111sf.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 14:29:19 +0200
Message-Id: <1401625759-14610-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index c7304fa..b8a707e 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -129,7 +129,7 @@ int mxl111sf_write_reg_mask(struct mxl111sf_state *state,
 				   u8 addr, u8 mask, u8 data)
 {
 	int ret;
-	u8 val;
+	u8 val = 0;
 
 	if (mask != 0xff) {
 		ret = mxl111sf_read_reg(state, addr, &val);
-- 
1.7.10.4

