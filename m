Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:61716 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933248AbcJMQqV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 12:46:21 -0400
Subject: [PATCH 16/18] [media] RedRat3: Move a variable assignment in
 redrat3_set_timeout()
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <1877a803-14b2-b064-f051-841b82fb2076@users.sourceforge.net>
Date: Thu, 13 Oct 2016 18:45:44 +0200
MIME-Version: 1.0
In-Reply-To: <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 13 Oct 2016 17:13:41 +0200

Move the assignment for the local variable "rr3" behind the source code
for a memory allocation by this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/redrat3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index e46a92a..06c9eea 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -475,7 +475,7 @@ static u32 redrat3_get_timeout(struct redrat3_dev *rr3)
 
 static int redrat3_set_timeout(struct rc_dev *rc_dev, unsigned int timeoutns)
 {
-	struct redrat3_dev *rr3 = rc_dev->priv;
+	struct redrat3_dev *rr3;
 	__be32 *timeout;
 	int ret;
 
@@ -484,6 +484,7 @@ static int redrat3_set_timeout(struct rc_dev *rc_dev, unsigned int timeoutns)
 		return -ENOMEM;
 
 	*timeout = cpu_to_be32(redrat3_us_to_len(timeoutns / 1000));
+	rr3 = rc_dev->priv;
 	ret = usb_control_msg(rr3->udev,
 			      usb_sndctrlpipe(rr3->udev, 0),
 			      RR3_SET_IR_PARAM,
-- 
2.10.1

