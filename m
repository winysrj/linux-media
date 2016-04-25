Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39234 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbcDYLOq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 07:14:46 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>
Subject: [PATCH] [media] sta2x11: remove unused vars
Date: Mon, 25 Apr 2016 08:13:24 -0300
Message-Id: <693730b81867dbb500066fc9ba7d7f95a0dcb8dd.1461582799.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changeset 7b9f31f3b3ca ("[media] sta2x11_vip: fix s_std") removed
autodetect code, but it kept two vars unused:

drivers/media/pci/sta2x11/sta2x11_vip.c: In function 'vidioc_s_std':
drivers/media/pci/sta2x11/sta2x11_vip.c:448:6: warning: unused variable 'status' [-Wunused-variable]
  int status;
      ^
drivers/media/pci/sta2x11/sta2x11_vip.c:447:14: warning: unused variable 'oldstd' [-Wunused-variable]
  v4l2_std_id oldstd = vip->std;
              ^
Remove them.

Fixes: 7b9f31f3b3ca ("[media] sta2x11_vip: fix s_std")
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/sta2x11/sta2x11_vip.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index c79623ca5fc3..1fc195f89686 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -444,8 +444,6 @@ static int vidioc_querycap(struct file *file, void *priv,
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id std)
 {
 	struct sta2x11_vip *vip = video_drvdata(file);
-	v4l2_std_id oldstd = vip->std;
-	int status;
 
 	/*
 	 * This is here for backwards compatibility only.
-- 
2.5.5

