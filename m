Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.telros.ru ([83.136.244.21]:62812 "EHLO mail.telros.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab2EaHI5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 May 2012 03:08:57 -0400
Date: Thu, 31 May 2012 11:08:51 +0400
From: volokh@telros.ru
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Volokh Konstantin <volokh84@gmail.com>, linux-media@vger.kernel.org
Subject: [PATCH] media: video: bt8xx: Remove duplicated pixel format entry.
Message-ID: <20120531070851.GC22460@VPir.telros.lan>
References: <1338059923-4989-1-git-send-email-volokh84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338059923-4989-1-git-send-email-volokh84@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/media/video/bt8xx/bttv-driver.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-driver.c
+b/drivers/media/video/bt8xx/bttv-driver.c
index e581b37..b4ee7de 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -558,12 +558,6 @@ static const struct bttv_format formats[] = {
                .depth    = 16,
                .flags    = FORMAT_FLAGS_PACKED,
        },{
-               .name     = "4:2:2, packed, YUYV",
-               .fourcc   = V4L2_PIX_FMT_YUYV,
-               .btformat = BT848_COLOR_FMT_YUY2,
-               .depth    = 16,
-               .flags    = FORMAT_FLAGS_PACKED,
-       },{
                .name     = "4:2:2, packed, UYVY",
                .fourcc   = V4L2_PIX_FMT_UYVY,
                .btformat = BT848_COLOR_FMT_YUY2,
--
1.7.7.6


