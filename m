Return-path: <linux-media-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:56864 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab3DXLg6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Apr 2013 07:36:58 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] [media] anysee: Grammar s/report the/report to/
Date: Wed, 24 Apr 2013 13:36:46 +0200
Message-Id: <1366803406-17738-2-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1366803406-17738-1-git-send-email-geert@linux-m68k.org>
References: <1366803406-17738-1-git-send-email-geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/usb/dvb-usb-v2/anysee.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index 3a1f976..1760fee 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -885,7 +885,7 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 		/* we have no frontend :-( */
 		ret = -ENODEV;
 		dev_err(&d->udev->dev, "%s: Unsupported Anysee version. " \
-				"Please report the " \
+				"Please report to " \
 				"<linux-media@vger.kernel.org>.\n",
 				KBUILD_MODNAME);
 	}
-- 
1.7.0.4

