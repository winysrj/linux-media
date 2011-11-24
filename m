Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab1KXRFf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 12:05:35 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAOH5YBf032223
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 24 Nov 2011 12:05:34 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 2/2] [media] firedtv-avc: Fix compilation warnings
Date: Thu, 24 Nov 2011 15:05:21 -0200
Message-Id: <1322154321-24028-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1322154321-24028-1-git-send-email-mchehab@redhat.com>
References: <1322154321-24028-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb/firewire/firedtv-avc.c: In function ‘avc_tuner_tuneqpsk’:
drivers/media/dvb/firewire/firedtv-avc.c:394:4: warning: enumeration value ‘ROLLOFF_15’ not handled in switch [-Wswitch]
drivers/media/dvb/firewire/firedtv-avc.c:394:4: warning: enumeration value ‘ROLLOFF_13’ not handled in switch [-Wswitch]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/firewire/firedtv-avc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/firewire/firedtv-avc.c b/drivers/media/dvb/firewire/firedtv-avc.c
index 489ae82..9debf0f 100644
--- a/drivers/media/dvb/firewire/firedtv-avc.c
+++ b/drivers/media/dvb/firewire/firedtv-avc.c
@@ -392,10 +392,11 @@ static int avc_tuner_tuneqpsk(struct firedtv *fdtv,
 			default:		c->operand[13] = 0x2; break;
 			}
 			switch (fdtv->fe.dtv_property_cache.rolloff) {
-			case ROLLOFF_AUTO:	c->operand[14] = 0x2; break;
 			case ROLLOFF_35:	c->operand[14] = 0x2; break;
 			case ROLLOFF_20:	c->operand[14] = 0x0; break;
 			case ROLLOFF_25:	c->operand[14] = 0x1; break;
+			case ROLLOFF_AUTO:
+			default:		c->operand[14] = 0x2; break;
 			/* case ROLLOFF_NONE:	c->operand[14] = 0xff; break; */
 			}
 			switch (fdtv->fe.dtv_property_cache.pilot) {
-- 
1.7.7.1

