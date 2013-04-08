Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3082 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935469Ab3DHKsB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 06:48:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Eduardo Valentin <edubezval@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 3/7] radio-si4713: improve querycap
Date: Mon,  8 Apr 2013 12:47:37 +0200
Message-Id: <1365418061-23694-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365418061-23694-1-git-send-email-hverkuil@xs4all.nl>
References: <1365418061-23694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Set bus_info and fill in device_caps.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-si4713.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index 70dc652..f0f0a90 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -67,7 +67,10 @@ static int radio_si4713_querycap(struct file *file, void *priv,
 	strlcpy(capability->driver, "radio-si4713", sizeof(capability->driver));
 	strlcpy(capability->card, "Silicon Labs Si4713 Modulator",
 		sizeof(capability->card));
-	capability->capabilities = V4L2_CAP_MODULATOR | V4L2_CAP_RDS_OUTPUT;
+	strlcpy(capability->bus_info, "platform:radio-si4713",
+		sizeof(capability->bus_info));
+	capability->device_caps = V4L2_CAP_MODULATOR | V4L2_CAP_RDS_OUTPUT;
+	capability->capabilities = capability->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
 }
-- 
1.7.10.4

