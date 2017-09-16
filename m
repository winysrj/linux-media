Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:61674 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751273AbdIPNjz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 09:39:55 -0400
Subject: [PATCH 3/3] [media] si470x: Delete an unnecessary variable
 initialisation in si470x_usb_driver_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <b58222fa-99f8-f2d6-2755-5ccd4a91e783@users.sourceforge.net>
Message-ID: <3484e97b-4716-430c-b241-204c9364ddc3@users.sourceforge.net>
Date: Sat, 16 Sep 2017 15:39:48 +0200
MIME-Version: 1.0
In-Reply-To: <b58222fa-99f8-f2d6-2755-5ccd4a91e783@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 16 Sep 2017 15:08:39 +0200

The variable "retval" will eventually be set to an appropriate value
a bit later. Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/radio/si470x/radio-si470x-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 6fc6e8235f20..ae30e3da9d13 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -578,6 +578,6 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 	struct si470x_device *radio;
 	struct usb_host_interface *iface_desc;
 	struct usb_endpoint_descriptor *endpoint;
-	int i, int_end_size, retval = 0;
+	int i, int_end_size, retval;
 	unsigned char version_warning = 0;
 
-- 
2.14.1
