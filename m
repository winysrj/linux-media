Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54844 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbeKZJn1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 04:43:27 -0500
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: dib0700: fix spelling mistake "Amplifyer" -> "Amplifier"
Date: Sun, 25 Nov 2018 22:51:14 +0000
Message-Id: <20181125225114.13850-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in the MODULE_PARM_DESC text, fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/dvb-usb/dib0700_devices.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 7551dce96f64..9311f7d4bba5 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -29,7 +29,7 @@
 
 static int force_lna_activation;
 module_param(force_lna_activation, int, 0644);
-MODULE_PARM_DESC(force_lna_activation, "force the activation of Low-Noise-Amplifyer(s) (LNA), if applicable for the device (default: 0=automatic/off).");
+MODULE_PARM_DESC(force_lna_activation, "force the activation of Low-Noise-Amplifier(s) (LNA), if applicable for the device (default: 0=automatic/off).");
 
 struct dib0700_adapter_state {
 	int (*set_param_save) (struct dvb_frontend *);
-- 
2.19.1
