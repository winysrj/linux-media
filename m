Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4705 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966092Ab3E2OTi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 10:19:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 09/14] bttv: fix querystd
Date: Wed, 29 May 2013 16:19:02 +0200
Message-Id: <1369837147-8747-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
References: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

AND the standard mask with the detected standards.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index a334c94..555d37c 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -1761,9 +1761,9 @@ static int bttv_querystd(struct file *file, void *f, v4l2_std_id *id)
 	struct bttv *btv = fh->btv;
 
 	if (btread(BT848_DSTATUS) & BT848_DSTATUS_NUML)
-		*id = V4L2_STD_625_50;
+		*id &= V4L2_STD_625_50;
 	else
-		*id = V4L2_STD_525_60;
+		*id &= V4L2_STD_525_60;
 	return 0;
 }
 
-- 
1.7.10.4

