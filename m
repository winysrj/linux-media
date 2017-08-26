Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35196 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752051AbdHZLOJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 07:14:09 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        maintainers@bluecherrydvr.com, anton@corp.bluecherry.net,
        andrey.utkin@corp.bluecherry.net, ismael@iodev.co.uk,
        hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 3/5] [media] solo6x10:  make video_device const
Date: Sat, 26 Aug 2017 16:43:32 +0530
Message-Id: <1503746014-16489-4-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1503746014-16489-1-git-send-email-bhumirks@gmail.com>
References: <1503746014-16489-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only used in a copy operation.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/solo6x10/solo6x10-v4l2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 3266fc2..99ffd1e 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -630,7 +630,7 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
-static struct video_device solo_v4l2_template = {
+static const struct video_device solo_v4l2_template = {
 	.name			= SOLO6X10_NAME,
 	.fops			= &solo_v4l2_fops,
 	.ioctl_ops		= &solo_v4l2_ioctl_ops,
-- 
1.9.1
