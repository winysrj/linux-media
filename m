Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4700 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945950Ab3FUUQx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 16:16:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH] saa7164: fix compiler warning
Date: Fri, 21 Jun 2013 22:16:47 +0200
Message-Id: <1371845807-3801-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

build/media_build/v4l/saa7164-core.c: In function 'saa7164_initdev':
build/media_build/v4l/saa7164-core.c:1192:6: warning: 'err' may be used uninitialized in this function [-Wmaybe-uninitialized]
  int err, i;
        ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7164/saa7164-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 5d27865..d37ee37 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1196,7 +1196,8 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 	if (NULL == dev)
 		return -ENOMEM;
 
-	if (v4l2_device_register(&pci_dev->dev, &dev->v4l2_dev)) {
+	err = v4l2_device_register(&pci_dev->dev, &dev->v4l2_dev);
+	if (err < 0) {
 		dev_err(&pci_dev->dev, "v4l2_device_register failed\n");
 		goto fail_free;
 	}
-- 
1.8.3.1

