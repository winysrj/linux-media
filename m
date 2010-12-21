Return-path: <mchehab@gaivota>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64858 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864Ab0LUBS3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 20:18:29 -0500
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thiago Farina <tfransosi@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [PATCH] drivers/media/video/v4l2-compat-ioctl32.c: Check the return value of copy_to_user
Date: Mon, 20 Dec 2010 23:18:06 -0200
Message-Id: <d21ad74592c295d59f5806f30a053745b5765397.1292894256.git.tfransosi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This fix the following warning:
drivers/media/video/v4l2-compat-ioctl32.c: In function ‘get_microcode32’:
drivers/media/video/v4l2-compat-ioctl32.c:209: warning: ignoring return value of ‘copy_to_user’, declared with attribute warn_unused_result

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index e30e8df..55825ec 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -206,7 +206,9 @@ static struct video_code __user *get_microcode32(struct video_code32 *kp)
 	 * user address is invalid, the native ioctl will do
 	 * the error handling for us
 	 */
-	(void) copy_to_user(up->loadwhat, kp->loadwhat, sizeof(up->loadwhat));
+	if (copy_to_user(up->loadwhat, kp->loadwhat, sizeof(up->loadwhat)))
+		return NULL;
+
 	(void) put_user(kp->datasize, &up->datasize);
 	(void) put_user(compat_ptr(kp->data), &up->data);
 	return up;
-- 
1.7.3.2.343.g7d43d

