Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729Ab2J0Ulr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:41:47 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 09/68] [media] cx18: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:27 -0200
Message-Id: <1351370486-29040-10-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/cx18/cx18-alsa-main.c:200:5: warning: no previous prototype for 'cx18_alsa_load' [-Wmissing-prototypes]
drivers/media/pci/cx18/cx18-alsa-pcm.c:325:5: warning: no previous prototype for 'snd_cx18_pcm_create' [-Wmissing-prototypes]
drivers/media/pci/cx18/cx18-alsa-pcm.c:72:6: warning: no previous prototype for 'cx18_alsa_announce_pcm_data' [-Wmissing-prototypes]
drivers/media/pci/cx18/cx18-streams.c:100:6: warning: no previous prototype for 'cx18_dma_free' [-Wmissing-prototypes]

Cc: Andy Walls <awalls@md.metrocast.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/cx18/cx18-alsa-main.c | 2 +-
 drivers/media/pci/cx18/cx18-alsa-pcm.c  | 1 +
 drivers/media/pci/cx18/cx18-streams.c   | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-alsa-main.c b/drivers/media/pci/cx18/cx18-alsa-main.c
index 6d2a982..8e971ff 100644
--- a/drivers/media/pci/cx18/cx18-alsa-main.c
+++ b/drivers/media/pci/cx18/cx18-alsa-main.c
@@ -197,7 +197,7 @@ err_exit:
 	return ret;
 }
 
-int cx18_alsa_load(struct cx18 *cx)
+static int __init cx18_alsa_load(struct cx18 *cx)
 {
 	struct v4l2_device *v4l2_dev = &cx->v4l2_dev;
 	struct cx18_stream *s;
diff --git a/drivers/media/pci/cx18/cx18-alsa-pcm.c b/drivers/media/pci/cx18/cx18-alsa-pcm.c
index 7a5b84a..180077c 100644
--- a/drivers/media/pci/cx18/cx18-alsa-pcm.c
+++ b/drivers/media/pci/cx18/cx18-alsa-pcm.c
@@ -37,6 +37,7 @@
 #include "cx18-streams.h"
 #include "cx18-fileops.h"
 #include "cx18-alsa.h"
+#include "cx18-alsa-pcm.h"
 
 static unsigned int pcm_debug;
 module_param(pcm_debug, int, 0644);
diff --git a/drivers/media/pci/cx18/cx18-streams.c b/drivers/media/pci/cx18/cx18-streams.c
index 72af9b5..843c62b 100644
--- a/drivers/media/pci/cx18/cx18-streams.c
+++ b/drivers/media/pci/cx18/cx18-streams.c
@@ -97,7 +97,7 @@ static struct {
 };
 
 
-void cx18_dma_free(struct videobuf_queue *q,
+static void cx18_dma_free(struct videobuf_queue *q,
 	struct cx18_stream *s, struct cx18_videobuf_buffer *buf)
 {
 	videobuf_waiton(q, &buf->vb, 0, 0);
-- 
1.7.11.7

