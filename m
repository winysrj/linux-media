Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:27664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab1ATVQx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 16:16:53 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0KLGrqA028222
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 20 Jan 2011 16:16:53 -0500
Received: from [10.11.11.101] (vpn-11-101.rdu.redhat.com [10.11.11.101])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p0KLGp6P002192
	for <linux-media@vger.kernel.org>; Thu, 20 Jan 2011 16:16:52 -0500
Message-ID: <4D38A642.4090904@redhat.com>
Date: Thu, 20 Jan 2011 19:16:50 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] ir-raw: Properly initialize the IR event (BZ#27202)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Changeset 4651918a4afdd49bdea21d2f919b189ef17a6399 changed the way events
are stored. However, it forgot to fix ir_raw_event_store_edge() to work
with the new way. Due to that, the decoders will likely do bad things.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 185badd..45ffb08 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -112,7 +112,7 @@ int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type)
 {
 	ktime_t			now;
 	s64			delta; /* ns */
-	struct ir_raw_event	ev;
+	DEFINE_IR_RAW_EVENT(ev);
 	int			rc = 0;
 
 	if (!dev->raw)
@@ -125,7 +125,6 @@ int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type)
 	 * being called for the first time, note that delta can't
 	 * possibly be negative.
 	 */
-	ev.duration = 0;
 	if (delta > IR_MAX_DURATION || !dev->raw->last_type)
 		type |= IR_START_EVENT;
 	else
