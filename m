Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:52246 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbbL2KTF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2015 05:19:05 -0500
Subject: [PATCH] [media] hdpvr: Refactoring for hdpvr_read()
References: <566ABCD9.1060404@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <56825E06.6040708@users.sourceforge.net>
Date: Tue, 29 Dec 2015 11:18:46 +0100
MIME-Version: 1.0
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 29 Dec 2015 11:02:43 +0100

Let us return directly if the element "status" of the variable "buf"
indicates "BUFSTAT_READY".
A check repetition can be excluded for the variable "ret" at the end then.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/hdpvr/hdpvr-video.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 7dee22d..ba7f022 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -462,10 +462,8 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
 			}
 
 			if (wait_event_interruptible(dev->wait_data,
-					      buf->status == BUFSTAT_READY)) {
-				ret = -ERESTARTSYS;
-				goto err;
-			}
+					      buf->status == BUFSTAT_READY))
+				return -ERESTARTSYS;
 		}
 
 		if (buf->status != BUFSTAT_READY)
-- 
2.6.3

