Return-path: <mchehab@pedra>
Received: from gateway09.websitewelcome.com ([67.18.144.14]:60815 "HELO
	gateway09.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752864Ab1DDS0D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Apr 2011 14:26:03 -0400
Message-ID: <4D9A0AFA.7090202@sensoray.com>
Date: Mon, 04 Apr 2011 11:16:26 -0700
From: Sensoray Linux Development <linux-dev@sensoray.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2][media] s2255drv: adding MJPEG format
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

adding MJPEG format

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
---
 drivers/media/video/s2255drv.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index b12e28e..38e5c4b 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -428,6 +428,10 @@ static const struct s2255_fmt formats[] = {
         .fourcc = V4L2_PIX_FMT_JPEG,
         .depth = 24
     }, {
+        .name = "MJPG",
+        .fourcc = V4L2_PIX_FMT_MJPEG,
+        .depth = 24
+    }, {
         .name = "8bpp GREY",
         .fourcc = V4L2_PIX_FMT_GREY,
         .depth = 8
@@ -648,6 +652,7 @@ static void s2255_fillbuff(struct s2255_channel *channel,
             memcpy(vbuf, tmpbuf, buf->vb.width * buf->vb.height);
             break;
         case V4L2_PIX_FMT_JPEG:
+        case V4L2_PIX_FMT_MJPEG:
             buf->vb.size = jpgsize;
             memcpy(vbuf, tmpbuf, buf->vb.size);
             break;
@@ -1032,6 +1037,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
         mode.color |= COLOR_Y8;
         break;
     case V4L2_PIX_FMT_JPEG:
+    case V4L2_PIX_FMT_MJPEG:
         mode.color &= ~MASK_COLOR;
         mode.color |= COLOR_JPG;
         mode.color |= (channel->jc.quality << 8);
-- 
1.7.0.4
