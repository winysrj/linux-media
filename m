Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:56045 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751497AbdISSqu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 14:46:50 -0400
Subject: [PATCH 2/3] [media] hdpvr: Improve a size determination in
 hdpvr_alloc_buffers()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Jonathan Sims <jonathan.625266@earthlink.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <82d14066-5816-111c-9d21-f6a439e559c1@users.sourceforge.net>
Message-ID: <b586b33a-e305-8592-bc3e-fe337e05a39a@users.sourceforge.net>
Date: Tue, 19 Sep 2017 20:46:30 +0200
MIME-Version: 1.0
In-Reply-To: <82d14066-5816-111c-9d21-f6a439e559c1@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 19 Sep 2017 19:27:53 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/hdpvr/hdpvr-video.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 657d910dfa1d..f06efcd70c14 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -145,6 +145,5 @@ int hdpvr_alloc_buffers(struct hdpvr_device *dev, uint count)
 		 "allocating %u buffers\n", count);
 
 	for (i = 0; i < count; i++) {
-
-		buf = kzalloc(sizeof(struct hdpvr_buffer), GFP_KERNEL);
+		buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 		if (!buf)
-- 
2.14.1
