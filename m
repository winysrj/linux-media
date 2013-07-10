Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39967 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab3GJKTN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jul 2013 06:19:13 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 2/5] v4l: Fix V4L2_MBUS_FMT_YUV10_1X30 media bus pixel code value
Date: Wed, 10 Jul 2013 12:19:29 +0200
Message-Id: <1373451572-3892-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1373451572-3892-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1373451572-3892-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_MBUS_FMT_YUV10_1X30 code is documented as being equal to
0x2014, while the v4l2-mediabus.h header defines it as 0x2016. Fix the
documentation.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index adc6198..0c2b1f2 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -2574,7 +2574,7 @@
 	    </row>
 	    <row id="V4L2-MBUS-FMT-YUV10-1X30">
 	      <entry>V4L2_MBUS_FMT_YUV10_1X30</entry>
-	      <entry>0x2014</entry>
+	      <entry>0x2016</entry>
 	      <entry></entry>
 	      <entry>y<subscript>9</subscript></entry>
 	      <entry>y<subscript>8</subscript></entry>
-- 
1.8.1.5

