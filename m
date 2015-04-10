Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:49818 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbbDJUYZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 16:24:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Jurgen Kramer <gtmkramer@xs4all.nl>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] [media] vb2: remove unused variable
Date: Fri, 10 Apr 2015 22:24:17 +0200
Message-ID: <8477099.Iv3RkyDk0C@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A recent bug fix removed all uses of the 'fileio' variable in
vb2_thread_stop(), which now causes warnings in a lot of
ARM defconfig builds:

drivers/media/v4l2-core/videobuf2-core.c:3228:26: warning: unused variable 'fileio' [-Wunused-variable]

This removes the variable as well. The commit that introduced
the warning was marked for 3.18+ backports, so this should
probably be backported too.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 0e661006370b7 ("[media] vb2: fix 'UNBALANCED' warnings when calling vb2_thread_stop()")
Cc: <stable@vger.kernel.org>      # for v3.18 and up

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index c11aee7db884..d3f7bf0db61e 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -3225,7 +3225,6 @@ EXPORT_SYMBOL_GPL(vb2_thread_start);
 int vb2_thread_stop(struct vb2_queue *q)
 {
 	struct vb2_threadio_data *threadio = q->threadio;
-	struct vb2_fileio_data *fileio = q->fileio;
 	int err;
 
 	if (threadio == NULL)

