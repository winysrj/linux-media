Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:57018 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753350Ab2HGJZF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 05:25:05 -0400
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 8FD8A121
	for <linux-media@vger.kernel.org>; Tue,  7 Aug 2012 09:25:02 +0000 (GMT)
Received: from Webmail-eu.st.com (safex1hubcas1.st.com [10.75.90.14])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 37AFF2904
	for <linux-media@vger.kernel.org>; Tue,  7 Aug 2012 09:25:02 +0000 (GMT)
From: Nicolas THERY <nicolas.thery@st.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 7 Aug 2012 11:24:59 +0200
Subject: [PATCH] media: fix MEDIA_IOC_DEVICE_INFO return code
Message-ID: <5020DEEB.60901@st.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MEDIA_IOC_DEVICE_INFO ioctl was returning a positive value rather
than a negative error code when failing to copy output parameter to
user-space.

Tested by compilation only.

Signed-off-by: Nicolas Thery <nicolas.thery@st.com>
---
 drivers/media/media-device.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 6f9eb94..d01fcb7 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -59,7 +59,9 @@ static int media_device_get_info(struct media_device *dev,
 	info.hw_revision = dev->hw_revision;
 	info.driver_version = dev->driver_version;
 
-	return copy_to_user(__info, &info, sizeof(*__info));
+	if (copy_to_user(__info, &info, sizeof(*__info)))
+		return -EFAULT;
+	return 0;
 }
 
 static struct media_entity *find_entity(struct media_device *mdev, u32 id)
-- 
1.7.11.3

