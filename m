Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:56420 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3FNVCC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 17:02:02 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1/2] radio-sf16fmi: Add module name to bus_info
Date: Fri, 14 Jun 2013 23:01:38 +0200
Message-Id: <1371243699-28946-2-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1371243699-28946-1-git-send-email-linux@rainbow-software.org>
References: <1371243699-28946-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix v4l2-compliance in VIDIOC_QUERYCAP by changing "ISA" to "ISA:radio-sf16fmi".

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/radio/radio-sf16fmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index 9e712c8..ed7299d 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -123,7 +123,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 {
 	strlcpy(v->driver, "radio-sf16fmi", sizeof(v->driver));
 	strlcpy(v->card, "SF16-FMI/FMP/FMD radio", sizeof(v->card));
-	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
+	strlcpy(v->bus_info, "ISA:radio-sf16fmi", sizeof(v->bus_info));
 	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
-- 
Ondrej Zary

