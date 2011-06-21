Return-path: <mchehab@pedra>
Received: from mail2.matrix-vision.com ([85.214.244.251]:56399 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab1FUHj0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 03:39:26 -0400
From: Michael Jones <michael.jones@matrix-vision.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/2] add Y10, Y12 formats
Date: Tue, 21 Jun 2011 09:39:16 +0200
Message-Id: <1308641957-7805-2-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1308641957-7805-1-git-send-email-michael.jones@matrix-vision.de>
References: <1308641957-7805-1-git-send-email-michael.jones@matrix-vision.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
---

I added these when playing around with the shifter.

 src/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/src/main.c b/src/main.c
index 35c34a2..b9b9150 100644
--- a/src/main.c
+++ b/src/main.c
@@ -50,6 +50,8 @@ static struct {
 	enum v4l2_mbus_pixelcode code;
 } mbus_formats[] = {
 	{ "Y8", V4L2_MBUS_FMT_Y8_1X8},
+	{ "Y10", V4L2_MBUS_FMT_Y10_1X10 },
+	{ "Y12", V4L2_MBUS_FMT_Y12_1X12 },
 	{ "YUYV", V4L2_MBUS_FMT_YUYV8_1X16 },
 	{ "UYVY", V4L2_MBUS_FMT_UYVY8_1X16 },
 	{ "SBGGR8", V4L2_MBUS_FMT_SBGGR8_1X8 },
-- 
1.7.5.4


MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
