Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42453 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaKBMcs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 07:32:48 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 11/14] [media] cx231xx: add addr for demod and make i2c_devs const
Date: Sun,  2 Nov 2014 10:32:34 -0200
Message-Id: <c8a1b2e008308f136c4f21d2e6e937d3d926fa20.1414929816.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414929816.git.mchehab@osg.samsung.com>
References: <cover.1414929816.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414929816.git.mchehab@osg.samsung.com>
References: <cover.1414929816.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I2C address 0x10 is the demod. While here, make the array const.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index c4dc13afbe05..87b26157cad0 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -471,7 +471,8 @@ static struct i2c_adapter cx231xx_adap_template = {
  * i2c_devs
  * incomplete list of known devices
  */
-static char *i2c_devs[128] = {
+static const char *i2c_devs[128] = {
+	[0x20 >> 1] = "demod",
 	[0x60 >> 1] = "colibri",
 	[0x88 >> 1] = "hammerhead",
 	[0x8e >> 1] = "CIR",
-- 
1.9.3

