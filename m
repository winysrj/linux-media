Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:57549 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136AbcAZOLV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 09:11:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] [media] hdpvr: hide unused variable
Date: Tue, 26 Jan 2016 15:09:56 +0100
Message-Id: <1453817424-3080054-2-git-send-email-arnd@arndb.de>
In-Reply-To: <1453817424-3080054-1-git-send-email-arnd@arndb.de>
References: <1453817424-3080054-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The i2c client pointer is only used when CONFIG_I2C is set, and
otherwise produces a compile-time warning:

drivers/media/usb/hdpvr/hdpvr-core.c: In function 'hdpvr_probe':
drivers/media/usb/hdpvr/hdpvr-core.c:276:21: error: unused variable 'client' [-Werror=unused-variable]

This uses the same #ifdef to hide the variable when the code using
it is hidden.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/hdpvr/hdpvr-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index 3fc64197b4e6..08f0ca7aa012 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -273,7 +273,9 @@ static int hdpvr_probe(struct usb_interface *interface,
 	struct hdpvr_device *dev;
 	struct usb_host_interface *iface_desc;
 	struct usb_endpoint_descriptor *endpoint;
+#if IS_ENABLED(CONFIG_I2C)
 	struct i2c_client *client;
+#endif
 	size_t buffer_size;
 	int i;
 	int retval = -ENOMEM;
-- 
2.7.0

