Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42577 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbbLRQOz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 11:14:55 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] [media] videobuf2: avoid memory leak on errors
Date: Fri, 18 Dec 2015 14:14:30 -0200
Message-Id: <b62ef37c6e2f30d1b5ce3889212050d738c04885.1450455268.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/v4l2-core/videobuf2-core.c:2415 __vb2_init_fileio() warn: possible memory leak of 'fileio'

While here, avoid the usage of sizeof(struct foo_struct).

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index e6890d47cdcb..c5d49d7a0d76 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2406,13 +2406,15 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 		(read) ? "read" : "write", count, q->fileio_read_once,
 		q->fileio_write_immediately);
 
-	fileio = kzalloc(sizeof(struct vb2_fileio_data), GFP_KERNEL);
+	fileio = kzalloc(sizeof(*fileio), GFP_KERNEL);
 	if (fileio == NULL)
 		return -ENOMEM;
 
 	fileio->b = kzalloc(q->buf_struct_size, GFP_KERNEL);
-	if (fileio->b == NULL)
+	if (fileio->b == NULL) {
+		kfree(fileio);
 		return -ENOMEM;
+	}
 
 	fileio->read_once = q->fileio_read_once;
 	fileio->write_immediately = q->fileio_write_immediately;
-- 
2.5.0

