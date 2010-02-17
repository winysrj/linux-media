Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757822Ab0BQXVE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2010 18:21:04 -0500
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o1HNL28B010508
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 17 Feb 2010 18:21:03 -0500
Received: from [10.11.10.22] (vpn-10-22.rdu.redhat.com [10.11.10.22])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o1HNKxoX020308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 17 Feb 2010 18:21:01 -0500
Message-Id: <201002172321.o1HNKxoX020308@int-mx05.intmail.prod.int.phx2.redhat.com>
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Wed, 17 Feb 2010 21:13:19 -0200
Subject: [PATCH 2/2] V4L/DVB: az6027: az6027_read_mac_addr is currently unused
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org

drivers/media/dvb/dvb-usb/az6027.c:759: warning: ‘az6027_read_mac_addr’ defined but not used

While there's some code that uses it, it is currently commented. So, comment also
the function itself.

CC: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6027.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
index e8d5d05..919ca94 100644
--- a/drivers/media/dvb/dvb-usb/az6027.c
+++ b/drivers/media/dvb/dvb-usb/az6027.c
@@ -754,13 +754,13 @@ static int az6027_ci_init(struct dvb_usb_adapter *a)
 	return 0;
 }
 
-
+#if 0
 static int az6027_read_mac_addr(struct dvb_usb_device *d, u8 mac[6])
 {
 	az6027_usb_in_op(d, 0xb7, 6, 0, &mac[0], 6);
 	return 0;
 }
-
+#endif
 
 static int az6027_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
 {
-- 
1.6.6.1


