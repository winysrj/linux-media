Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:19234 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbZHJJ7N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 05:59:13 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "ext Hans Verkuil" <hverkuil@xs4all.nl>,
	"ext Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCH 1/1] si4713-i2c: Fix null pointer reference in probe
Date: Mon, 10 Aug 2009 12:46:09 +0300
Message-Id: <1249897569-24203-1-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove reference to uninitialized v4l2_subdevice pointer
in fail path of probe function.

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 linux/drivers/media/radio/si4713-i2c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/linux/drivers/media/radio/si4713-i2c.c b/linux/drivers/media/radio/si4713-i2c.c
index 116555c..e45d236 100644
--- a/linux/drivers/media/radio/si4713-i2c.c
+++ b/linux/drivers/media/radio/si4713-i2c.c
@@ -1976,7 +1976,7 @@ static int si4713_probe(struct i2c_client *client,
 
 	sdev->platform_data = client->dev.platform_data;
 	if (!sdev->platform_data) {
-		v4l2_err(&sdev->sd, "No platform data registered.\n");
+		dev_err(&client->dev, "No platform data registered.\n");
 		rval = -ENODEV;
 		goto free_sdev;
 	}
-- 
1.6.2.GIT

