Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48882 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbbFVP4m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2015 11:56:42 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>
Subject: [PATCH] au0828: fix the check for the media controller
Date: Thu, 18 Jun 2015 18:35:57 -0300
Message-Id: <027cf164d8f3a80c2127cc92e4620e04e883e829.1434663354.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  drivers/media/usb/au0828/au0828-cards.c: In function 'au0828_card_analog_fe_setup':
>> drivers/media/usb/au0828/au0828-cards.c:231:5: warning: "CONFIG_MEDIA_CONTROLLER" is not defined [-Wundef]
    #if CONFIG_MEDIA_CONTROLLER

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index f7337dbbc59f..ca861aea68a5 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -228,7 +228,7 @@ void au0828_card_analog_fe_setup(struct au0828_dev *dev)
 				"au8522", 0x8e >> 1, NULL);
 		if (sd == NULL)
 			pr_err("analog subdev registration failed\n");
-#if CONFIG_MEDIA_CONTROLLER
+#ifdef CONFIG_MEDIA_CONTROLLER
 		if (sd)
 			dev->decoder = &sd->entity;
 #endif
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
