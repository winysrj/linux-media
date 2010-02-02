Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757094Ab0BBWlB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 17:41:01 -0500
Message-Id: <201002022240.o12MeoSv018915@imap1.linux-foundation.org>
Subject: [patch 5/7] drivers/media/video/cx18/cx18-alsa-pcm.c: fix printk warning
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	awalls@radix.net
From: akpm@linux-foundation.org
Date: Tue, 02 Feb 2010 14:40:49 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>

drivers/media/video/cx18/cx18-alsa-pcm.c: In function 'cx18_alsa_announce_pcm_data':
drivers/media/video/cx18/cx18-alsa-pcm.c:82: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'

Cc: Andy Walls <awalls@radix.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx18/cx18-alsa-pcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/cx18/cx18-alsa-pcm.c~drivers-media-video-cx18-cx18-alsa-pcmc-fix-printk-warning drivers/media/video/cx18/cx18-alsa-pcm.c
--- a/drivers/media/video/cx18/cx18-alsa-pcm.c~drivers-media-video-cx18-cx18-alsa-pcmc-fix-printk-warning
+++ a/drivers/media/video/cx18/cx18-alsa-pcm.c
@@ -79,7 +79,7 @@ void cx18_alsa_announce_pcm_data(struct 
 	int period_elapsed = 0;
 	int length;
 
-	dprintk("cx18 alsa announce ptr=%p data=%p num_bytes=%d\n", cxsc,
+	dprintk("cx18 alsa announce ptr=%p data=%p num_bytes=%zd\n", cxsc,
 		pcm_data, num_bytes);
 
 	substream = cxsc->capture_pcm_substream;
_
