Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932605Ab3BOPjh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 10:39:37 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] Revert "[media] dvb_frontend: return -ENOTTY for unimplement IOCTL"
Date: Fri, 15 Feb 2013 13:39:31 -0200
Message-Id: <1360942771-16213-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by Klaus:
	From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
	Subject: DVB: EOPNOTSUPP vs. ENOTTY in ioctl(FE_READ_UNCORRECTED_BLOCKS)
	Date: Thu, 14 Feb 2013 14:12:31 +0100

	In VDR I use an ioctl() call with FE_READ_UNCORRECTED_BLOCKS on a device (using stb0899).
	After this call I check 'errno' for EOPNOTSUPP to determine whether this
	device supports this call. This used to work just fine, until a few months
	ago I noticed that my devices using stb0899 didn't display their signal
	quality in VDR's OSD any more. After further investigation I found that
	ioctl(FE_READ_UNCORRECTED_BLOCKS) no longer returns EOPNOTSUPP, but rather
	ENOTTY. And since I stop getting the signal quality in case any unknown
	errno value appears, this broke my signal quality query function.

While the changes reflect what is there at:
	http://comments.gmane.org/gmane.linux.kernel/1235728
it does cause regression on userspace. So, revert it to stop the damage.

This reverts commit 177ffe506cf8ab5d1d52e7af36871a70d8c22e90:
	Author: Antti Palosaari <crope@iki.fi>
	Date:   Wed Aug 15 20:28:38 2012 -0300

	    [media] dvb_frontend: return -ENOTTY for unimplement IOCTL

	    Earlier it was returning -EOPNOTSUPP.

	    Signed-off-by: Antti Palosaari <crope@iki.fi>
	    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Reported-by: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 49d9504..0223ad2 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1820,7 +1820,7 @@ static int dvb_frontend_ioctl(struct file *file,
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	int err = -ENOTTY;
+	int err = -EOPNOTSUPP;
 
 	dev_dbg(fe->dvb->device, "%s: (%d)\n", __func__, _IOC_NR(cmd));
 	if (fepriv->exit != DVB_FE_NO_EXIT)
@@ -1938,7 +1938,7 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 		}
 
 	} else
-		err = -ENOTTY;
+		err = -EOPNOTSUPP;
 
 out:
 	kfree(tvp);
@@ -2071,7 +2071,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int err = -ENOTTY;
+	int err = -EOPNOTSUPP;
 
 	switch (cmd) {
 	case FE_GET_INFO: {
-- 
1.8.1.2

