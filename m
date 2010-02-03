Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:37615 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757842Ab0BCUPo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 15:15:44 -0500
Message-ID: <4B69D950.2090504@arcor.de>
Date: Wed, 03 Feb 2010 21:15:12 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 3/15] -  tm6000 bugfix hunk in init_dev
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com> <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com> <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de> <4B69D8CC.2030008@arcor.de>
In-Reply-To: <4B69D8CC.2030008@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -402,6 +448,7 @@ static int tm6000_init_dev(struct tm6000_core *dev)
         }
 #endif
     }
+    return 0;
 
 err2:
     v4l2_device_unregister(&dev->v4l2_dev);

-- 
Stefan Ringel <stefan.ringel@arcor.de>

