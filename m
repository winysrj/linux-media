Return-path: <linux-media-owner@vger.kernel.org>
Received: from tur.go2.pl ([193.17.41.50]:52418 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042Ab1H2USK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 16:18:10 -0400
Received: from moh2-ve3.go2.pl (moh2-ve3.go2.pl [193.17.41.208])
	by tur.go2.pl (Postfix) with ESMTP id B94AB2302F6
	for <linux-media@vger.kernel.org>; Mon, 29 Aug 2011 22:18:08 +0200 (CEST)
Received: from moh2-ve3.go2.pl (unknown [10.0.0.208])
	by moh2-ve3.go2.pl (Postfix) with ESMTP id 37F94370252
	for <linux-media@vger.kernel.org>; Mon, 29 Aug 2011 22:18:03 +0200 (CEST)
Received: from unknown (unknown [10.0.0.42])
	by moh2-ve3.go2.pl (Postfix) with SMTP
	for <linux-media@vger.kernel.org>; Mon, 29 Aug 2011 22:18:03 +0200 (CEST)
Message-ID: <4E5BF3F7.9090101@o2.pl>
Date: Mon, 29 Aug 2011 22:17:59 +0200
From: Maciej Szmigiero <mhej@o2.pl>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [V4L2]decrement struct v4l2_device refcount on device urnegister
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit bedf8bcf6b4f90a6e31add3721a2e71877289381 introduced reference counting
for struct v4l2_device.

In v4l2_device_register() a call to kref_init() initializes reference count to 1,
but in v4l2_device_unregister() there is no corresponding decrement.

End result is that reference count never reaches zero and v4l2_device_release()
is never called, not even on videodev module unload.

Fix this by adding reference counter decrement to v4l2_device_unregister().

Signed-off-by: Maciej Szmigiero <mhej@o2.pl>

diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c

index c72856c..eb39af9 100644

--- a/drivers/media/video/v4l2-device.c

+++ b/drivers/media/video/v4l2-device.c

@@ -131,6 +131,8 @@ void v4l2_device_unregister(struct v4l2_device *v4l2_dev)

         }

 #endif

     }

+

+    v4l2_device_put(v4l2_dev);

 }

 EXPORT_SYMBOL_GPL(v4l2_device_unregister);

 

