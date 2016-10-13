Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:61224 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752516AbcJMRBa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 13:01:30 -0400
Subject: [PATCH 13/18] [media] RedRat3: Return directly after a failed
 rc_allocate_device() in redrat3_init_rc_dev()
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
Message-ID: <85408b7a-bd13-ed8f-bbc1-1c07a2285f67@users.sourceforge.net>
Date: Thu, 13 Oct 2016 18:40:32 +0200
MIME-Version: 1.0
In-Reply-To: <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 13 Oct 2016 14:54:46 +0200

Return directly after a call of the function "rc_allocate_device" failed
at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/redrat3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 002030f..74d93dd 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -860,7 +860,7 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 
 	rc = rc_allocate_device();
 	if (!rc)
-		goto out;
+		return NULL;
 
 	prod = le16_to_cpu(rr3->udev->descriptor.idProduct);
 	snprintf(rr3->name, sizeof(rr3->name), "RedRat3%s "
-- 
2.10.1

