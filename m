Return-path: <mchehab@gaivota>
Received: from smtp.nokia.com ([147.243.1.47]:22866 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab1ADLaS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jan 2011 06:30:18 -0500
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com, hverkuil@xs4all.nl
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH] V4L2: WL1273 FM Radio: Replace ioctl with unlocked_ioctl.
Date: Tue,  4 Jan 2011 13:29:37 +0200
Message-Id: <1294140577-15872-1-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Use unlocked_ioctl in v4l2_file_operations. The locking is
already in place.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
---
 drivers/media/radio/radio-wl1273.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 1813790..d6c2099 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1408,7 +1408,7 @@ static const struct v4l2_file_operations wl1273_fops = {
 	.read		= wl1273_fm_fops_read,
 	.write		= wl1273_fm_fops_write,
 	.poll		= wl1273_fm_fops_poll,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.open		= wl1273_fm_fops_open,
 	.release	= wl1273_fm_fops_release,
 };
-- 
1.6.1.3

