Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3367 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab3CVNyL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 09:54:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] em28xx: tuner setup is broken after algo_data change.
Date: Fri, 22 Mar 2013 14:54:00 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Frank =?iso-8859-1?q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303221454.00647.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit aab3125c43d8fecc7134e5f1e729fabf4dd196da broke em28xx. I traced
this eventually to the change in what algo_data points to. This pointer
is also passed to em28xx_tuner_callback() through several hidden tuner
layers (yuck!) and that callback was not updated.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 46fff5c..cb7cdd3 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2229,8 +2229,9 @@ static unsigned short msp3400_addrs[] = {
 
 int em28xx_tuner_callback(void *ptr, int component, int command, int arg)
 {
+	struct em28xx_i2c_bus *i2c_bus = ptr;
+	struct em28xx *dev = i2c_bus->dev;
 	int rc = 0;
-	struct em28xx *dev = ptr;
 
 	if (dev->tuner_type != TUNER_XC2028 && dev->tuner_type != TUNER_XC5000)
 		return 0;
-- 
1.7.10.4

