Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:44849 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932291AbeENNNw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 09:13:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/7] s5p-mfc: fix two sparse warnings
Date: Mon, 14 May 2018 15:13:42 +0200
Message-Id: <20180514131346.15795-4-hverkuil@xs4all.nl>
In-Reply-To: <20180514131346.15795-1-hverkuil@xs4all.nl>
References: <20180514131346.15795-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

media-git/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c: In function 'vidioc_querycap':
media-git/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1317:2: warning: 'strncpy' output may be truncated copying 31 bytes from a string of length 31 [-Wstringop-truncation]
  strncpy(cap->card, dev->vfd_enc->name, sizeof(cap->card) - 1);
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
media-git/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c: In function 'vidioc_querycap':
media-git/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:275:2: warning: 'strncpy' output may be truncated copying 31 bytes from a string of length 31 [-Wstringop-truncation]
  strncpy(cap->card, dev->vfd_dec->name, sizeof(cap->card) - 1);
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 4 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 5cf4d9921264..6a3cc4f86c5d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -271,8 +271,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	struct s5p_mfc_dev *dev = video_drvdata(file);
 
-	strncpy(cap->driver, S5P_MFC_NAME, sizeof(cap->driver) - 1);
-	strncpy(cap->card, dev->vfd_dec->name, sizeof(cap->card) - 1);
+	strlcpy(cap->driver, S5P_MFC_NAME, sizeof(cap->driver));
+	strlcpy(cap->card, dev->vfd_dec->name, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(&dev->plat_dev->dev));
 	/*
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 5c0462ca9993..570f391f2cfd 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1313,8 +1313,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	struct s5p_mfc_dev *dev = video_drvdata(file);
 
-	strncpy(cap->driver, S5P_MFC_NAME, sizeof(cap->driver) - 1);
-	strncpy(cap->card, dev->vfd_enc->name, sizeof(cap->card) - 1);
+	strlcpy(cap->driver, S5P_MFC_NAME, sizeof(cap->driver));
+	strlcpy(cap->card, dev->vfd_enc->name, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(&dev->plat_dev->dev));
 	/*
-- 
2.17.0
