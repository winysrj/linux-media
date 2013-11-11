Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:41539 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab3KKLq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Nov 2013 06:46:28 -0500
Received: by mail-ee0-f44.google.com with SMTP id d51so274993eek.3
        for <linux-media@vger.kernel.org>; Mon, 11 Nov 2013 03:46:27 -0800 (PST)
From: Michal Nazarewicz <mina86@mina86.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCHv2] staging: go7007: fix use of uninitialised pointer
In-Reply-To: <20131110210647.GA5302@mwanda>
References: <1384108677-23476-1-git-send-email-mpn@google.com> <20131110185210.GA9633@kroah.com> <87fvr480o9.fsf@mina86.com> <20131110210647.GA5302@mwanda>
Date: Mon, 11 Nov 2013 12:46:24 +0100
Message-ID: <xa1tzjpbxisv.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

go variable is initialised only after the switch case so it cannot be
dereferenced prior to that happening.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/staging/media/go7007/go7007-usb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

On Sun, Nov 10 2013, Dan Carpenter wrote:
> There are 3 other uses before "go" gets initialized.

Argh...  Other occurrences of the letters “GO” deceived my eyes.  Sorry
about that and thanks.

diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 58684da..ee8ab89 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1057,7 +1057,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	char *name;
 	int video_pipe, i, v_urb_len;
 
-	dev_dbg(go->dev, "probing new GO7007 USB board\n");
+	dev_dbg(&intf->dev, "probing new GO7007 USB board\n");
 
 	switch (id->driver_info) {
 	case GO7007_BOARDID_MATRIX_II:
@@ -1097,13 +1097,13 @@ static int go7007_usb_probe(struct usb_interface *intf,
 		board = &board_px_tv402u;
 		break;
 	case GO7007_BOARDID_LIFEVIEW_LR192:
-		dev_err(go->dev, "The Lifeview TV Walker Ultra is not supported. Sorry!\n");
+		dev_err(&intf->dev, "The Lifeview TV Walker Ultra is not supported. Sorry!\n");
 		return -ENODEV;
 		name = "Lifeview TV Walker Ultra";
 		board = &board_lifeview_lr192;
 		break;
 	case GO7007_BOARDID_SENSORAY_2250:
-		dev_info(go->dev, "Sensoray 2250 found\n");
+		dev_info(&intf->dev, "Sensoray 2250 found\n");
 		name = "Sensoray 2250/2251";
 		board = &board_sensoray_2250;
 		break;
@@ -1112,7 +1112,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 		board = &board_ads_usbav_709;
 		break;
 	default:
-		dev_err(go->dev, "unknown board ID %d!\n",
+		dev_err(&intf->dev, "unknown board ID %d!\n",
 				(unsigned int)id->driver_info);
 		return -ENODEV;
 	}
-- 
1.8.4.1

