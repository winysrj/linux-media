Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20783 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaABMv1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jan 2014 07:51:27 -0500
Date: Thu, 2 Jan 2014 15:51:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Luca Risolia <luca.risolia@studio.unibo.it>,
	Jim Davis <jim.epost@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: [patch] [media] staging: sn9c102: add a USB depend to the Kconfig
Message-ID: <20140102125117.GA12113@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+r1ZhgcNTuymyPdwk7S0B138WNtO-kKiXrEXX2Dd3BpfQWQhg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver won't link without USB support.

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/sn9c102/Kconfig b/drivers/staging/media/sn9c102/Kconfig
index d8ae2354b626..3ab9c81173da 100644
--- a/drivers/staging/media/sn9c102/Kconfig
+++ b/drivers/staging/media/sn9c102/Kconfig
@@ -1,6 +1,6 @@
 config USB_SN9C102
 	tristate "USB SN9C1xx PC Camera Controller support (DEPRECATED)"
-	depends on VIDEO_V4L2
+	depends on USB && VIDEO_V4L2
 	---help---
 	  This driver is DEPRECATED, please use the gspca sonixb and
 	  sonixj modules instead.
