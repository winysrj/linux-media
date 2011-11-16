Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52394 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab1KPSTG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 13:19:06 -0500
Received: by bke11 with SMTP id 11so903634bke.19
        for <linux-media@vger.kernel.org>; Wed, 16 Nov 2011 10:19:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111116013445.GA5273@localhost>
References: <20111116013445.GA5273@localhost>
Date: Wed, 16 Nov 2011 15:19:04 -0300
Message-ID: <CALF0-+V+rEYi1of3jUGeVZsF2Ms215k0_CQjJx0qnPDUuC1BQQ@mail.gmail.com>
Subject: Cleanup proposal for media/gspca
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

In 'media/video/gspca/gspca.c' I really hated this cast (maybe because
I am too dumb to understand it):

  gspca_dev = (struct gspca_dev *) video_devdata(file);

wich is only legal because a struct video_device is the first member
of gspca_dev. IMHO, this is 'unnecesary obfuscation'.
The thing is the driver is surely working fine and there is no good
reasong for the change.

Is it ok to submit a patchset to change this? Something like this:

diff --git a/drivers/media/video/gspca/gspca.c
b/drivers/media/video/gspca/gspca.c
index 881e04c..5d962ce 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -1304,9 +1306,11 @@ static void gspca_release(struct video_device *vfd)
 static int dev_open(struct file *file)
 {
 	struct gspca_dev *gspca_dev;
+	struct video_device *vdev;

 	PDEBUG(D_STREAM, "[%s] open", current->comm);
-	gspca_dev = (struct gspca_dev *) video_devdata(file);
+	vdev = video_devdata(file);
+	gspca_dev = video_get_drvdata(vdev);
 	if (!gspca_dev->present)

Thanks,
Ezequiel.
