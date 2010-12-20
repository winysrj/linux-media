Return-path: <mchehab@gaivota>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54978 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069Ab0LTP6I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 10:58:08 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LDQ005K8HOT7N00@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Dec 2010 15:58:05 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LDQ000C0HOT3R@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Dec 2010 15:58:05 +0000 (GMT)
Date: Mon, 20 Dec 2010 16:58:01 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/2 v3] Add chip identity for NOON010PC30 camera sensor
In-reply-to: <1292860682-12014-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1292860682-12014-2-git-send-email-s.nawrocki@samsung.com>
References: <1292860682-12014-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Add ID for NOON010PC30 camera chip and reserve ID range for
Siliconfile sensors.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/media/v4l2-chip-ident.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index 51e89f2..bd6e7e4 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -208,6 +208,9 @@ enum {
 	/* module sn9c20x: just ident 10000 */
 	V4L2_IDENT_SN9C20X = 10000,
 
+	/* Siliconfile sensors: reserved range 10100 - 10199 */
+	V4L2_IDENT_NOON010PC30	= 10100,
+
 	/* module cx231xx and cx25840 */
 	V4L2_IDENT_CX2310X_AV = 23099, /* Integrated A/V decoder; not in '100 */
 	V4L2_IDENT_CX23100    = 23100,
-- 
1.7.2.3

