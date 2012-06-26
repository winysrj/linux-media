Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab2FZTeh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 15:34:37 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>, Kay Sievers <kay@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 4/4] tuner-xc2028: tag the usual firmwares to help dracut
Date: Tue, 26 Jun 2012 16:34:22 -0300
Message-Id: <1340739262-13747-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1340739262-13747-1-git-send-email-mchehab@redhat.com>
References: <4FE9169D.5020300@redhat.com>
 <1340739262-13747-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When tuner-xc2028 is not compiled as a module, dracut will
need to copy the firmware inside the initfs image.

So, use MODULE_FIRMWARE() to indicate such need.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/tuner-xc2028.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index b5ee3eb..2e6c966 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -1375,3 +1375,5 @@ MODULE_DESCRIPTION("Xceive xc2028/xc3028 tuner driver");
 MODULE_AUTHOR("Michel Ludwig <michel.ludwig@gmail.com>");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(XC2028_DEFAULT_FIRMWARE);
+MODULE_FIRMWARE(XC3028L_DEFAULT_FIRMWARE);
-- 
1.7.10.2

