Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:53445 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab3CJVxX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 17:53:23 -0400
Received: by mail-ea0-f173.google.com with SMTP id h14so878504eak.4
        for <linux-media@vger.kernel.org>; Sun, 10 Mar 2013 14:53:22 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFC PATCH v2 6/6] bttv: radio: apply mute settings on open
Date: Sun, 10 Mar 2013 22:53:54 +0100
Message-Id: <1362952434-2974-7-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362952434-2974-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1362952434-2974-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In contrast to the video device node, radio_open() doesn't select an input
(which would also applies the mute setting).
Hence the device needs to be muted/unmuted with an explicit call to audio_mux()
in this function.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |    2 ++
 1 Datei geändert, 2 Zeilen hinzugefügt(+)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 7459ad6..5031b6e 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3232,6 +3232,8 @@ static int radio_open(struct file *file)
 
 	v4l2_fh_add(&fh->fh);
 
+	audio_mute(btv, btv->mute);
+
 	return 0;
 }
 
-- 
1.7.10.4

