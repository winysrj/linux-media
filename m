Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39194 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab2GZLUy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 07:20:54 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1708544wgb.1
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 04:20:53 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, fabio.estevam@freescale.com,
	g.liakhovetski@gmx.de, sakari.ailus@maxwell.research.nokia.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, mchehab@infradead.org,
	linux@arm.linux.org.uk, kernel@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 3/4] Schedule removal of i.MX25 support in mx2_camera.c
Date: Thu, 26 Jul 2012 13:20:36 +0200
Message-Id: <1343301637-19676-4-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1343301637-19676-1-git-send-email-javier.martin@vista-silicon.com>
References: <1343301637-19676-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for i.MX25 in mx2_camera.c has been broken
for a year. Furthermore, i.MX25 video capture HW
doesn't have much in common with i.MX27. A separate
driver would be desirable.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 Documentation/feature-removal-schedule.txt |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 56000b3..6c50a17 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -6,6 +6,15 @@ be removed from this file.  The suggested deprecation period is 3 releases.
 
 ---------------------------
 
+What:	support for i.mx25 in mx2_camera.c
+When:	v3.8
+Why:	it's been broken for a year. Furthermore, i.MX25 video capture
+	HW doesn't have much in common with i.MX27. A separate driver
+	will be needed for it.
+Who:	Javier Martin<javier.martin@vista-silicon.com>
+
+---------------------------
+
 What:	ddebug_query="query" boot cmdline param
 When:	v3.8
 Why:	obsoleted by dyndbg="query" and module.dyndbg="query"
-- 
1.7.9.5

