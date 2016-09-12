Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:36615 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752927AbcILXDM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Sep 2016 19:03:12 -0400
Received: by mail-lf0-f45.google.com with SMTP id g62so97919568lfe.3
        for <linux-media@vger.kernel.org>; Mon, 12 Sep 2016 16:03:11 -0700 (PDT)
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        mchehab@kernel.org, hans.verkuil@cisco.com, Julia.Lawall@lip6.fr
Cc: andrey_utkin@fastmail.com, maintainers@bluecherrydvr.com,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: [PATCH 2/2] [media] tw5864: constify struct video_device template
Date: Tue, 13 Sep 2016 02:02:38 +0300
Message-Id: <20160912230238.2302-3-andrey.utkin@corp.bluecherry.net>
In-Reply-To: <20160912230238.2302-1-andrey.utkin@corp.bluecherry.net>
References: <20160912230238.2302-1-andrey.utkin@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tw5864_video_template is used for filling of actual video_device
structures. It is copied by value, and is not used for anything else.

Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
---
 drivers/media/pci/tw5864/tw5864-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
index 7401b64..652a059 100644
--- a/drivers/media/pci/tw5864/tw5864-video.c
+++ b/drivers/media/pci/tw5864/tw5864-video.c
@@ -912,7 +912,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 #endif
 };
 
-static struct video_device tw5864_video_template = {
+static const struct video_device tw5864_video_template = {
 	.name = "tw5864_video",
 	.fops = &video_fops,
 	.ioctl_ops = &video_ioctl_ops,
-- 
2.9.2

