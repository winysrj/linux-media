Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758289Ab3DYTIH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 15:08:07 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3PJ86Ex011805
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 25 Apr 2013 15:08:06 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/4] [media] cx25821-alsa; get rid of a __must_check error
Date: Thu, 25 Apr 2013 16:08:02 -0300
Message-Id: <1366916882-3565-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366916882-3565-1-git-send-email-mchehab@redhat.com>
References: <1366916882-3565-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The hole reason for __must_check is to not ignore an error.

However, a "ret" value is used at cx25821 just to avoid the
Kernel compilation to compain about it.

That, however, produces another warning (with W=1):

drivers/media/pci/cx25821/cx25821-alsa.c: In function 'cx25821_audio_fini':
drivers/media/pci/cx25821/cx25821-alsa.c:727:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]

With the current implementation of driver_for_each_device() and
cx25821_alsa_exit_callback(), there's actually just one
very unlikely condition where it will currently produce
an error: if driver_find() returns NULL.

Ok, there's not much that can be done, as it is on a driver's
function that returns void, but it can at least print some message
if the error happens.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/cx25821/cx25821-alsa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/cx25821/cx25821-alsa.c b/drivers/media/pci/cx25821/cx25821-alsa.c
index 81361c2..6e91e84 100644
--- a/drivers/media/pci/cx25821/cx25821-alsa.c
+++ b/drivers/media/pci/cx25821/cx25821-alsa.c
@@ -727,6 +727,8 @@ static void cx25821_audio_fini(void)
 	int ret;
 
 	ret = driver_for_each_device(drv, NULL, NULL, cx25821_alsa_exit_callback);
+	if (ret)
+		pr_err("%s failed to find a cx25821 driver.\n", __func__);
 }
 
 static int cx25821_alsa_init_callback(struct device *dev, void *data)
-- 
1.8.1.4

