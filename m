Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DDA2C43387
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 01:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 289EF218E0
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 01:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545355193;
	bh=tytiSmQOqHm4N1cq03I32DUKolSOX1kji1iS3bg0fGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Admnz9hl1tXX9ktV56MN+CsZNJnSWqfZIqH6bP983qgNETBIWHEJVNXxRnMOESjNG
	 k1URlh7b3eaAOkaBq76bPaqg9xXGA/hasuejJuzPHfpRe598DkAR1tF5SIqH69jw6E
	 My1Ayyv3jrpSKxfGUky2IIjcgGMEMWZmn0mHbmX4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388673AbeLUBSW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 20:18:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:37276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388648AbeLUBSU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 20:18:20 -0500
Received: from mail.kernel.org (unknown [185.216.33.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5D4021907;
        Fri, 21 Dec 2018 01:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545355099;
        bh=tytiSmQOqHm4N1cq03I32DUKolSOX1kji1iS3bg0fGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GulHGxSNtHauBAnDTqzV4KuOSpSbDvfvqrLTaVbpajc+bYvuH0r43XHoqeCTk3UoV
         qbL+n7F2B9fSkeEsMioY7+jY35xYGwrkOSNaK1UgfACk+gkYrGfNKuTUctP/ij/qvO
         mnGUwvCm/GlxPdsxlE1904frit1Z9dRnbnCLdWKQ=
From:   Sebastian Reichel <sre@kernel.org>
To:     Sebastian Reichel <sre@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Tony Lindgren <tony@atomide.com>
Cc:     Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>, linux-bluetooth@vger.kernel.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 05/14] media: wl128x-radio: remove global radio_disconnected
Date:   Fri, 21 Dec 2018 02:17:43 +0100
Message-Id: <20181221011752.25627-6-sre@kernel.org>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181221011752.25627-1-sre@kernel.org>
References: <20181221011752.25627-1-sre@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Sebastian Reichel <sebastian.reichel@collabora.com>

Move global radio_disconnected into device structure to
prepare converting this driver into a normal platform
device driver supporting multiple instances.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
---
 drivers/media/radio/wl128x/fmdrv.h      |  1 +
 drivers/media/radio/wl128x/fmdrv_v4l2.c | 15 +++++++--------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv.h b/drivers/media/radio/wl128x/fmdrv.h
index 8ed7c0aeb8b9..fa89eef59295 100644
--- a/drivers/media/radio/wl128x/fmdrv.h
+++ b/drivers/media/radio/wl128x/fmdrv.h
@@ -201,6 +201,7 @@ struct fmdev {
 	struct v4l2_device v4l2_dev;	/* V4L2 top level struct */
 	struct snd_card *card;	/* Card which holds FM mixer controls */
 	u16 asci_id;
+	u8 radio_disconnected;
 	spinlock_t rds_buff_lock; /* To protect access to RDS buffer */
 	spinlock_t resp_skb_lock; /* To protect access to received SKB */
 
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index e25fd4d4d280..f541b5802844 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -33,7 +33,6 @@
 #include "fmdrv_tx.h"
 
 static struct video_device gradio_dev;
-static u8 radio_disconnected;
 
 /* -- V4L2 RADIO (/dev/radioX) device file operation interfaces --- */
 
@@ -47,7 +46,7 @@ static ssize_t fm_v4l2_fops_read(struct file *file, char __user * buf,
 
 	fmdev = video_drvdata(file);
 
-	if (!radio_disconnected) {
+	if (!fmdev->radio_disconnected) {
 		fmerr("FM device is already disconnected\n");
 		return -EIO;
 	}
@@ -126,14 +125,14 @@ static int fm_v4l2_fops_open(struct file *file)
 	int ret;
 	struct fmdev *fmdev = NULL;
 
+	fmdev = video_drvdata(file);
+
 	/* Don't allow multiple open */
-	if (radio_disconnected) {
+	if (fmdev->radio_disconnected) {
 		fmerr("FM device is already opened\n");
 		return -EBUSY;
 	}
 
-	fmdev = video_drvdata(file);
-
 	if (mutex_lock_interruptible(&fmdev->mutex))
 		return -ERESTARTSYS;
 	ret = fmc_prepare(fmdev);
@@ -149,7 +148,7 @@ static int fm_v4l2_fops_open(struct file *file)
 		fmerr("Unable to load FM RX firmware\n");
 		goto open_unlock;
 	}
-	radio_disconnected = 1;
+	fmdev->radio_disconnected = 1;
 
 open_unlock:
 	mutex_unlock(&fmdev->mutex);
@@ -162,7 +161,7 @@ static int fm_v4l2_fops_release(struct file *file)
 	struct fmdev *fmdev;
 
 	fmdev = video_drvdata(file);
-	if (!radio_disconnected) {
+	if (!fmdev->radio_disconnected) {
 		fmdbg("FM device is already closed\n");
 		return 0;
 	}
@@ -179,7 +178,7 @@ static int fm_v4l2_fops_release(struct file *file)
 		fmerr("FM CORE release failed\n");
 		goto release_unlock;
 	}
-	radio_disconnected = 0;
+	fmdev->radio_disconnected = 0;
 
 release_unlock:
 	mutex_unlock(&fmdev->mutex);
-- 
2.19.2

