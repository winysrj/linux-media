Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:45606 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301Ab0ADODN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2010 09:03:13 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, hverkuil@xs4all.nl,
	davinci-linux-open-source@linux.davincidsp.com,
	m-karicheri2@ti.com, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 3/9] tvp514x: add YUYV format support
Date: Mon,  4 Jan 2010 19:32:56 +0530
Message-Id: <1262613782-20463-4-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>


Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/tvp514x.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
index 4cf3593..b344b58 100644
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/video/tvp514x.c
@@ -212,6 +212,13 @@ static const struct v4l2_fmtdesc tvp514x_fmt_list[] = {
 	 .description = "8-bit UYVY 4:2:2 Format",
 	 .pixelformat = V4L2_PIX_FMT_UYVY,
 	},
+	{
+	 .index = 1,
+	 .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+	 .flags = 0,
+	 .description = "8-bit YUYV 4:2:2 Format",
+	 .pixelformat = V4L2_PIX_FMT_YUYV,
+	},
 };
 
 /**
-- 
1.6.2.4

