Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.wellnetcz.com ([212.24.148.102]:57671 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758966AbZGCUwM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jul 2009 16:52:12 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH repost 4/4] V4L: saa7134, fix lock imbalance
Date: Fri,  3 Jul 2009 22:51:36 +0200
Message-Id: <1246654296-23190-4-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1246654296-23190-1-git-send-email-jirislaby@gmail.com>
References: <1246654296-23190-1-git-send-email-jirislaby@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There seems to be one superfluos unlock in a poll function. Remove it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/media/video/saa7134/saa7134-video.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index 82b57a6..dd9aab0 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -1443,7 +1443,6 @@ video_poll(struct file *file, struct poll_table_struct *wait)
 			fh->cap.ops->buf_queue(&fh->cap,fh->cap.read_buf);
 			fh->cap.read_off = 0;
 		}
-		mutex_unlock(&fh->cap.vb_lock);
 		buf = fh->cap.read_buf;
 	}
 
-- 
1.6.3.2

