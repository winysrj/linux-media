Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50215 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab3L1MQ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:16:29 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 07/24] em28xx: fix a cut and paste error
Date: Sat, 28 Dec 2013 10:15:59 -0200
Message-Id: <1388232976-20061-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

Don't use "dvb" at em28xx v4l module. This was due to a cut
and paste from em28xx-dvb extension.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 3baf22464c0d..664546959ea0 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2515,15 +2515,15 @@ static struct em28xx_ops v4l2_ops = {
 	.fini = em28xx_v4l2_fini,
 };
 
-static int __init em28xx_dvb_register(void)
+static int __init em28xx_v4l_register(void)
 {
 	return em28xx_register_extension(&v4l2_ops);
 }
 
-static void __exit em28xx_dvb_unregister(void)
+static void __exit em28xx_v4l_unregister(void)
 {
 	em28xx_unregister_extension(&v4l2_ops);
 }
 
-module_init(em28xx_dvb_register);
-module_exit(em28xx_dvb_unregister);
+module_init(em28xx_v4l_register);
+module_exit(em28xx_v4l_unregister);
-- 
1.8.3.1

