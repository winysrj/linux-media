Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4069 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3DNP1v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 02/30] cx25821: the audio channel was registered as a video node.
Date: Sun, 14 Apr 2013 17:26:58 +0200
Message-Id: <1365953246-8972-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Skip the audio channel when registering the video nodes. This fixes a bug
where that incorrectly registered 'video' node was never unregistered.

Note: this bug only surfaces if the video output nodes are enabled again
after the previous patch disabled them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-core.c  |    8 +++-----
 drivers/media/pci/cx25821/cx25821-video.c |    5 ++++-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 1884e2c..1f47422 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -1051,11 +1051,9 @@ void cx25821_dev_unregister(struct cx25821_dev *dev)
 	if (!atomic_dec_and_test(&dev->refcount))
 		return;
 
-	for (i = 0; i < VID_CHANNEL_NUM; i++)
-		cx25821_video_unregister(dev, i);
-
-	for (i = VID_UPSTREAM_SRAM_CHANNEL_I;
-	     i <= AUDIO_UPSTREAM_SRAM_CHANNEL_B; i++) {
+	for (i = 0; i < MAX_VID_CHANNEL_NUM - 1; i++) {
+		if (i == SRAM_CH08) /* audio channel */
+			continue;
 		cx25821_video_unregister(dev, i);
 	}
 
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 6b18320..8bf9c89 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -462,6 +462,9 @@ int cx25821_video_register(struct cx25821_dev *dev)
 	spin_lock_init(&dev->slock);
 
 	for (i = 0; i < VID_CHANNEL_NUM; ++i) {
+		if (i == SRAM_CH08) /* audio channel */
+			continue;
+
 		cx25821_init_controls(dev, i);
 
 		cx25821_risc_stopper(dev->pci, &dev->channels[i].vidq.stopper,
@@ -788,7 +791,7 @@ static int video_open(struct file *file)
 	{
 		h = list_entry(list, struct cx25821_dev, devlist);
 
-		for (i = 0; i < MAX_VID_CHANNEL_NUM; i++) {
+		for (i = 0; i < MAX_VID_CHANNEL_NUM - 1; i++) {
 			if (h->channels[i].video_dev &&
 			    h->channels[i].video_dev->minor == minor) {
 				dev = h;
-- 
1.7.10.4

