Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34215 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729181AbeKLKkd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Nov 2018 05:40:33 -0500
Date: Sun, 11 Nov 2018 16:49:53 -0800
From: Myungho Jung <mhjungk@gmail.com>
To: pawel@osciak.com, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: videobuf2-core: Fix error handling when fileio is
 deallocated
Message-ID: <20181112004951.GA3948@myunghoj-Precision-5530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mutex that is held from vb2_fop_read() can be unlocked while waiting
for a buffer if the queue is streaming and blocking. Meanwhile, fileio
can be released. So, it should return an error if the fileio address is
changed.

Signed-off-by: Myungho Jung <mhjungk@gmail.com>
Reported-by: syzbot+4180ff9ca6810b06c1e9@syzkaller.appspotmail.com
---
 drivers/media/common/videobuf2/videobuf2-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 975ff5669f72..bff94752eb27 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -2564,6 +2564,10 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		dprintk(5, "vb2_dqbuf result: %d\n", ret);
 		if (ret)
 			return ret;
+		if (fileio != q->fileio) {
+			dprintk(3, "fileio deallocated\n");
+			return -EFAULT;
+		}
 		fileio->dq_count += 1;
 
 		fileio->cur_index = index;
-- 
2.17.1
