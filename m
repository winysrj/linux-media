Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4343 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaHHM7Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Aug 2014 08:59:24 -0400
Message-ID: <53E4C996.4060001@xs4all.nl>
Date: Fri, 08 Aug 2014 14:59:02 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Subject: [RFC PATCH] vb2: use pr_info instead of pr_debug
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modern kernels enable dynamic printk support, which is fine, except when it is
combined with a debug module option. Enabling debug in videobuf2-core now produces
no debugging unless it is also enabled through the dynamic printk support in debugfs.

Either use a debug module option + pr_info, or use pr_debug without a debug module
option. In this case the fact that you can set various debug levels is very useful,
so I believe that for videobuf2-core.c we should use pr_info.

The mix of the two is very confusing: I've spent too much time already trying to
figure out why I am not seeing any debug output in the kernel log when I do:

	echo 1 >/sys/modules/videobuf2_core/parameters/debug

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 0e3d927..0b59735 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -36,7 +36,7 @@ module_param(debug, int, 0644);
 #define dprintk(level, fmt, arg...)					      \
 	do {								      \
 		if (debug >= level)					      \
-			pr_debug("vb2: %s: " fmt, __func__, ## arg); \
+			pr_info("vb2: %s: " fmt, __func__, ## arg); \
 	} while (0)
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
