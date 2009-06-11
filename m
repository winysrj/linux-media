Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57448 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752848AbZFKHMa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 03:12:30 -0400
Date: Thu, 11 Jun 2009 09:12:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Magnus Damm <magnus.damm@gmail.com>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Subject: [PATCH 1/4] V4L2: add a new V4L2_CID_BAND_STOP_FILTER integer control
In-Reply-To: <Pine.LNX.4.64.0906101549160.4817@axis700.grange>
Message-ID: <Pine.LNX.4.64.0906101558090.4817@axis700.grange>
References: <Pine.LNX.4.64.0906101549160.4817@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new V4L2_CID_BAND_STOP_FILTER integer control, which either switches the
band-stop filter off, or sets it to a certain strength.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/linux/videodev2.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index ebb2ea6..f50ec61 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -894,8 +894,10 @@ enum v4l2_colorfx {
 	V4L2_COLORFX_SEPIA	= 2,
 };
 
+#define V4L2_CID_BAND_STOP_FILTER		(V4L2_CID_BASE+32)
+
 /* last CID + 1 */
-#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+32)
+#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+33)
 
 /*  MPEG-class control IDs defined by V4L2 */
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
-- 
1.6.2.4

