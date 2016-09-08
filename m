Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:61327 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751647AbcIHBRL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Sep 2016 21:17:11 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] usb: constify snd_pcm_ops structures
Date: Thu,  8 Sep 2016 02:59:06 +0200
Message-Id: <1473296346-26327-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check for snd_pcm_ops structures that are only stored in the ops field of a
snd_soc_platform_driver structure or passed as the third argument to
snd_pcm_set_ops.  The corresponding field or parameter is declared const,
so snd_pcm_ops structures that have this property can be declared as const
also.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable optional_qualifier@
identifier i;
position p;
@@
static struct snd_pcm_ops i@p = { ... };

@ok1@
identifier r.i;
struct snd_soc_platform_driver e;
position p;
@@
e.ops = &i@p;

@ok2@
identifier r.i;
expression e1, e2;
position p;
@@
snd_pcm_set_ops(e1, e2, &i@p)

@bad@
position p != {r.p,ok1.p,ok2.p};
identifier r.i;
struct snd_pcm_ops e;
@@
e@i@p

@depends on !bad disable optional_qualifier@
identifier r.i;
@@
static
+const
 struct snd_pcm_ops i = { ... };
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/usb/cx231xx/cx231xx-audio.c |    2 +-
 drivers/media/usb/em28xx/em28xx-audio.c   |    2 +-
 drivers/media/usb/go7007/snd-go7007.c     |    2 +-
 drivers/media/usb/tm6000/tm6000-alsa.c    |    2 +-
 drivers/media/usb/usbtv/usbtv-audio.c     |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 78f3687..e11fe46 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -695,7 +695,7 @@ static int em28xx_cvol_new(struct snd_card *card, struct em28xx *dev,
 /*
  * register/unregister code and data
  */
-static struct snd_pcm_ops snd_em28xx_pcm_capture = {
+static const struct snd_pcm_ops snd_em28xx_pcm_capture = {
 	.open      = snd_em28xx_capture_open,
 	.close     = snd_em28xx_pcm_close,
 	.ioctl     = snd_pcm_lib_ioctl,
diff --git a/drivers/media/usb/go7007/snd-go7007.c b/drivers/media/usb/go7007/snd-go7007.c
index d22d7d5..070871f 100644
--- a/drivers/media/usb/go7007/snd-go7007.c
+++ b/drivers/media/usb/go7007/snd-go7007.c
@@ -198,7 +198,7 @@ static struct page *go7007_snd_pcm_page(struct snd_pcm_substream *substream,
 	return vmalloc_to_page(substream->runtime->dma_area + offset);
 }
 
-static struct snd_pcm_ops go7007_snd_capture_ops = {
+static const struct snd_pcm_ops go7007_snd_capture_ops = {
 	.open		= go7007_snd_capture_open,
 	.close		= go7007_snd_capture_close,
 	.ioctl		= snd_pcm_lib_ioctl,
diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
index 4cd5fa9..8263c4b 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -635,7 +635,7 @@ static struct page *snd_pcm_get_vmalloc_page(struct snd_pcm_substream *subs,
 	return vmalloc_to_page(pageptr);
 }
 
-static struct snd_pcm_ops snd_cx231xx_pcm_capture = {
+static const struct snd_pcm_ops snd_cx231xx_pcm_capture = {
 	.open = snd_cx231xx_capture_open,
 	.close = snd_cx231xx_pcm_close,
 	.ioctl = snd_pcm_lib_ioctl,
diff --git a/drivers/media/usb/usbtv/usbtv-audio.c b/drivers/media/usb/usbtv/usbtv-audio.c
index 1965ff1..9db31db 100644
--- a/drivers/media/usb/usbtv/usbtv-audio.c
+++ b/drivers/media/usb/usbtv/usbtv-audio.c
@@ -332,7 +332,7 @@ static snd_pcm_uframes_t snd_usbtv_pointer(struct snd_pcm_substream *substream)
 	return chip->snd_buffer_pos;
 }
 
-static struct snd_pcm_ops snd_usbtv_pcm_ops = {
+static const struct snd_pcm_ops snd_usbtv_pcm_ops = {
 	.open = snd_usbtv_pcm_open,
 	.close = snd_usbtv_pcm_close,
 	.ioctl = snd_pcm_lib_ioctl,
diff --git a/drivers/media/usb/tm6000/tm6000-alsa.c b/drivers/media/usb/tm6000/tm6000-alsa.c
index e21c7aa..f16fbd1 100644
--- a/drivers/media/usb/tm6000/tm6000-alsa.c
+++ b/drivers/media/usb/tm6000/tm6000-alsa.c
@@ -388,7 +388,7 @@ static struct page *snd_pcm_get_vmalloc_page(struct snd_pcm_substream *subs,
 /*
  * operators
  */
-static struct snd_pcm_ops snd_tm6000_pcm_ops = {
+static const struct snd_pcm_ops snd_tm6000_pcm_ops = {
 	.open = snd_tm6000_pcm_open,
 	.close = snd_tm6000_close,
 	.ioctl = snd_pcm_lib_ioctl,

