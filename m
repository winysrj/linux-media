Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab2AUQEn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:43 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4gRP003082
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:43 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 05/35] [media] az6007: Comment the gate_ctl mutex
Date: Sat, 21 Jan 2012 14:04:07 -0200
Message-Id: <1327161877-16784-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-5-git-send-email-mchehab@redhat.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
 <1327161877-16784-2-git-send-email-mchehab@redhat.com>
 <1327161877-16784-3-git-send-email-mchehab@redhat.com>
 <1327161877-16784-4-git-send-email-mchehab@redhat.com>
 <1327161877-16784-5-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mutex is there to protect the I2C gate. However, for some reason,
it is being called twice:

[ 2103.542796] usbcore: registered new interface driver dvb_usb_az6007
[ 2103.772392] az6007: drxk_gate_ctrl: enable
[ 2103.793900] az6007: drxk_gate_ctrl: enable

For now, let's just comment, to allow the driver to run.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 56126d4..ed376b8 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -52,7 +52,7 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 	struct az6007_device_state *st;
 	int status;
 
-	info("%s", __func__);
+	info("%s: %s", __func__, enable? "enable" : "disable" );
 
 	if (!adap)
 		return -EINVAL;
@@ -64,10 +64,14 @@ static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
 
 
 	if (enable) {
+#if 0
 		down(&st->pll_mutex);
+#endif
 		status = st->gate_ctrl(fe, 1);
 	} else {
+#if 0
 		status = st->gate_ctrl(fe, 0);
+#endif
 		up(&st->pll_mutex);
 	}
 	return status;
-- 
1.7.8

