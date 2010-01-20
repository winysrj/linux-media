Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45660 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab0ATAmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 19:42:33 -0500
Message-ID: <4B5652A2.8060500@gmail.com>
Date: Wed, 20 Jan 2010 01:47:30 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cx23885: Wrong command printed in cmd_to_str()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The wrong command was printed for case CX2341X_ENC_SET_DNR_FILTER_MODE,
and a typo in case CX2341X_ENC_SET_PCR_ID.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Or is this intended?

diff --git a/drivers/media/video/cx23885/cx23885-417.c b/drivers/media/video/cx23885/cx23885-417.c
index 88c0d24..2ab97ad 100644
--- a/drivers/media/video/cx23885/cx23885-417.c
+++ b/drivers/media/video/cx23885/cx23885-417.c
@@ -681,7 +681,7 @@ static char *cmd_to_str(int cmd)
 	case CX2341X_ENC_SET_VIDEO_ID:
 		return  "SET_VIDEO_ID";
 	case CX2341X_ENC_SET_PCR_ID:
-		return  "SET_PCR_PID";
+		return  "SET_PCR_ID";
 	case CX2341X_ENC_SET_FRAME_RATE:
 		return  "SET_FRAME_RATE";
 	case CX2341X_ENC_SET_FRAME_SIZE:
@@ -693,7 +693,7 @@ static char *cmd_to_str(int cmd)
 	case CX2341X_ENC_SET_ASPECT_RATIO:
 		return  "SET_ASPECT_RATIO";
 	case CX2341X_ENC_SET_DNR_FILTER_MODE:
-		return  "SET_DNR_FILTER_PROPS";
+		return  "SET_DNR_FILTER_MODE";
 	case CX2341X_ENC_SET_DNR_FILTER_PROPS:
 		return  "SET_DNR_FILTER_PROPS";
 	case CX2341X_ENC_SET_CORING_LEVELS:
