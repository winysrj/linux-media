Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26553 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbcDVKDv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 06:03:51 -0400
Date: Fri, 22 Apr 2016 13:03:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Terry Heo <terryheo@google.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] cx231xx: silence uninitialized variable warning
Message-ID: <20160422100330.GF11398@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We print an uninitialized "actlen" variable on the error path.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index f497888..6741fd0 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -752,7 +752,8 @@ EXPORT_SYMBOL_GPL(cx231xx_set_mode);
 int cx231xx_ep5_bulkout(struct cx231xx *dev, u8 *firmware, u16 size)
 {
 	int errCode = 0;
-	int actlen, ret = -ENOMEM;
+	int actlen = -1;
+	int ret = -ENOMEM;
 	u32 *buffer;
 
 	buffer = kzalloc(4096, GFP_KERNEL);
