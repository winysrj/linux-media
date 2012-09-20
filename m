Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:52628 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab2ITG6y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 02:58:54 -0400
Date: Thu, 20 Sep 2012 08:58:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media: sh-vou: fix compilation breakage
Message-ID: <Pine.LNX.4.64.1209200856260.25540@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A recent commit

commit f135a8a224294fa0f60ec1b8bc120813b7cfc804
Author: Hans Verkuil <hans.verkuil@cisco.com>
Date:   Sun Jun 24 06:33:26 2012 -0300

    [media] sh_vou: remove V4L2_FL_LOCK_ALL_FOPS

broke compilation of sh_vou.c:

drivers/media/platform/sh_vou.c: In function 'sh_vou_mmap':
drivers/media/platform/sh_vou.c:1227: error: 'vdev' undeclared (first use in this function)
drivers/media/platform/sh_vou.c:1227: error: (Each undeclared identifier is reported only once
drivers/media/platform/sh_vou.c:1227: error: for each function it appears in.)
drivers/media/platform/sh_vou.c: In function 'sh_vou_poll':
drivers/media/platform/sh_vou.c:1242: error: 'vdev' undeclared (first use in this function)
make[2]: *** [drivers/media/platform/sh_vou.o] Error 1

Add missing variable definitions.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

This is a fix for 3.7

 drivers/media/platform/sh_vou.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 9f62fd8..7f8b792 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1224,6 +1224,7 @@ static int sh_vou_release(struct file *file)
 
 static int sh_vou_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
 	struct sh_vou_file *vou_file = file->private_data;
 	int ret;
@@ -1239,6 +1240,7 @@ static int sh_vou_mmap(struct file *file, struct vm_area_struct *vma)
 
 static unsigned int sh_vou_poll(struct file *file, poll_table *wait)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct sh_vou_device *vou_dev = video_get_drvdata(vdev);
 	struct sh_vou_file *vou_file = file->private_data;
 	unsigned int res;
-- 
1.7.2.5

