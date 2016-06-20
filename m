Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34858 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbcFTNG7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 09:06:59 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	hans.verkuil@cisco.com, hverkuil@xs4all.nl
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v3 4/4] vb2: Fix comment
Date: Mon, 20 Jun 2016 14:47:25 +0200
Message-Id: <1466426845-25673-4-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1466426845-25673-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1466426845-25673-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The comment was referencing the wrong function.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 633fc1ab1d7a..ba6ab8b7311f 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1845,7 +1845,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	 * Make sure to call buf_finish for any queued buffers. Normally
 	 * that's done in dqbuf, but that's not going to happen when we
 	 * cancel the whole queue. Note: this code belongs here, not in
-	 * __vb2_dqbuf() since in vb2_internal_dqbuf() there is a critical
+	 * __vb2_dqbuf() since in vb2_core_dqbuf() there is a critical
 	 * call to __fill_user_buffer() after buf_finish(). That order can't
 	 * be changed, so we can't move the buf_finish() to __vb2_dqbuf().
 	 */
-- 
2.8.1

