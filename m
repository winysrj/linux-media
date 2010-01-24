Return-path: <linux-media-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:51624 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab0AXUsG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 15:48:06 -0500
Received: from localhost (localhost [127.0.0.1])
	by sypressi.dnainternet.net (Postfix) with ESMTP id 82E88A5C93
	for <linux-media@vger.kernel.org>; Sun, 24 Jan 2010 22:39:11 +0200 (EET)
Received: from sypressi.dnainternet.net ([83.102.40.135])
	by localhost (sypressi.dnainternet.net [127.0.0.1]) (amavisd-new, port 10041)
	with ESMTP id swR3sfDRAtyP for <linux-media@vger.kernel.org>;
	Sun, 24 Jan 2010 22:39:11 +0200 (EET)
Received: from kirsikkapuu.dnainternet.net (kirsikkapuu.dnainternet.net [83.102.40.214])
	by sypressi.dnainternet.net (Postfix) with ESMTP id 6283AA5C2B
	for <linux-media@vger.kernel.org>; Sun, 24 Jan 2010 22:39:11 +0200 (EET)
Received: from mail.onse.fi (dna23-105.tampere.customers.dnainternet.fi [83.102.23.105])
	by kirsikkapuu.dnainternet.net (Postfix) with ESMTP id 5AB217F002
	for <linux-media@vger.kernel.org>; Sun, 24 Jan 2010 22:39:11 +0200 (EET)
Received: from gamma.onse.fi (gamma [10.0.0.7])
	by mail.onse.fi (Postfix) with ESMTP id F2C6D10DE0BC
	for <linux-media@vger.kernel.org>; Sun, 24 Jan 2010 22:39:10 +0200 (EET)
To: linux-media@vger.kernel.org
Subject: [PATCH] dvb-apps scan: fix zero transport stream id
From: Anssi Hannula <anssi.hannula@iki.fi>
Date: Sun, 24 Jan 2010 22:39:10 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001242239.10739.anssi.hannula@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

scan sometimes returns services with transport stream id = 0. This
happens when the service is allocated before the transport stream
id is known. This patch simply makes copy_transponder propagate
transport stream id changes to all services of the transponder.

Symptoms of zero transport stream id include VDR not showing EPG.

Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>

---

Index: dvb-apps-1181/util/scan/scan.c
===================================================================
--- dvb-apps-1181/util/scan/scan.c
+++ dvb-apps-1181/util/scan/scan.c	2010-01-24 22:22:25.092513605 +0200
@@ -236,6 +236,17 @@
 
 static void copy_transponder(struct transponder *d, struct transponder *s)
 {
+	struct list_head *pos;
+	struct service *service;
+
+	if (d->transport_stream_id != s->transport_stream_id) {
+		/* propagate change to any already allocated services */
+		list_for_each(pos, &d->services) {
+			service = list_entry(pos, struct service, list);
+			service->transport_stream_id = s->transport_stream_id;
+		}
+	}
+
 	d->network_id = s->network_id;
 	d->original_network_id = s->original_network_id;
 	d->transport_stream_id = s->transport_stream_id;


-- 
Anssi Hannula
