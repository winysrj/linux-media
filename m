Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab1L0BKC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:10:02 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR1A1LZ015751
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:10:01 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 01/91] [media] dvb-core: allow demods to specify the supported delivery systems supported standards.
Date: Mon, 26 Dec 2011 23:07:49 -0200
Message-Id: <1324948159-23709-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-1-git-send-email-mchehab@redhat.com>
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVB-S and DVB-T, as those were the standards supported by DVBv3.

New standards like DSS, ISDB and CTTB don't fit on any of the
above types.

while there's a way for the drivers to explicitly change whatever
default DELSYS were filled inside the core, still a fake value is
needed there, and a "compat" code to allow DVBv3 applications to
work with those delivery systems is needed. This is good for a
short term solution, while applications aren't using DVBv5 directly.

However, at long term, this is bad, as the compat code runs even
if the application is using DVBv5. Also, the compat code is not
perfect, and only works when the frontend is capable of auto-detecting
the parameters that aren't visible by the faked delivery systems.

So, let the frontend fill the supported delivery systems at the
device properties directly, and, in the future, let the core to use
the delsys to fill the reported info::type based on the delsys.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   13 +++++++++++++
 drivers/media/dvb/dvb-core/dvb_frontend.h |    8 ++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 8dedff4..f17c411 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1252,6 +1252,19 @@ static void dtv_set_default_delivery_caps(const struct dvb_frontend *fe, struct
 	const struct dvb_frontend_info *info = &fe->ops.info;
 	u32 ncaps = 0;
 
+	/*
+	 * If the frontend explicitly sets a list, use it, instead of
+	 * filling based on the info->type
+	 */
+	if (fe->ops.delsys[ncaps]) {
+		while (fe->ops.delsys[ncaps] && ncaps < MAX_DELSYS) {
+			p->u.buffer.data[ncaps] = fe->ops.delsys[ncaps];
+			ncaps++;
+		}
+		p->u.buffer.len = ncaps;
+		return;
+	}
+
 	switch (info->type) {
 	case FE_QPSK:
 		p->u.buffer.data[ncaps++] = SYS_DVBS;
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 895f88f..95f2134 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -42,6 +42,12 @@
 
 #include "dvbdev.h"
 
+/*
+ * Maximum number of Delivery systems per frontend. It
+ * should be smaller or equal to 32
+ */
+#define MAX_DELSYS	8
+
 struct dvb_frontend_tune_settings {
 	int min_delay_ms;
 	int step_size;
@@ -254,6 +260,8 @@ struct dvb_frontend_ops {
 
 	struct dvb_frontend_info info;
 
+	u8 delsys[MAX_DELSYS];
+
 	void (*release)(struct dvb_frontend* fe);
 	void (*release_sec)(struct dvb_frontend* fe);
 
-- 
1.7.8.352.g876a6

