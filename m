Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33867 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbcGPJLx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 05:11:53 -0400
Date: Sat, 16 Jul 2016 14:41:49 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Inki Dae <inki.dae@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/2] [media] cx25821: Drop Freeing of Workqueue
Message-ID: <c138d0a859516d8a4176c4ddb32b83119d4ad51c.1468659580.git.bhaktipriya96@gmail.com>
References: <cover.1468659580.git.bhaktipriya96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1468659580.git.bhaktipriya96@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Workqueues shouldn't be freed. destroy_workqueue should be used instead.
destroy_workqueue safely destroys a workqueue and ensures that all pending
work items are done before destroying the workqueue.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/media/pci/cx25821/cx25821-audio-upstream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx25821/cx25821-audio-upstream.c b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
index 68dbc2d..05bd957 100644
--- a/drivers/media/pci/cx25821/cx25821-audio-upstream.c
+++ b/drivers/media/pci/cx25821/cx25821-audio-upstream.c
@@ -242,7 +242,7 @@ void cx25821_stop_upstream_audio(struct cx25821_dev *dev)
 	dev->_audioframe_count = 0;
 	dev->_audiofile_status = END_OF_FILE;

-	kfree(dev->_irq_audio_queues);
+	destroy_workqueue(dev->_irq_audio_queues);
 	dev->_irq_audio_queues = NULL;

 	kfree(dev->_audiofilename);
--
2.1.4

