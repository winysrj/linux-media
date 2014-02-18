Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50586 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312AbaBRPBC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Feb 2014 10:01:02 -0500
Date: Tue, 18 Feb 2014 18:00:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] gspca_stv06xx: remove an unneeded check
Message-ID: <20140218150044.GC6914@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"err" is zero here so we don't need to check again.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c b/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
index bf3e5c317a26..e60cbb3aa609 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
@@ -178,7 +178,7 @@ static int vv6410_stop(struct sd *sd)
 
 	PDEBUG(D_STREAM, "Halting stream");
 
-	return (err < 0) ? err : 0;
+	return 0;
 }
 
 static int vv6410_dump(struct sd *sd)
