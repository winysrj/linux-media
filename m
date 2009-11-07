Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42387 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753431AbZKGVva convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:51:30 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:51:32 +0000
Message-ID: <1257630692.15927.425.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 31/75] cx25840: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/cx25840/cx25840-firmware.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx25840/cx25840-firmware.c b/drivers/media/video/cx25840/cx25840-firmware.c
index 8150200..6dd9253 100644
--- a/drivers/media/video/cx25840/cx25840-firmware.c
+++ b/drivers/media/video/cx25840/cx25840-firmware.c
@@ -73,6 +73,9 @@ static const char *get_fw_name(struct i2c_client *client)
 		return "v4l-cx231xx-avcore-01.fw";
 	return "v4l-cx25840.fw";
 }
+MODULE_FIRMWARE("v4l-cx23885-avcore-01.fw");
+MODULE_FIRMWARE("v4l-cx231xx-avcore-01.fw");
+MODULE_FIRMWARE("v4l-cx25840.fw");
 
 static int check_fw_load(struct i2c_client *client, int size)
 {
-- 
1.6.5.2



