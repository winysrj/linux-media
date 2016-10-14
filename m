Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59094 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756668AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kosuke Tatsukawa <tatsu@ab.jp.nec.com>
Subject: [PATCH 35/57] [media] cpia2: don't break long lines
Date: Fri, 14 Oct 2016 17:20:23 -0300
Message-Id: <66781bf31f04b4d9998d12aa26752dbfc493a85d.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/cpia2/cpia2_usb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index 13620cdf0599..2e03f244c59f 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -733,9 +733,7 @@ int cpia2_usb_stream_start(struct camera_data *cam, unsigned int alternate)
 		cam->params.camera_state.stream_mode = old_alt;
 		ret2 = set_alternate(cam, USBIF_CMDONLY);
 		if (ret2 < 0) {
-			ERR("cpia2_usb_change_streaming_alternate(%d) =%d has already "
-			    "failed. Then tried to call "
-			    "set_alternate(USBIF_CMDONLY) = %d.\n",
+			ERR("cpia2_usb_change_streaming_alternate(%d) =%d has already failed. Then tried to call set_alternate(USBIF_CMDONLY) = %d.\n",
 			    alternate, ret, ret2);
 		}
 	} else {
-- 
2.7.4


