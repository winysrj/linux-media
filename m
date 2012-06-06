Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2987 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab2FFGRT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2012 02:17:19 -0400
Received: from alastor.dyndns.org (189.80-203-102.nextgentel.com [80.203.102.189] (may be forged))
	(authenticated bits=0)
	by smtp-vbr19.xs4all.nl (8.13.8/8.13.8) with ESMTP id q566HGYx074961
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Wed, 6 Jun 2012 08:17:18 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 4E25A1C320041
	for <linux-media@vger.kernel.org>; Wed,  6 Jun 2012 08:17:16 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH for v3.5] Fix vivi regression
Date: Wed, 6 Jun 2012 08:17:16 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201206060817.16073.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes a regression introduced by commit
5126f2590bee412e3053de851cb07f531e4be36a:

[media] v4l2-dev: add flag to have the core lock all file operations

I forgot to add the locks to the vivi read operation.

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 0960d7f..08c1024 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1149,10 +1149,14 @@ static ssize_t
 vivi_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 {
 	struct vivi_dev *dev = video_drvdata(file);
+	int err;
 
 	dprintk(dev, 1, "read called\n");
-	return vb2_read(&dev->vb_vidq, data, count, ppos,
+	mutex_lock(&dev->mutex);
+	err = vb2_read(&dev->vb_vidq, data, count, ppos,
 		       file->f_flags & O_NONBLOCK);
+	mutex_unlock(&dev->mutex);
+	return err;
 }
 
 static unsigned int
