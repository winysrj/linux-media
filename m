Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41247 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2HMSmm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 14:42:42 -0400
Received: by wicr5 with SMTP id r5so2902606wic.1
        for <linux-media@vger.kernel.org>; Mon, 13 Aug 2012 11:42:40 -0700 (PDT)
Message-ID: <1344883337.3041.0.camel@router7789>
Subject: [PATCH] re: [media] lmedm04: fix build
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Mon, 13 Aug 2012 19:42:17 +0100
In-Reply-To: <20120813165811.GB5363@elgon.mountain>
References: <20120813165811.GB5363@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2012-08-13 at 19:58 +0300, Dan Carpenter wrote:
> Hello Mauro Carvalho Chehab,
> 
> The patch db6651a9ebb3: "[media] lmedm04: fix build" from Aug 12, 
> 2012, leads to the following warning:
> drivers/media/dvb/dvb-usb-v2/lmedm04.c:769 lme2510_download_firmware()
> 	 error: usb_control_msg() 'data' too small (128 vs 265)
> 
>    737          data = kzalloc(128, GFP_KERNEL);
>                                ^^^
> data is 128 bytes.
Hi All

Control isn't used, so remove it.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/media/dvb/dvb-usb-v2/lmedm04.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb-v2/lmedm04.c b/drivers/media/dvb/dvb-usb-v2/lmedm04.c
index c6bc1b8..c41d9d9 100644
--- a/drivers/media/dvb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb-v2/lmedm04.c
@@ -766,10 +766,6 @@ static int lme2510_download_firmware(struct dvb_usb_device *d,
 		}
 	}
 
-	usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0),
-			0x06, 0x80, 0x0200, 0x00, data, 0x0109, 1000);
-
-
 	data[0] = 0x8a;
 	len_in = 1;
 	msleep(2000);
-- 
1.7.9.5




