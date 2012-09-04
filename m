Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43134 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab2IDOZm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2012 10:25:42 -0400
Received: from localhost.localdomain (earthlight.etchedpixels.co.uk [81.2.110.250])
	by lxorguk.ukuu.org.uk (8.14.5/8.14.1) with ESMTP id q84EwOcF007500
	for <linux-media@vger.kernel.org>; Tue, 4 Sep 2012 15:58:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] tlg2300: fix missing check for audio creation
To: linux-media@vger.kernel.org
Date: Tue, 04 Sep 2012 15:43:26 +0100
Message-ID: <20120904144319.25311.50526.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alan Cox <alan@linux.intel.com>

If we fail to set up the capture device we go through negative indexes and
badness happens. Add the missing test.

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=44551
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/media/usb/tlg2300/pd-alsa.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/tlg2300/pd-alsa.c b/drivers/media/usb/tlg2300/pd-alsa.c
index 9f8b7da..0c77869 100644
--- a/drivers/media/usb/tlg2300/pd-alsa.c
+++ b/drivers/media/usb/tlg2300/pd-alsa.c
@@ -305,6 +305,10 @@ int poseidon_audio_init(struct poseidon *p)
 		return ret;
 
 	ret = snd_pcm_new(card, "poseidon audio", 0, 0, 1, &pcm);
+	if (ret < 0) {
+		snd_free_card(card);
+		return ret;
+	}
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &pcm_capture_ops);
 	pcm->info_flags   = 0;
 	pcm->private_data = p;

