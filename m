Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742Ab2HERon (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Aug 2012 13:44:43 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q75HihvR006028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 5 Aug 2012 13:44:43 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] [media] az6007: rename "st" to "state" at az6007_power_ctrl()
Date: Sun,  5 Aug 2012 14:44:37 -0300
Message-Id: <1344188679-8247-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344188679-8247-1-git-send-email-mchehab@redhat.com>
References: <1344188679-8247-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On all other parts, this var is called state. So, use the same
name here, to be consistent.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb-v2/az6007.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb-v2/az6007.c b/drivers/media/dvb/dvb-usb-v2/az6007.c
index 4671eaa..bb7f61d 100644
--- a/drivers/media/dvb/dvb-usb-v2/az6007.c
+++ b/drivers/media/dvb/dvb-usb-v2/az6007.c
@@ -637,13 +637,13 @@ static int az6007_tuner_attach(struct dvb_usb_adapter *adap)
 
 int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
-	struct az6007_device_state *st = d_to_priv(d);
+	struct az6007_device_state *state = d_to_priv(d);
 	int ret;
 
 	pr_debug("%s()\n", __func__);
 
-	if (!st->warm) {
-		mutex_init(&st->mutex);
+	if (!state->warm) {
+		mutex_init(&state->mutex);
 
 		ret = az6007_write(d, AZ6007_POWER, 0, 2, NULL, 0);
 		if (ret < 0)
@@ -674,7 +674,7 @@ int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
 		if (ret < 0)
 			return ret;
 
-		st->warm = true;
+		state->warm = true;
 
 		return 0;
 	}
-- 
1.7.11.2

