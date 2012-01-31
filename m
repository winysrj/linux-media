Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:55202 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab2AaJX6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jan 2012 04:23:58 -0500
Received: by werb13 with SMTP id b13so154354wer.19
        for <linux-media@vger.kernel.org>; Tue, 31 Jan 2012 01:23:57 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, hverkuil@xs4all.nl,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 2/2] media: tvp5150: support g_mbus_fmt callback.
Date: Tue, 31 Jan 2012 10:23:47 +0100
Message-Id: <1328001827-21251-2-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1328001827-21251-1-git-send-email-javier.martin@vista-silicon.com>
References: <1328001827-21251-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/tvp5150.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index b1476f6..e292c46 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -1102,6 +1102,7 @@ static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
 	.enum_mbus_fmt = tvp5150_enum_mbus_fmt,
 	.s_mbus_fmt = tvp5150_mbus_fmt,
 	.try_mbus_fmt = tvp5150_mbus_fmt,
+	.g_mbus_fmt = tvp5150_mbus_fmt,
 	.s_crop = tvp5150_s_crop,
 	.g_crop = tvp5150_g_crop,
 	.cropcap = tvp5150_cropcap,
-- 
1.7.0.4

