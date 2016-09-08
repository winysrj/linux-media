Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:60212 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751220AbcIIARX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Sep 2016 20:17:23 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: kernel-janitors@vger.kernel.org, Abylay Ospan <aospan@netup.ru>,
        Sergey Kozlov <serjk@netup.ru>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] [media] pci: constify vb2_ops structures
Date: Fri,  9 Sep 2016 01:59:18 +0200
Message-Id: <1473379158-17344-1-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/media/pci/cx23885/cx23885-417.c            |    2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |    2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |    2 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |    2 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |    2 +-
 drivers/media/pci/cx88/cx88-video.c                |    2 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |    2 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |    2 +-
 drivers/media/pci/saa7134/saa7134-video.c          |    2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c     |    2 +-
 drivers/media/pci/tw68/tw68-video.c                |    2 +-
 drivers/media/pci/tw686x/tw686x-video.c            |    2 +-
 13 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 3991643..25a2137 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -759,7 +759,7 @@ static void solo_enc_buf_finish(struct vb2_buffer *vb)
 	}
 }
 
-static struct vb2_ops solo_enc_video_qops = {
+static const struct vb2_ops solo_enc_video_qops = {
 	.queue_setup	= solo_enc_queue_setup,
 	.buf_queue	= solo_enc_buf_queue,
 	.buf_finish	= solo_enc_buf_finish,
diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index ac547cb..b078ac2 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -353,7 +353,7 @@ static void netup_unidvb_stop_streaming(struct vb2_queue *q)
 	netup_unidvb_queue_cleanup(dma);
 }
 
-static struct vb2_ops dvb_qops = {
+static const struct vb2_ops dvb_qops = {
 	.queue_setup		= netup_unidvb_queue_setup,
 	.buf_prepare		= netup_unidvb_buf_prepare,
 	.buf_queue		= netup_unidvb_buf_queue,
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 04fe9af..b532e49 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -756,7 +756,7 @@ static void stop_streaming(struct vb2_queue *q)
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-static struct vb2_ops blackbird_qops = {
+static const struct vb2_ops blackbird_qops = {
 	.queue_setup    = queue_setup,
 	.buf_prepare  = buffer_prepare,
 	.buf_finish = buffer_finish,
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index 5bb63e7..ac2392d 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -156,7 +156,7 @@ static void stop_streaming(struct vb2_queue *q)
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-static struct vb2_ops dvb_qops = {
+static const struct vb2_ops dvb_qops = {
 	.queue_setup    = queue_setup,
 	.buf_prepare  = buffer_prepare,
 	.buf_finish = buffer_finish,
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 5dc1e3f..d83eb3b 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -567,7 +567,7 @@ static void stop_streaming(struct vb2_queue *q)
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-static struct vb2_ops cx8800_video_qops = {
+static const struct vb2_ops cx8800_video_qops = {
 	.queue_setup    = queue_setup,
 	.buf_prepare  = buffer_prepare,
 	.buf_finish = buffer_finish,
diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index cdb16de..7339b9a 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -577,7 +577,7 @@ static int tw686x_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static struct vb2_ops tw686x_video_qops = {
+static const struct vb2_ops tw686x_video_qops = {
 	.queue_setup		= tw686x_queue_setup,
 	.buf_queue		= tw686x_buf_queue,
 	.buf_prepare		= tw686x_buf_prepare,
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 5e82128..a45e023 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -535,7 +535,7 @@ static void tw68_stop_streaming(struct vb2_queue *q)
 	}
 }
 
-static struct vb2_ops tw68_video_qops = {
+static const struct vb2_ops tw68_video_qops = {
 	.queue_setup	= tw68_queue_setup,
 	.buf_queue	= tw68_buf_queue,
 	.buf_prepare	= tw68_buf_prepare,
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index efec2d1..c95db4d 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1223,7 +1223,7 @@ static void cx23885_stop_streaming(struct vb2_queue *q)
 	cx23885_cancel_buffers(&dev->ts1);
 }
 
-static struct vb2_ops cx23885_qops = {
+static const struct vb2_ops cx23885_qops = {
 	.queue_setup    = queue_setup,
 	.buf_prepare  = buffer_prepare,
 	.buf_finish = buffer_finish,
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index e5748a9..2c5ec56 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -172,7 +172,7 @@ static void cx23885_stop_streaming(struct vb2_queue *q)
 	cx23885_cancel_buffers(port);
 }
 
-static struct vb2_ops dvb_qops = {
+static const struct vb2_ops dvb_qops = {
 	.queue_setup    = queue_setup,
 	.buf_prepare  = buffer_prepare,
 	.buf_finish = buffer_finish,
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 6d73522..33d168e 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -517,7 +517,7 @@ static void cx23885_stop_streaming(struct vb2_queue *q)
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-static struct vb2_ops cx23885_video_qops = {
+static const struct vb2_ops cx23885_video_qops = {
 	.queue_setup    = queue_setup,
 	.buf_prepare  = buffer_prepare,
 	.buf_finish = buffer_finish,
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index adcd09b..7ce352a 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -307,7 +307,7 @@ static void cx25821_stop_streaming(struct vb2_queue *q)
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-static struct vb2_ops cx25821_video_qops = {
+static const struct vb2_ops cx25821_video_qops = {
 	.queue_setup    = cx25821_queue_setup,
 	.buf_prepare  = cx25821_buffer_prepare,
 	.buf_finish = cx25821_buffer_finish,
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index ca417a4..b56b5f7 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -85,7 +85,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	dev->empress_started = 0;
 }
 
-static struct vb2_ops saa7134_empress_qops = {
+static const struct vb2_ops saa7134_empress_qops = {
 	.queue_setup	= saa7134_ts_queue_setup,
 	.buf_init	= saa7134_ts_buffer_init,
 	.buf_prepare	= saa7134_ts_buffer_prepare,
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 8a6ebd0..12f3fde 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1054,7 +1054,7 @@ void saa7134_vb2_stop_streaming(struct vb2_queue *vq)
 		pm_qos_remove_request(&dev->qos_request);
 }
 
-static struct vb2_ops vb2_qops = {
+static const struct vb2_ops vb2_qops = {
 	.queue_setup	= queue_setup,
 	.buf_init	= buffer_init,
 	.buf_prepare	= buffer_prepare,

