Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326Ab2J0UmR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:17 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKgHQa019829
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:17 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 38/68] [media] jeilinj: fix return of the response code
Date: Sat, 27 Oct 2012 18:40:56 -0200
Message-Id: <1351370486-29040-39-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/gspca/jeilinj.c: In function 'jlj_read1':
drivers/media/usb/gspca/jeilinj.c:117:66: warning: parameter 'response' set but not used [-Wunused-but-set-parameter]
The code still doesn't make much sense, as response is never tested
there.

Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/gspca/jeilinj.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/gspca/jeilinj.c b/drivers/media/usb/gspca/jeilinj.c
index b897aa8..1ba29fe 100644
--- a/drivers/media/usb/gspca/jeilinj.c
+++ b/drivers/media/usb/gspca/jeilinj.c
@@ -114,7 +114,7 @@ static void jlj_write2(struct gspca_dev *gspca_dev, unsigned char *command)
 }
 
 /* Responses are one byte only */
-static void jlj_read1(struct gspca_dev *gspca_dev, unsigned char response)
+static void jlj_read1(struct gspca_dev *gspca_dev, unsigned char *response)
 {
 	int retval;
 
@@ -123,7 +123,7 @@ static void jlj_read1(struct gspca_dev *gspca_dev, unsigned char response)
 	retval = usb_bulk_msg(gspca_dev->dev,
 	usb_rcvbulkpipe(gspca_dev->dev, 0x84),
 				gspca_dev->usb_buf, 1, NULL, 500);
-	response = gspca_dev->usb_buf[0];
+	*response = gspca_dev->usb_buf[0];
 	if (retval < 0) {
 		pr_err("read command [%02x] error %d\n",
 		       gspca_dev->usb_buf[0], retval);
@@ -260,7 +260,7 @@ static int jlj_start(struct gspca_dev *gspca_dev)
 		if (start_commands[i].delay)
 			msleep(start_commands[i].delay);
 		if (start_commands[i].ack_wanted)
-			jlj_read1(gspca_dev, response);
+			jlj_read1(gspca_dev, &response);
 	}
 	setcamquality(gspca_dev, v4l2_ctrl_g_ctrl(sd->jpegqual));
 	msleep(2);
-- 
1.7.11.7

