Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.131]:63765 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006AbaDNNth (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 09:49:37 -0400
Date: Mon, 14 Apr 2014 15:49:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Jonathan Corbet <corbet@lwn.net>, Daniel Drake <dsd@laptop.org>
Subject: [PATCH] V4L2: ov7670: fix a wrong index, potentially Oopsing the
 kernel from user-space
Message-ID: <Pine.LNX.4.64.1404141545280.23631@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 75e2bdad8901a0b599e01a96229be922eef1e488 "ov7670: allow
configuration of image size, clock speed, and I/O method" uses a wrong
index to iterate an array. Apart from being wrong, it also uses an
unchecked value from user-space, which can cause access to unmapped
memory in the kernel, triggered by a normal desktop user with rights to
use V4L2 devices.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Jonathan,
I'd prefer to first post it to the lists to maybe have someone test it ;) 
Otherwise - I've got a couple more fixes for 3.15, which I hope to make 
ready and push in a couple of weeks... So, with your ack I can take this 
one too, or, if you prefer to push it earlier - would be good too.

 drivers/media/i2c/ov7670.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index e8a1ce2..cdd7c1b 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1109,7 +1109,7 @@ static int ov7670_enum_framesizes(struct v4l2_subdev *sd,
 	 * windows that fall outside that.
 	 */
 	for (i = 0; i < n_win_sizes; i++) {
-		struct ov7670_win_size *win = &info->devtype->win_sizes[index];
+		struct ov7670_win_size *win = &info->devtype->win_sizes[i];
 		if (info->min_width && win->width < info->min_width)
 			continue;
 		if (info->min_height && win->height < info->min_height)
-- 
1.9.1

