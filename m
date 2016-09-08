Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:48215
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751081AbcIHBCo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Sep 2016 21:02:44 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: kernel-janitors@vger.kernel.org,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] pci: constify snd_pcm_ops structures
Date: Thu,  8 Sep 2016 02:44:39 +0200
Message-Id: <1473295479-24615-1-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/media/pci/cobalt/cobalt-alsa-pcm.c |    4 ++--
 drivers/media/pci/cx18/cx18-alsa-pcm.c     |    2 +-
 drivers/media/pci/cx23885/cx23885-alsa.c   |    2 +-
 drivers/media/pci/cx25821/cx25821-alsa.c   |    2 +-
 drivers/media/pci/cx88/cx88-alsa.c         |    2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c     |    2 +-
 drivers/media/pci/saa7134/saa7134-alsa.c   |    2 +-
 drivers/media/pci/solo6x10/solo6x10-g723.c |    2 +-
 drivers/media/pci/tw686x/tw686x-audio.c    |    2 +-
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
index f198b98..a26f980 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
@@ -318,7 +318,7 @@ static struct page *snd_pcm_get_vmalloc_page(struct snd_pcm_substream *subs,
 	return vmalloc_to_page(pageptr);
 }
 
-static struct snd_pcm_ops snd_ivtv_pcm_capture_ops = {
+static const struct snd_pcm_ops snd_ivtv_pcm_capture_ops = {
 	.open		= snd_ivtv_pcm_capture_open,
 	.close		= snd_ivtv_pcm_capture_close,
 	.ioctl		= snd_ivtv_pcm_ioctl,
diff --git a/drivers/media/pci/solo6x10/solo6x10-g723.c b/drivers/media/pci/solo6x10/solo6x10-g723.c
index 4a37a1c..6a35107 100644
--- a/drivers/media/pci/solo6x10/solo6x10-g723.c
+++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
@@ -252,7 +252,7 @@ static int snd_solo_pcm_copy(struct snd_pcm_substream *ss, int channel,
 	return 0;
 }
 
-static struct snd_pcm_ops snd_solo_pcm_ops = {
+static const struct snd_pcm_ops snd_solo_pcm_ops = {
 	.open = snd_solo_pcm_open,
 	.close = snd_solo_pcm_close,
 	.ioctl = snd_pcm_lib_ioctl,
diff --git a/drivers/media/pci/cx18/cx18-alsa-pcm.c b/drivers/media/pci/cx18/cx18-alsa-pcm.c
index ffb6acd..5344510 100644
--- a/drivers/media/pci/cx18/cx18-alsa-pcm.c
+++ b/drivers/media/pci/cx18/cx18-alsa-pcm.c
@@ -311,7 +311,7 @@ static struct page *snd_pcm_get_vmalloc_page(struct snd_pcm_substream *subs,
 	return vmalloc_to_page(pageptr);
 }
 
-static struct snd_pcm_ops snd_cx18_pcm_capture_ops = {
+static const struct snd_pcm_ops snd_cx18_pcm_capture_ops = {
 	.open		= snd_cx18_pcm_capture_open,
 	.close		= snd_cx18_pcm_capture_close,
 	.ioctl		= snd_cx18_pcm_ioctl,
diff --git a/drivers/media/pci/cobalt/cobalt-alsa-pcm.c b/drivers/media/pci/cobalt/cobalt-alsa-pcm.c
index f0bdf10..49013c6 100644
--- a/drivers/media/pci/cobalt/cobalt-alsa-pcm.c
+++ b/drivers/media/pci/cobalt/cobalt-alsa-pcm.c
@@ -510,7 +510,7 @@ static struct page *snd_pcm_get_vmalloc_page(struct snd_pcm_substream *subs,
 	return vmalloc_to_page(pageptr);
 }
 
-static struct snd_pcm_ops snd_cobalt_pcm_capture_ops = {
+static const struct snd_pcm_ops snd_cobalt_pcm_capture_ops = {
 	.open		= snd_cobalt_pcm_capture_open,
 	.close		= snd_cobalt_pcm_capture_close,
 	.ioctl		= snd_cobalt_pcm_ioctl,
@@ -522,7 +522,7 @@ static struct snd_pcm_ops snd_cobalt_pcm_capture_ops = {
 	.page		= snd_pcm_get_vmalloc_page,
 };
 
-static struct snd_pcm_ops snd_cobalt_pcm_playback_ops = {
+static const struct snd_pcm_ops snd_cobalt_pcm_playback_ops = {
 	.open		= snd_cobalt_pcm_playback_open,
 	.close		= snd_cobalt_pcm_playback_close,
 	.ioctl		= snd_cobalt_pcm_ioctl,
diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index f3f13eb..723f064 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -599,7 +599,7 @@ static struct page *snd_cx88_page(struct snd_pcm_substream *substream,
 /*
  * operators
  */
-static struct snd_pcm_ops snd_cx88_pcm_ops = {
+static const struct snd_pcm_ops snd_cx88_pcm_ops = {
 	.open = snd_cx88_pcm_open,
 	.close = snd_cx88_close,
 	.ioctl = snd_pcm_lib_ioctl,
diff --git a/drivers/media/pci/tw686x/tw686x-audio.c b/drivers/media/pci/tw686x/tw686x-audio.c
index 96e444c..7719076 100644
--- a/drivers/media/pci/tw686x/tw686x-audio.c
+++ b/drivers/media/pci/tw686x/tw686x-audio.c
@@ -269,7 +269,7 @@ static snd_pcm_uframes_t tw686x_pcm_pointer(struct snd_pcm_substream *ss)
 	return bytes_to_frames(ss->runtime, ac->ptr);
 }
 
-static struct snd_pcm_ops tw686x_pcm_ops = {
+static const struct snd_pcm_ops tw686x_pcm_ops = {
 	.open = tw686x_pcm_open,
 	.close = tw686x_pcm_close,
 	.ioctl = snd_pcm_lib_ioctl,
diff --git a/drivers/media/pci/cx23885/cx23885-alsa.c b/drivers/media/pci/cx23885/cx23885-alsa.c
index ae7c2e8..6115d4e 100644
--- a/drivers/media/pci/cx23885/cx23885-alsa.c
+++ b/drivers/media/pci/cx23885/cx23885-alsa.c
@@ -506,7 +506,7 @@ static struct page *snd_cx23885_page(struct snd_pcm_substream *substream,
 /*
  * operators
  */
-static struct snd_pcm_ops snd_cx23885_pcm_ops = {
+static const struct snd_pcm_ops snd_cx23885_pcm_ops = {
 	.open = snd_cx23885_pcm_open,
 	.close = snd_cx23885_close,
 	.ioctl = snd_pcm_lib_ioctl,
diff --git a/drivers/media/pci/cx25821/cx25821-alsa.c b/drivers/media/pci/cx25821/cx25821-alsa.c
index df189b1..4711583 100644
--- a/drivers/media/pci/cx25821/cx25821-alsa.c
+++ b/drivers/media/pci/cx25821/cx25821-alsa.c
@@ -649,7 +649,7 @@ static struct page *snd_cx25821_page(struct snd_pcm_substream *substream,
 /*
  * operators
  */
-static struct snd_pcm_ops snd_cx25821_pcm_ops = {
+static const struct snd_pcm_ops snd_cx25821_pcm_ops = {
 	.open = snd_cx25821_pcm_open,
 	.close = snd_cx25821_close,
 	.ioctl = snd_pcm_lib_ioctl,
diff --git a/drivers/media/pci/saa7134/saa7134-alsa.c b/drivers/media/pci/saa7134/saa7134-alsa.c
index 94f8162..dc0e2fc 100644
--- a/drivers/media/pci/saa7134/saa7134-alsa.c
+++ b/drivers/media/pci/saa7134/saa7134-alsa.c
@@ -877,7 +877,7 @@ static struct page *snd_card_saa7134_page(struct snd_pcm_substream *substream,
  * ALSA capture callbacks definition
  */
 
-static struct snd_pcm_ops snd_card_saa7134_capture_ops = {
+static const struct snd_pcm_ops snd_card_saa7134_capture_ops = {
 	.open =			snd_card_saa7134_capture_open,
 	.close =		snd_card_saa7134_capture_close,
 	.ioctl =		snd_pcm_lib_ioctl,

