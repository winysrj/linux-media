Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:24595 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab2AOLc3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 06:32:29 -0500
Date: Sun, 15 Jan 2012 14:32:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Huang Shijie <shijie8@gmail.com>
Cc: Kang Yong <kangyong@telegent.com>,
	Zhang Xiaobing <xbzhang@telegent.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] tlg2300: fix up check_firmware() return
Message-ID: <20120115113219.GG20463@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The caller doesn't check the return value of check_firmware() but static
checkers complain.  It currently returns negative error codes, or zero
or greater on success but since the return type is boolean the values
are truncated to one or zero.  I've changed it to return an int,
negative on error and zero on success.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/video/tlg2300/pd-main.c b/drivers/media/video/tlg2300/pd-main.c
index 129f135..c096b3f 100644
--- a/drivers/media/video/tlg2300/pd-main.c
+++ b/drivers/media/video/tlg2300/pd-main.c
@@ -374,7 +374,7 @@ static inline void set_map_flags(struct poseidon *pd, struct usb_device *udev)
 }
 #endif
 
-static bool check_firmware(struct usb_device *udev, int *down_firmware)
+static int check_firmware(struct usb_device *udev, int *down_firmware)
 {
 	void *buf;
 	int ret;
@@ -398,7 +398,7 @@ static bool check_firmware(struct usb_device *udev, int *down_firmware)
 		*down_firmware = 1;
 		return firmware_download(udev);
 	}
-	return ret;
+	return 0;
 }
 
 static int poseidon_probe(struct usb_interface *interface,
