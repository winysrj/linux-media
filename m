Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758751Ab3DYTII (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 15:08:08 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3PJ87or011818
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 25 Apr 2013 15:08:07 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/4] [media] cx25821-video: declare cx25821_vidioc_s_std as static
Date: Thu, 25 Apr 2013 16:08:01 -0300
Message-Id: <1366916882-3565-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366916882-3565-1-git-send-email-mchehab@redhat.com>
References: <1366916882-3565-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following warning:

	drivers/media/pci/cx25821/cx25821-video.c: At top level:
	drivers/media/pci/cx25821/cx25821-video.c:766:5: warning: no previous prototype for 'cx25821_vidioc_s_std' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/cx25821/cx25821-video.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 3ba856a..d270819 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -762,7 +762,8 @@ static int cx25821_vidioc_g_std(struct file *file, void *priv, v4l2_std_id *tvno
 	return 0;
 }
 
-int cx25821_vidioc_s_std(struct file *file, void *priv, v4l2_std_id tvnorms)
+static int cx25821_vidioc_s_std(struct file *file, void *priv,
+				v4l2_std_id tvnorms)
 {
 	struct cx25821_channel *chan = video_drvdata(file);
 	struct cx25821_dev *dev = chan->dev;
-- 
1.8.1.4

