Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58244 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab2DBV0n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 17:26:43 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so3083820wgb.1
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2012 14:26:42 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, crope@iki.fi
Cc: m@bues.ch, hfvogt@gmx.net, mchehab@redhat.com,
	Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 4/5] af9035: fix warning
Date: Mon,  2 Apr 2012 23:25:16 +0200
Message-Id: <1333401917-27203-5-git-send-email-gennarone@gmail.com>
In-Reply-To: <1333401917-27203-1-git-send-email-gennarone@gmail.com>
References: <1333401917-27203-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

af9035.c: In function 'af9035_download_firmware':
af9035.c:446:3: warning: format '%lu' expects argument of type 'long unsigned
int', but argument 3 has type 'unsigned int' [-Wformat]

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/dvb/dvb-usb/af9035.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9035.c b/drivers/media/dvb/dvb-usb/af9035.c
index f943c57..8bf6367 100644
--- a/drivers/media/dvb/dvb-usb/af9035.c
+++ b/drivers/media/dvb/dvb-usb/af9035.c
@@ -443,7 +443,7 @@ static int af9035_download_firmware(struct usb_device *udev,
 
 		i -= hdr_data_len + HDR_SIZE;
 
-		pr_debug("%s: data uploaded=%lu\n", __func__, fw->size - i);
+		pr_debug("%s: data uploaded=%u\n", __func__, fw->size - i);
 	}
 
 	/* firmware loaded, request boot */
-- 
1.7.5.4

