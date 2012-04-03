Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63193 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab2DCAeY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 20:34:24 -0400
Received: by wgbdr13 with SMTP id dr13so3179019wgb.1
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2012 17:34:23 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, crope@iki.fi
Cc: m@bues.ch, hfvogt@gmx.net, mchehab@redhat.com,
	Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 4/5 v2] af9035: fix warning
Date: Tue,  3 Apr 2012 02:32:58 +0200
Message-Id: <1333413178-20737-1-git-send-email-gennarone@gmail.com>
In-Reply-To: <GmailId1367538da899604d>
References: <GmailId1367538da899604d>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On a 32 bit system:

af9035.c: In function 'af9035_download_firmware':
af9035.c:446:3: warning: format '%lu' expects argument of type 'long unsigned
int', but argument 3 has type 'unsigned int' [-Wformat]

%zu avoids any warning on both 32 and 64 bit systems.

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
+		pr_debug("%s: data uploaded=%zu\n", __func__, fw->size - i);
 	}
 
 	/* firmware loaded, request boot */
-- 
1.7.5.4

