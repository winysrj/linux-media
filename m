Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757960Ab1K3RId (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 12:08:33 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAUH8XWB030383
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 30 Nov 2011 12:08:33 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 1/5] [media] tuner-xc2028: Better report signal strength
Date: Wed, 30 Nov 2011 15:08:20 -0200
Message-Id: <1322672904-17340-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix lock bit to better indicate signal strength, from 4096 to
65535.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/tuner-xc2028.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index 3acbaa0..e531267 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -891,7 +891,7 @@ static int xc2028_signal(struct dvb_frontend *fe, u16 *strength)
 
 	/* Frequency is locked */
 	if (frq_lock == 1)
-		signal = 32768;
+		signal = 1 << 11;
 
 	/* Get SNR of the video signal */
 	rc = xc2028_get_reg(priv, 0x0040, &signal);
-- 
1.7.7.3

