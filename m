Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933343Ab2J0Ums (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:48 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 15/68] [media] ivtv-ioctl.c: remove an useless check
Date: Sat, 27 Oct 2012 18:40:33 -0200
Message-Id: <1351370486-29040-16-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/ivtv/ivtv-ioctl.c: In function 'ivtv_s_input':
drivers/media/pci/ivtv/ivtv-ioctl.c:996:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]

Cc: Andy Walls <awalls@md.metrocast.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/ivtv/ivtv-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 31a69eb..7a8b0d0 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -993,7 +993,7 @@ int ivtv_s_input(struct file *file, void *fh, unsigned int inp)
 	v4l2_std_id std;
 	int i;
 
-	if (inp < 0 || inp >= itv->nof_inputs)
+	if (inp >= itv->nof_inputs)
 		return -EINVAL;
 
 	if (inp == itv->active_input) {
-- 
1.7.11.7

