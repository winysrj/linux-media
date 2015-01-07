Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48071 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbbAGLEh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jan 2015 06:04:37 -0500
Date: Wed, 7 Jan 2015 14:04:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] gspca: underflow in vidioc_s_parm()
Message-ID: <20150107110421.GB14864@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"n" is a user controlled integer.  The code here doesn't handle the case
where "n" is negative and this causes a static checker warning.

	drivers/media/usb/gspca/gspca.c:1571 vidioc_s_parm()
	warn: no lower bound on 'n'

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I haven't followed through to see if this is a real problem.

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 43d6505..27f7da1 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1565,6 +1565,8 @@ static int vidioc_s_parm(struct file *filp, void *priv,
 	int n;
 
 	n = parm->parm.capture.readbuffers;
+	if (n < 0)
+		return -EINVAL;
 	if (n == 0 || n >= GSPCA_MAX_FRAMES)
 		parm->parm.capture.readbuffers = gspca_dev->nbufread;
 	else
