Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:38155 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752051AbdHZLOC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 07:14:02 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        maintainers@bluecherrydvr.com, anton@corp.bluecherry.net,
        andrey.utkin@corp.bluecherry.net, ismael@iodev.co.uk,
        hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 2/5] [media] saa7134: make video_device const
Date: Sat, 26 Aug 2017 16:43:31 +0530
Message-Id: <1503746014-16489-3-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1503746014-16489-1-git-send-email-bhumirks@gmail.com>
References: <1503746014-16489-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only used in a copy operation.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/saa7134/saa7134-empress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index b1d3648..66acfd3 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -205,7 +205,7 @@ static int empress_try_fmt_vid_cap(struct file *file, void *priv,
 
 /* ----------------------------------------------------------- */
 
-static struct video_device saa7134_empress_template = {
+static const struct video_device saa7134_empress_template = {
 	.name          = "saa7134-empress",
 	.fops          = &ts_fops,
 	.ioctl_ops     = &ts_ioctl_ops,
-- 
1.9.1
