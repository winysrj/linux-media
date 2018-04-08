Return-path: <linux-media-owner@vger.kernel.org>
Received: from [31.36.214.240] ([31.36.214.240]:39094 "EHLO
        val.bonstra.fr.eu.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753160AbeDHVVI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Apr 2018 17:21:08 -0400
From: Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
Subject: [PATCH v2 4/6] usbtv: Keep norm parameter specific
Date: Sun,  8 Apr 2018 23:11:59 +0200
Message-Id: <20180408211201.27452-5-bonstra@bonstra.fr.eu.org>
In-Reply-To: <20180408211201.27452-1-bonstra@bonstra.fr.eu.org>
References: <20180224182419.15670-1-bonstra@bonstra.fr.eu.org>
 <20180408211201.27452-1-bonstra@bonstra.fr.eu.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The user-supplied norm value gets overwritten by the generic .norm
member from the norm_params. That way, we lose the specific norm the
user may want to set.

For instance, if the user specifies V4L2_STD_PAL_60, the value actually
used will be V4L2_STD_525_60, which in the end will be as if the user
had specified V4L2_STD_NTSC, since this is always the first bitfield we
match the norm value against before configuring the hardware.

The norm_params array is only there to match a norm with an output
resolution. The norm value itself should not be changed.

Signed-off-by: Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
---
 drivers/media/usb/usbtv/usbtv-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 29e245083247..6cad50d1e5f8 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -77,7 +77,7 @@ static int usbtv_configure_for_norm(struct usbtv *usbtv, v4l2_std_id norm)
 		usbtv->height = params->cap_height;
 		usbtv->n_chunks = usbtv->width * usbtv->height
 						/ 4 / USBTV_CHUNK;
-		usbtv->norm = params->norm;
+		usbtv->norm = norm;
 	} else
 		ret = -EINVAL;
 
-- 
2.17.0
