Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:55743 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab3K0DPM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 22:15:12 -0500
Message-ID: <52956442.50001@gmail.com>
Date: Wed, 27 Nov 2013 11:17:22 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
MIME-Version: 1.0
To: hans.verkuil@cisco.com, m.chehab@samsung.com
CC: rkuo <rkuo@codeaurora.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: [PATCH] drivers: staging: media: go7007: go7007-usb.c use pr_*()
 instead of dev_*() before 'go' initialized in go7007_usb_probe()
References: <528AEFB7.4060301@gmail.com> <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com> <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com>
In-Reply-To: <5294255E.7040105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dev_*() assumes 'go' is already initialized, so need use pr_*() instead
of before 'go' initialized. Related warning (with allmodconfig under
hexagon):

    CC [M]  drivers/staging/media/go7007/go7007-usb.o
  drivers/staging/media/go7007/go7007-usb.c: In function 'go7007_usb_probe':
  drivers/staging/media/go7007/go7007-usb.c:1060:2: warning: 'go' may be used uninitialized in this function [-Wuninitialized]

Also remove useless code after 'return' statement.


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/staging/media/go7007/go7007-usb.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 58684da..30310e9 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1057,7 +1057,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	char *name;
 	int video_pipe, i, v_urb_len;
 
-	dev_dbg(go->dev, "probing new GO7007 USB board\n");
+	pr_devel("probing new GO7007 USB board\n");
 
 	switch (id->driver_info) {
 	case GO7007_BOARDID_MATRIX_II:
@@ -1097,13 +1097,10 @@ static int go7007_usb_probe(struct usb_interface *intf,
 		board = &board_px_tv402u;
 		break;
 	case GO7007_BOARDID_LIFEVIEW_LR192:
-		dev_err(go->dev, "The Lifeview TV Walker Ultra is not supported. Sorry!\n");
+		pr_err("The Lifeview TV Walker Ultra is not supported. Sorry!\n");
 		return -ENODEV;
-		name = "Lifeview TV Walker Ultra";
-		board = &board_lifeview_lr192;
-		break;
 	case GO7007_BOARDID_SENSORAY_2250:
-		dev_info(go->dev, "Sensoray 2250 found\n");
+		pr_info("Sensoray 2250 found\n");
 		name = "Sensoray 2250/2251";
 		board = &board_sensoray_2250;
 		break;
@@ -1112,7 +1109,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 		board = &board_ads_usbav_709;
 		break;
 	default:
-		dev_err(go->dev, "unknown board ID %d!\n",
+		pr_err("unknown board ID %d!\n",
 				(unsigned int)id->driver_info);
 		return -ENODEV;
 	}
-- 
1.7.7.6
