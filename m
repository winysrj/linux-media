Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41337 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934290AbbLPRLh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 12:11:37 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 4/5] [media] au0828-core: fix compilation when !CONFIG_MEDIA_CONTROLLER
Date: Wed, 16 Dec 2015 15:11:14 -0200
Message-Id: <a1532b4df91d3444bb8f5a8925b0d5f2c0606fbd.1450285867.git.mchehab@osg.samsung.com>
In-Reply-To: <6c927d1218bd10ccb3a0e8d727e153f0b5798603.1450285867.git.mchehab@osg.samsung.com>
References: <6c927d1218bd10ccb3a0e8d727e153f0b5798603.1450285867.git.mchehab@osg.samsung.com>
In-Reply-To: <6c927d1218bd10ccb3a0e8d727e153f0b5798603.1450285867.git.mchehab@osg.samsung.com>
References: <6c927d1218bd10ccb3a0e8d727e153f0b5798603.1450285867.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit 1590ad7b52714 ("[media] media-device: split media initialization
and registration") moved the media controller register to a
separate function. That caused the following compilation issue,
if !CONFIG_MEDIA_CONTROLLER:

vim +445 drivers/media/usb/au0828/au0828-core.c

   439		if (retval) {
   440			pr_err("%s() au0282_dev_register failed to create graph\n",
   441			       __func__);
   442			goto done;
   443		}
   444
 > 445		retval = media_device_register(dev->media_dev);
   446
   447	done:
   448		if (retval < 0)

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 2f91bbc633b4..101d32954fe8 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -458,7 +458,9 @@ static int au0828_usb_probe(struct usb_interface *interface,
 		goto done;
 	}
 
+#ifdef CONFIG_MEDIA_CONTROLLER
 	retval = media_device_register(dev->media_dev);
+#endif
 
 done:
 	if (retval < 0)
-- 
2.5.0

