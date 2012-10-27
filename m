Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab2J0Umc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:32 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKgWMI020506
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:32 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 39/68] [media] gspca: warning fix: index is unsigned, so it will never be below 0
Date: Sat, 27 Oct 2012 18:40:57 -0200
Message-Id: <1351370486-29040-40-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/gspca/gspca.c: In function 'vidioc_querybuf':
drivers/media/usb/gspca/gspca.c:1590:6: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]

Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/gspca/gspca.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index a2b9341..e0a431b 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1586,8 +1586,7 @@ static int vidioc_querybuf(struct file *file, void *priv,
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 	struct gspca_frame *frame;
 
-	if (v4l2_buf->index < 0
-	    || v4l2_buf->index >= gspca_dev->nframes)
+	if (v4l2_buf->index >= gspca_dev->nframes)
 		return -EINVAL;
 
 	frame = &gspca_dev->frame[v4l2_buf->index];
-- 
1.7.11.7

