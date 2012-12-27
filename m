Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab2L0ShZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 13:37:25 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qBRIbPHB010487
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 27 Dec 2012 13:37:25 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] m920x: Fix CodingStyle issues
Date: Thu, 27 Dec 2012 16:36:57 -0200
Message-Id: <1356633417-5701-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix CodingStyle issues introduced by the last patch

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/dvb-usb/m920x.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index bddd763..a70c5ea 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -191,10 +191,14 @@ static int m920x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 	if (!rc_state)
 		return -ENOMEM;
 
-	if ((ret = m920x_read(d->udev, M9206_CORE, 0x0, M9206_RC_STATE, rc_state, 1)) != 0)
+	ret = m920x_read(d->udev, M9206_CORE, 0x0, M9206_RC_STATE,
+			 rc_state, 1);
+	if (ret != 0)
 		goto out;
 
-	if ((ret = m920x_read(d->udev, M9206_CORE, 0x0, M9206_RC_KEY, rc_state + 1, 1)) != 0)
+	ret = m920x_read(d->udev, M9206_CORE, 0x0, M9206_RC_KEY,
+			 rc_state + 1, 1);
+	if (ret != 0)
 		goto out;
 
 	m920x_parse_rc_state(d, rc_state[0], state);
-- 
1.7.11.7

