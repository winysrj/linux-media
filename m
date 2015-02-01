Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:58747 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbbBATSf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Feb 2015 14:18:35 -0500
Message-ID: <54CE7BF7.20204@users.sourceforge.net>
Date: Sun, 01 Feb 2015 20:18:15 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	devel@driverdev.osuosl.org, linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 2/2] [media] mn88472: One function call less in mn88472_init()
 after error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54CE7A6E.104@users.sourceforge.net>
In-Reply-To: <54CE7A6E.104@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 1 Feb 2015 19:34:37 +0100

The release_firmware() function was called in three cases by the mn88472_init()
function during error handling even if the passed variable "fw" contained still
a null pointer.

This implementation detail could be improved by the introduction of another
jump label.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/staging/media/mn88472/mn88472.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index e7874ae..3975a57 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -286,7 +286,7 @@ static int mn88472_init(struct dvb_frontend *fe)
 
 	ret = regmap_write(dev->regmap[0], 0xf5, 0x03);
 	if (ret)
-		goto err;
+		goto firmware_release;
 
 	for (remaining = fw->size; remaining > 0;
 			remaining -= (dev->i2c_wr_max - 1)) {
@@ -299,13 +299,13 @@ static int mn88472_init(struct dvb_frontend *fe)
 		if (ret) {
 			dev_err(&client->dev,
 					"firmware download failed=%d\n", ret);
-			goto err;
+			goto firmware_release;
 		}
 	}
 
 	ret = regmap_write(dev->regmap[0], 0xf5, 0x00);
 	if (ret)
-		goto err;
+		goto firmware_release;
 
 	release_firmware(fw);
 	fw = NULL;
@@ -314,9 +314,9 @@ static int mn88472_init(struct dvb_frontend *fe)
 	dev->warm = true;
 
 	return 0;
-err:
+firmware_release:
 	release_firmware(fw);
-
+err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
-- 
2.2.2

