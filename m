Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:36378 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700Ab3CTTYW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 15:24:22 -0400
Received: by mail-ee0-f44.google.com with SMTP id l10so1370787eei.31
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 12:24:21 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFC PATCH 10/10] bttv: avoid mute on last close when the radio device node is still open
Date: Wed, 20 Mar 2013 20:24:50 +0100
Message-Id: <1363807490-3906-11-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com>
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
 drivers/media/pci/bt8xx/bttv-driver.c |    5 ++++-
 1 Datei geändert, 4 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 469ea06..124abaf 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3125,8 +3125,11 @@ static int bttv_release(struct file *file)
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

