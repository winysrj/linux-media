Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.bearnet.nu ([80.252.223.222]:1732 "EHLO relay.bearnet.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab0ATN4U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 08:56:20 -0500
Message-ID: <4B570A50.1060306@pelagicore.com>
Date: Wed, 20 Jan 2010 14:51:12 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] radio: Add the SAA7706H Car Radio DSP to v4l2-chip-ident.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add the SAA7706h to the v4l2-chip-ident.h

Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
---
diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index 6cc107d..5341e3d 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -155,6 +155,9 @@ enum {
 	/* module adv7343: just ident 7343 */
 	V4L2_IDENT_ADV7343 = 7343,

+	/* module saa7706h: just ident 7706 */
+	V4L2_IDENT_SAA7706H = 7706,
+
 	/* module wm8739: just ident 8739 */
 	V4L2_IDENT_WM8739 = 8739,


