Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933190Ab2J0Umd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:33 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKgWlf006378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:32 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 32/68] [media] vp702x: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:50 -0200
Message-Id: <1351370486-29040-33-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/dvb-usb/vp702x.c:70:5: warning: no previous prototype for 'vp702x_usb_out_op_unlocked' [-Wmissing-prototypes]
drivers/media/usb/dvb-usb/vp702x.c:89:5: warning: no previous prototype for 'vp702x_usb_out_op' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/dvb-usb/vp702x.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/vp702x.c b/drivers/media/usb/dvb-usb/vp702x.c
index 07c673a..22cf9f9 100644
--- a/drivers/media/usb/dvb-usb/vp702x.c
+++ b/drivers/media/usb/dvb-usb/vp702x.c
@@ -56,7 +56,7 @@ static int vp702x_usb_in_op_unlocked(struct dvb_usb_device *d, u8 req,
 }
 
 int vp702x_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value,
-			    u16 index, u8 *b, int blen)
+		     u16 index, u8 *b, int blen)
 {
 	int ret;
 
@@ -67,8 +67,8 @@ int vp702x_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value,
 	return ret;
 }
 
-int vp702x_usb_out_op_unlocked(struct dvb_usb_device *d, u8 req, u16 value,
-				      u16 index, u8 *b, int blen)
+static int vp702x_usb_out_op_unlocked(struct dvb_usb_device *d, u8 req,
+				      u16 value, u16 index, u8 *b, int blen)
 {
 	int ret;
 	deb_xfer("out: req. %02x, val: %04x, ind: %04x, buffer: ",req,value,index);
@@ -86,7 +86,7 @@ int vp702x_usb_out_op_unlocked(struct dvb_usb_device *d, u8 req, u16 value,
 		return 0;
 }
 
-int vp702x_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
+static int vp702x_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 			     u16 index, u8 *b, int blen)
 {
 	int ret;
-- 
1.7.11.7

