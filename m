Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45248 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965294Ab3HHPAH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 11:00:07 -0400
Received: from avalon.ideasonboard.com (unknown [91.178.200.121])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id E1385363DA
	for <linux-media@vger.kernel.org>; Thu,  8 Aug 2013 16:59:48 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l: Fix colorspace conversion error in sample code
Date: Thu,  8 Aug 2013 17:01:10 +0200
Message-Id: <1375974070-2392-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sample code erroneously scales the y1, pb and pr variables from the
[0.0 .. 1.0] and [-0.5 .. 0.5] ranges to [0 .. 255] and [-128 .. 127].
Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/pixfmt.xml | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 99b8d2a..4babd4d 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -391,9 +391,9 @@ clamp (double x)
 	else               return r;
 }
 
-y1 = (255 / 219.0) * (Y1 - 16);
-pb = (255 / 224.0) * (Cb - 128);
-pr = (255 / 224.0) * (Cr - 128);
+y1 = (Y1 - 16) / 219.0;
+pb = (Cb - 128) / 224.0;
+pr = (Cr - 128) / 224.0;
 
 r = 1.0 * y1 + 0     * pb + 1.402 * pr;
 g = 1.0 * y1 - 0.344 * pb - 0.714 * pr;
-- 
Regards,

Laurent Pinchart

