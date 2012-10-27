Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758231Ab2J0UoE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:44:04 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKi4s1020070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:44:04 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 34/68] [media] pwc-if: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:52 -0200
Message-Id: <1351370486-29040-35-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/pwc/pwc-if.c:158:23: warning: no previous prototype for 'pwc_get_next_fill_buf' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/pwc/pwc-if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 42e36ba..e191572 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -155,7 +155,7 @@ static struct video_device pwc_template = {
 /***************************************************************************/
 /* Private functions */
 
-struct pwc_frame_buf *pwc_get_next_fill_buf(struct pwc_device *pdev)
+static struct pwc_frame_buf *pwc_get_next_fill_buf(struct pwc_device *pdev)
 {
 	unsigned long flags = 0;
 	struct pwc_frame_buf *buf = NULL;
-- 
1.7.11.7

