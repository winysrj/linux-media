Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:40585 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653AbbH1Ltd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 07:49:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, ricardo.ribalda@gmail.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/8] saa7164: add v4l2_fh support
Date: Fri, 28 Aug 2015 13:48:27 +0200
Message-Id: <1440762513-30457-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1440762513-30457-1-git-send-email-hverkuil@xs4all.nl>
References: <1440762513-30457-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Control events require the use of struct v4l2_fh. Add this to saa7164.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7164/saa7164-encoder.c | 7 +++++--
 drivers/media/pci/saa7164/saa7164-vbi.c     | 7 +++++--
 drivers/media/pci/saa7164/saa7164.h         | 2 ++
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 390211b..96dd1e4 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -746,8 +746,10 @@ static int fops_open(struct file *file)
 	if (NULL == fh)
 		return -ENOMEM;
 
-	file->private_data = fh;
 	fh->port = port;
+	v4l2_fh_init(&fh->fh, video_devdata(file));
+	v4l2_fh_add(&fh->fh);
+	file->private_data = fh;
 
 	return 0;
 }
@@ -768,7 +770,8 @@ static int fops_release(struct file *file)
 		}
 	}
 
-	file->private_data = NULL;
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	kfree(fh);
 
 	return 0;
diff --git a/drivers/media/pci/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
index 4858f59..2f9c87d 100644
--- a/drivers/media/pci/saa7164/saa7164-vbi.c
+++ b/drivers/media/pci/saa7164/saa7164-vbi.c
@@ -678,8 +678,10 @@ static int fops_open(struct file *file)
 	if (NULL == fh)
 		return -ENOMEM;
 
-	file->private_data = fh;
 	fh->port = port;
+	v4l2_fh_init(&fh->fh, video_devdata(file));
+	v4l2_fh_add(&fh->fh);
+	file->private_data = fh;
 
 	return 0;
 }
@@ -700,7 +702,8 @@ static int fops_release(struct file *file)
 		}
 	}
 
-	file->private_data = NULL;
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	kfree(fh);
 
 	return 0;
diff --git a/drivers/media/pci/saa7164/saa7164.h b/drivers/media/pci/saa7164/saa7164.h
index b3828c6..05707e3 100644
--- a/drivers/media/pci/saa7164/saa7164.h
+++ b/drivers/media/pci/saa7164/saa7164.h
@@ -186,11 +186,13 @@ struct saa7164_subid {
 };
 
 struct saa7164_encoder_fh {
+	struct v4l2_fh fh;
 	struct saa7164_port *port;
 	atomic_t v4l_reading;
 };
 
 struct saa7164_vbi_fh {
+	struct v4l2_fh fh;
 	struct saa7164_port *port;
 	atomic_t v4l_reading;
 };
-- 
2.1.4

