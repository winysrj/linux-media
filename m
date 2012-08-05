Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725Ab2HERon (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Aug 2012 13:44:43 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q75HihJZ007113
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 5 Aug 2012 13:44:43 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] [media] az6007: make all functions static
Date: Sun,  5 Aug 2012 14:44:38 -0300
Message-Id: <1344188679-8247-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344188679-8247-1-git-send-email-mchehab@redhat.com>
References: <1344188679-8247-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no reason why those functions shouldn't be static.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb-v2/az6007.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb-v2/az6007.c b/drivers/media/dvb/dvb-usb-v2/az6007.c
index bb7f61d..4a0ee64 100644
--- a/drivers/media/dvb/dvb-usb-v2/az6007.c
+++ b/drivers/media/dvb/dvb-usb-v2/az6007.c
@@ -635,7 +635,7 @@ static int az6007_tuner_attach(struct dvb_usb_adapter *adap)
 	return 0;
 }
 
-int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
+static int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
 	struct az6007_device_state *state = d_to_priv(d);
 	int ret;
@@ -784,7 +784,7 @@ static struct i2c_algorithm az6007_i2c_algo = {
 	.functionality = az6007_i2c_func,
 };
 
-int az6007_identify_state(struct dvb_usb_device *d, const char **name)
+static int az6007_identify_state(struct dvb_usb_device *d, const char **name)
 {
 	int ret;
 	u8 *mac;
-- 
1.7.11.2

