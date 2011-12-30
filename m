Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab1L3PJU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:20 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9K49015848
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:20 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 01/94] [media] dvb-core: allow demods to specify the supported delsys
Date: Fri, 30 Dec 2011 13:06:58 -0200
Message-Id: <1325257711-12274-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb were originally written for DVB-T/C/S and ATSC. So,
the original frontend struct has fields to describe only those three
standards.

While 2nd gen standards are similar to these, new standards
like DSS, ISDB and CTTB don't fit on any of the above types.

While there's a way for the drivers to explicitly change whatever
default DELSYS were filled inside the core, still a fake value is
needed there, and a "compat" code to allow DVBv3 applications to
work with those delivery systems is needed. This is good for a
short term solution, while applications aren't using DVBv5 directly.

However, at long term, this is bad, as the compat code runs even
if the application is using DVBv5. Also, the compat code is not
perfect, and only works when the frontend is capable of auto-detecting
the parameters that aren't visible by the faked delivery systems.

So, let the frontend fill the supported delivery systems at the
device properties directly.

The future plan is that the drivers will stop filling ops->info.type,
filling, instead, ops->delsys. This will allow multi-frontend
devices like drx-k to use just one frontend structure for all supported
delivery systems.

Of course, the core will keep using it, in order to keep allowing
DVBv3 calls.

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

