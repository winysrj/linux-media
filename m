Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182Ab2EGSGM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 14:06:12 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: database.worker@googlemail.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] dvb_frontend: fix a regression with DVB-S zig-zag
Date: Mon,  7 May 2012 15:06:01 -0300
Message-Id: <1336413961-3429-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changeset 5bfaadde broke zig-zag for DVB-S drivers that don't
implement get_tune_settings() callback.

Fix the code, in order to allow it to work as before, otherwise
some channels may not be tuned anymore.

Fix Fedora Bugzilla:
	https://bugzilla.redhat.com/show_bug.cgi?id=814404

Reported-by: Michael Heijenga <database.worker@googlemail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 39696c6..de7dc29 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1898,6 +1898,10 @@ static int dtv_set_frontend(struct dvb_frontend *fe)
 	} else {
 		/* default values */
 		switch (c->delivery_system) {
+		case SYS_DVBS:
+		case SYS_DVBS2:
+		case SYS_ISDBS:
+		case SYS_TURBO:
 		case SYS_DVBC_ANNEX_A:
 		case SYS_DVBC_ANNEX_C:
 			fepriv->min_delay = HZ / 20;
-- 
1.7.8

