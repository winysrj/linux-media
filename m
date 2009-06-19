Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.wellnetcz.com ([212.24.148.102]:40502 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZFSUaR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 16:30:17 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 4/4] V4L: saa7134, fix lock imbalance
Date: Fri, 19 Jun 2009 22:30:07 +0200
Message-Id: <1245443407-17410-4-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1245443407-17410-1-git-send-email-jirislaby@gmail.com>
References: <1245443407-17410-1-git-send-email-jirislaby@gmail.com>
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

