Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36578 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750929AbdCMMyg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 08:54:36 -0400
From: Johan Hovold <johan@kernel.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6/6] [media] gspca: konica: add missing endpoint sanity check
Date: Mon, 13 Mar 2017 13:53:59 +0100
Message-Id: <20170313125359.29394-7-johan@kernel.org>
In-Reply-To: <20170313125359.29394-1-johan@kernel.org>
References: <20170313125359.29394-1-johan@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure to check the number of endpoints to avoid accessing memory
beyond the endpoint array should a device lack the expected endpoints.

Note that, as far as I can tell, the gspca framework has already made
sure there is at least one endpoint in the current alternate setting so
there should be no risk for a NULL-pointer dereference here.

Fixes: b517af722860 ("V4L/DVB: gspca_konica: New gspca subdriver for
konica chipset using cams")
Cc: stable <stable@vger.kernel.org>     # 2.6.37
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/gspca/konica.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/gspca/konica.c b/drivers/media/usb/gspca/konica.c
index 71f273377f83..31b2117e8f1d 100644
--- a/drivers/media/usb/gspca/konica.c
+++ b/drivers/media/usb/gspca/konica.c
@@ -184,6 +184,9 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		return -EIO;
 	}
 
+	if (alt->desc.bNumEndpoints < 2)
+		return -ENODEV;
+
 	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 
 	n = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].priv;
-- 
2.12.0
