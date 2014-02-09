Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44478 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbaBIIt7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:49:59 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 36/86] msi3101: disable all but u8 and u16le formats
Date: Sun,  9 Feb 2014 10:48:41 +0200
Message-Id: <1391935771-18670-37-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As for now, better to support only two general stream formats.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 2b812fe..e6b7cba 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -416,6 +416,7 @@ static struct msi3101_format formats[] = {
 	}, {
 		.name		= "16-bit unsigned little endian",
 		.pixelformat	= V4L2_PIX_FMT_SDR_U16LE,
+#if 0
 	}, {
 		.name		= "8-bit signed",
 		.pixelformat	= V4L2_PIX_FMT_SDR_S8,
@@ -428,6 +429,7 @@ static struct msi3101_format formats[] = {
 	}, {
 		.name		= "14-bit signed",
 		.pixelformat	= V4L2_PIX_FMT_SDR_S14,
+#endif
 	},
 };
 
-- 
1.8.5.3

