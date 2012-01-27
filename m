Return-path: <linux-media-owner@vger.kernel.org>
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:53550
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752774Ab2A0Nw0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 08:52:26 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: mchehab@infradead.org, linux-media@vger.kernel.org
Cc: standby24x7@gmail.com, linux-kernel@vger.kernel.org,
	trivial@kernel.org
Subject: [PATCH] [trivial] media: Fix typo in lmedm04.c
Date: Fri, 27 Jan 2012 22:47:04 +0900
Message-Id: <1327672024-1919-1-git-send-email-standby24x7@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correct spelling "reseting" to "resetting" in
drivers/media/dvb/dvb-usb/lmedm04.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/media/dvb/dvb-usb/lmedm04.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index b3fe05b..291f6b1 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -1054,7 +1054,7 @@ static int dm04_lme2510_tuner(struct dvb_usb_adapter *adap)
 	if (ret)
 		info("TUN Found %s tuner", tun_msg[ret]);
 	else {
-		info("TUN No tuner found --- reseting device");
+		info("TUN No tuner found --- resetting device");
 		lme_coldreset(adap->dev->udev);
 		return -ENODEV;
 	}
-- 
1.7.6.5

