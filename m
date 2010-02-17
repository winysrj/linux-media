Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757808Ab0BQXVD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2010 18:21:03 -0500
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o1HNL269023203
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 17 Feb 2010 18:21:02 -0500
Received: from [10.11.10.22] (vpn-10-22.rdu.redhat.com [10.11.10.22])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o1HNKx6O009631
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 17 Feb 2010 18:21:02 -0500
Message-Id: <201002172321.o1HNKx6O009631@int-mx04.intmail.prod.int.phx2.redhat.com>
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Wed, 17 Feb 2010 21:11:06 -0200
Subject: [PATCH 1/2] V4L/DVB: az6027: IR RC keys are using the old struct with 3 parameters, instead of 2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org

drivers/media/dvb/dvb-usb/az6027.c:390: warning: excess elements in struct initializer
drivers/media/dvb/dvb-usb/az6027.c:390: warning: (near initialization for ‘az6027_rc_keys[0]’)
drivers/media/dvb/dvb-usb/az6027.c:391: warning: excess elements in struct initializer
drivers/media/dvb/dvb-usb/az6027.c:391: warning: (near initialization for ‘az6027_rc_keys[1]’)

CC: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6027.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
index 30fd046..e8d5d05 100644
--- a/drivers/media/dvb/dvb-usb/az6027.c
+++ b/drivers/media/dvb/dvb-usb/az6027.c
@@ -387,8 +387,8 @@ static int az6027_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 
 /* keys for the enclosed remote control */
 static struct dvb_usb_rc_key az6027_rc_keys[] = {
-	{ 0x00, 0x01, KEY_1 },
-	{ 0x00, 0x02, KEY_2 },
+	{ 0x0001, KEY_1 },
+	{ 0x0002, KEY_2 },
 };
 
 /* remote control stuff (does not work with my box) */
-- 
1.6.6.1


