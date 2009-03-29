Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51628 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbZC2LMf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 07:12:35 -0400
Date: Sun, 29 Mar 2009 12:12:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] Fix buglets in v4l1 compatibility layer
Message-ID: <20090329111227.GA29140@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Russell King <rmk@arm.linux.org.uk>

The following patch fixes a few bugs I've noticed in the V4L1
compatibility layer:
- VIDEO_MODE_AUTO for get/set input ioctls was not being handled
- wrong V4L2 ioctl being used in v4l1_compat_select_tuner

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---

 drivers/media/video/v4l1-compat.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l1-compat.c b/drivers/media/video/v4l1-compat.c
index b617bf0..02f2a6d 100644
--- a/drivers/media/video/v4l1-compat.c
+++ b/drivers/media/video/v4l1-compat.c
@@ -575,6 +575,8 @@ static noinline long v4l1_compat_get_input_info(
 			chan->norm = VIDEO_MODE_NTSC;
 		if (sid & V4L2_STD_SECAM)
 			chan->norm = VIDEO_MODE_SECAM;
+		if (sid == V4L2_STD_ALL)
+			chan->norm = VIDEO_MODE_AUTO;
 	}
 done:
 	return err;
@@ -601,6 +603,9 @@ static noinline long v4l1_compat_set_input(
 	case VIDEO_MODE_SECAM:
 		sid = V4L2_STD_SECAM;
 		break;
+	case VIDEO_MODE_AUTO:
+		sid = V4L2_STD_ALL;
+		break;
 	}
 	if (0 != sid) {
 		err = drv(file, VIDIOC_S_STD, &sid);
@@ -804,9 +809,9 @@ static noinline long v4l1_compat_select_tuner(
 
 	t.index = tun->tuner;
 
-	err = drv(file, VIDIOC_S_INPUT, &t);
+	err = drv(file, VIDIOC_S_TUNER, &t);
 	if (err < 0)
-		dprintk("VIDIOCSTUNER / VIDIOC_S_INPUT: %ld\n", err);
+		dprintk("VIDIOCSTUNER / VIDIOC_S_TUNER: %ld\n", err);
 	return err;
 }
 
