Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab2J0UmI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:08 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKg818006308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:08 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 29/68] [media] az6027: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:47 -0200
Message-Id: <1351370486-29040-30-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/dvb-usb/az6027.c:1054:5: warning: no previous prototype for 'az6027_identify_state' [-Wmissing-prototypes]
drivers/media/usb/dvb-usb/az6027.c:301:5: warning: no previous prototype for 'az6027_usb_in_op' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/dvb-usb/az6027.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/az6027.c b/drivers/media/usb/dvb-usb/az6027.c
index 5e45ae6..91e0119 100644
--- a/drivers/media/usb/dvb-usb/az6027.c
+++ b/drivers/media/usb/dvb-usb/az6027.c
@@ -298,7 +298,8 @@ struct stb6100_config az6027_stb6100_config = {
 
 
 /* check for mutex FIXME */
-int az6027_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen)
+static int az6027_usb_in_op(struct dvb_usb_device *d, u8 req,
+			    u16 value, u16 index, u8 *b, int blen)
 {
 	int ret = -1;
 	if (mutex_lock_interruptible(&d->usb_mutex))
@@ -1051,10 +1052,10 @@ static struct i2c_algorithm az6027_i2c_algo = {
 	.functionality = az6027_i2c_func,
 };
 
-int az6027_identify_state(struct usb_device *udev,
-			  struct dvb_usb_device_properties *props,
-			  struct dvb_usb_device_description **desc,
-			  int *cold)
+static int az6027_identify_state(struct usb_device *udev,
+				 struct dvb_usb_device_properties *props,
+				 struct dvb_usb_device_description **desc,
+				 int *cold)
 {
 	u8 *b;
 	s16 ret;
-- 
1.7.11.7

