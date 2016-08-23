Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:60811 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754238AbcHWGvD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Aug 2016 02:51:03 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by tschai.lan (Postfix) with ESMTPSA id BD5A51800C3
        for <linux-media@vger.kernel.org>; Tue, 23 Aug 2016 08:48:37 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] redrat3: fix sparse warning
Message-ID: <0a64424f-6e91-a5dc-2320-b0694ecb0ac4@xs4all.nl>
Date: Tue, 23 Aug 2016 08:48:37 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this sparse warning:

drivers/media/rc/redrat3.c:490:18: warning: incorrect type in assignment (different base types)
drivers/media/rc/redrat3.c:495:9: warning: cast to restricted __be32

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 399f44d..3d849ff 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -480,7 +480,7 @@ static int redrat3_set_timeout(struct rc_dev *rc_dev, unsigned int timeoutns)
 	struct redrat3_dev *rr3 = rc_dev->priv;
 	struct usb_device *udev = rr3->udev;
 	struct device *dev = rr3->dev;
-	u32 *timeout;
+	__be32 *timeout;
 	int ret;

 	timeout = kmalloc(sizeof(*timeout), GFP_KERNEL);
