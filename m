Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:64295 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750754AbcIIARG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Sep 2016 20:17:06 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: kernel-janitors@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] [media] usb: constify vb2_ops structures
Date: Fri,  9 Sep 2016 01:59:01 +0200
Message-Id: <1473379141-17286-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check for vb2_ops structures that are only stored in the ops field of a
vb2_queue structure.  That field is declared const, so vb2_ops structures
that have this property can be declared as const also.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable optional_qualifier@
identifier i;
position p;
@@
static struct vb2_ops i@p = { ... };

@ok@
identifier r.i;
struct vb2_queue e;
position p;
@@
e.ops = &i@p;

@bad@
position p != {r.p,ok.p};
identifier r.i;
struct vb2_ops e;
@@
e@i@p

@depends on !bad disable optional_qualifier@
identifier r.i;
@@
static
+const
 struct vb2_ops i = { ... };
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/usb/airspy/airspy.c       |    2 +-
 drivers/media/usb/au0828/au0828-video.c |    2 +-
 drivers/media/usb/em28xx/em28xx-video.c |    2 +-
 drivers/media/usb/go7007/go7007-v4l2.c  |    2 +-
 drivers/media/usb/hackrf/hackrf.c       |    2 +-
 drivers/media/usb/msi2500/msi2500.c     |    2 +-
 drivers/media/usb/pwc/pwc-if.c          |    2 +-
 drivers/media/usb/s2255/s2255drv.c      |    2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c |    2 +-
 drivers/media/usb/usbtv/usbtv-video.c   |    2 +-
 drivers/media/usb/uvc/uvc_queue.c       |    2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index c2c8d12..75e0363 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -891,7 +891,7 @@ static void hackrf_stop_streaming(struct vb2_queue *vq)
 	mutex_unlock(&dev->v4l2_lock);
 }
 
-static struct vb2_ops hackrf_vb2_ops = {
+static const struct vb2_ops hackrf_vb2_ops = {
 	.queue_setup            = hackrf_queue_setup,
 	.buf_queue              = hackrf_buf_queue,
 	.start_streaming        = hackrf_start_streaming,
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 7968695..1f7fa05 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1204,7 +1204,7 @@ buffer_queue(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-static struct vb2_ops em28xx_video_qops = {
+static const struct vb2_ops em28xx_video_qops = {
 	.queue_setup    = queue_setup,
 	.buf_prepare    = buffer_prepare,
 	.buf_queue      = buffer_queue,
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index c4454c9..ff65764 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -707,7 +707,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	mutex_unlock(&pdev->v4l2_lock);
 }
 
-static struct vb2_ops pwc_vb_queue_ops = {
+static const struct vb2_ops pwc_vb_queue_ops = {
 	.queue_setup		= queue_setup,
 	.buf_init		= buffer_init,
 	.buf_prepare		= buffer_prepare,
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index af84589..4eaba0c 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -477,7 +477,7 @@ static void go7007_stop_streaming(struct vb2_queue *q)
 		go7007_write_addr(go, 0x3c82, 0x000d);
 }
 
-static struct vb2_ops go7007_video_qops = {
+static const struct vb2_ops go7007_video_qops = {
 	.queue_setup    = go7007_queue_setup,
 	.buf_queue      = go7007_buf_queue,
 	.buf_prepare    = go7007_buf_prepare,
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 3c556ee..8251942 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -605,7 +605,7 @@ static void airspy_stop_streaming(struct vb2_queue *vq)
 	mutex_unlock(&s->v4l2_lock);
 }
 
-static struct vb2_ops airspy_vb2_ops = {
+static const struct vb2_ops airspy_vb2_ops = {
 	.queue_setup            = airspy_queue_setup,
 	.buf_queue              = airspy_buf_queue,
 	.start_streaming        = airspy_start_streaming,
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 13b8387..85dd9a8 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -928,7 +928,7 @@ void au0828_stop_vbi_streaming(struct vb2_queue *vq)
 	del_timer_sync(&dev->vbi_timeout);
 }
 
-static struct vb2_ops au0828_video_qops = {
+static const struct vb2_ops au0828_video_qops = {
 	.queue_setup     = queue_setup,
 	.buf_prepare     = buffer_prepare,
 	.buf_queue       = buffer_queue,
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 9458eb0..c3a0e87 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -717,7 +717,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 static int start_streaming(struct vb2_queue *vq, unsigned int count);
 static void stop_streaming(struct vb2_queue *vq);
 
-static struct vb2_ops s2255_video_qops = {
+static const struct vb2_ops s2255_video_qops = {
 	.queue_setup = queue_setup,
 	.buf_prepare = buffer_prepare,
 	.buf_queue = buffer_queue,
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 2a08975..6cbe4a2 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -689,7 +689,7 @@ static void usbtv_stop_streaming(struct vb2_queue *vq)
 		usbtv_stop(usbtv);
 }
 
-static struct vb2_ops usbtv_vb2_ops = {
+static const struct vb2_ops usbtv_vb2_ops = {
 	.queue_setup = usbtv_queue_setup,
 	.buf_queue = usbtv_buf_queue,
 	.start_streaming = usbtv_start_streaming,
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 5fab3be..a005d26 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -742,7 +742,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	stk1160_stop_streaming(dev);
 }
 
-static struct vb2_ops stk1160_video_qops = {
+static const struct vb2_ops stk1160_video_qops = {
 	.queue_setup		= queue_setup,
 	.buf_queue		= buffer_queue,
 	.start_streaming	= start_streaming,
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 773fefb..77edd20 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -177,7 +177,7 @@ static void uvc_stop_streaming(struct vb2_queue *vq)
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 }
 
-static struct vb2_ops uvc_queue_qops = {
+static const struct vb2_ops uvc_queue_qops = {
 	.queue_setup = uvc_queue_setup,
 	.buf_prepare = uvc_buffer_prepare,
 	.buf_queue = uvc_buffer_queue,
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 367eb7e..bb3d31e 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -897,7 +897,7 @@ static void msi2500_stop_streaming(struct vb2_queue *vq)
 	mutex_unlock(&dev->v4l2_lock);
 }
 
-static struct vb2_ops msi2500_vb2_ops = {
+static const struct vb2_ops msi2500_vb2_ops = {
 	.queue_setup            = msi2500_queue_setup,
 	.buf_queue              = msi2500_buf_queue,
 	.start_streaming        = msi2500_start_streaming,

