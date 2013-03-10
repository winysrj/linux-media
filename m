Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:40900 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab3CJVxW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 17:53:22 -0400
Received: by mail-ee0-f49.google.com with SMTP id d41so1840605eek.8
        for <linux-media@vger.kernel.org>; Sun, 10 Mar 2013 14:53:21 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFC PATCH v2 5/6] bttv: avoid mute on last close when the radio device node is still open
Date: Sun, 10 Mar 2013 22:53:53 +0100
Message-Id: <1362952434-2974-6-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362952434-2974-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1362952434-2974-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In contrast to video devices, radio devices should not be muted on the last
close of the device node.
In cases where a device provides a video and a radio device node, tuner
ownership has to be taken into account.

The current code doesn't handle tuner ownership yet, so never mute the device if
the radio device node is still open.
Also add a comment about this issue.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |    6 ++++--
 1 Datei geändert, 4 Zeilen hinzugefügt(+), 2 Zeilen entfernt(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 6432bfe..7459ad6 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3114,7 +3114,6 @@ static int bttv_release(struct file *file)
 	}
 
 	/* free stuff */
-
 	videobuf_mmap_free(&fh->cap);
 	videobuf_mmap_free(&fh->vbi);
 	file->private_data = NULL;
@@ -3122,8 +3121,11 @@ static int bttv_release(struct file *file)
 	btv->users--;
 	bttv_field_count(btv);
 
-	if (!btv->users)
+	if (!btv->users && !btv->radio_user)
 		audio_mute(btv, 1);
+	/* FIXME: should also depend on tuner ownership ! */
+	/* NOTE as long as we don't handle the tuner ownership properly,
+	 * only mute the device if the radio device node isn't open. */
 
 	v4l2_fh_del(&fh->fh);
 	v4l2_fh_exit(&fh->fh);
-- 
1.7.10.4

