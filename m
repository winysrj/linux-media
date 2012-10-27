Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933334Ab2J0Umy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:54 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mike Isely <isely@pobox.com>
Subject: [PATCH 33/68] [media] pvrusb2: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:51 -0200
Message-Id: <1351370486-29040-34-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/pvrusb2/pvrusb2-v4l2.c:199:5: warning: no previous prototype for 'pvr2_s_std' [-Wmissing-prototypes]
drivers/media/usb/pvrusb2/pvrusb2-v4l2.c:368:5: warning: no previous prototype for 'pvr2_s_frequency' [-Wmissing-prototypes]

Cc: Mike Isely <isely@pobox.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index db249ca..6930676 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -196,7 +196,7 @@ static int pvr2_g_std(struct file *file, void *priv, v4l2_std_id *std)
 	return ret;
 }
 
-int pvr2_s_std(struct file *file, void *priv, v4l2_std_id *std)
+static int pvr2_s_std(struct file *file, void *priv, v4l2_std_id *std)
 {
 	struct pvr2_v4l2_fh *fh = file->private_data;
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
@@ -365,7 +365,7 @@ static int pvr2_s_tuner(struct file *file, void *priv, struct v4l2_tuner *vt)
 			vt->audmode);
 }
 
-int pvr2_s_frequency(struct file *file, void *priv, struct v4l2_frequency *vf)
+static int pvr2_s_frequency(struct file *file, void *priv, struct v4l2_frequency *vf)
 {
 	struct pvr2_v4l2_fh *fh = file->private_data;
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
-- 
1.7.11.7

