Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:56123 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750938AbdISSsF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 14:48:05 -0400
Subject: [PATCH 3/3] [media] hdpvr: Return an error code only as a constant in
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
Message-ID: <0be95f0b-cc0e-27cc-5ec1-b5bc1bc48496@users.sourceforge.net>
Date: Tue, 19 Sep 2017 20:47:39 +0200
MIME-Version: 1.0
In-Reply-To: <82d14066-5816-111c-9d21-f6a439e559c1@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 19 Sep 2017 19:32:36 +0200

* Return an error code without storing it in an intermediate variable.

* Delete the local variable "retval" which became unnecessary
  with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/hdpvr/hdpvr-video.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index f06efcd70c14..2b39834309d2 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -136,6 +136,5 @@ int hdpvr_free_buffers(struct hdpvr_device *dev)
 int hdpvr_alloc_buffers(struct hdpvr_device *dev, uint count)
 {
 	uint i;
-	int retval = -ENOMEM;
 	u8 *mem;
 	struct hdpvr_buffer *buf;
@@ -181,6 +180,6 @@ int hdpvr_alloc_buffers(struct hdpvr_device *dev, uint count)
 	kfree(buf);
 exit:
 	hdpvr_free_buffers(dev);
-	return retval;
+	return -ENOMEM;
 }
 
-- 
2.14.1
