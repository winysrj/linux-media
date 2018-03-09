Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60613 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751096AbeCIRBR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 12:01:17 -0500
Received: from axis700.grange ([84.44.204.122]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0Lskr7-1eWJ6L2iHh-012Iml for
 <linux-media@vger.kernel.org>; Fri, 09 Mar 2018 18:01:16 +0100
Received: from localhost (localhost [127.0.0.1])
        by axis700.grange (Postfix) with ESMTP id 538D160AE4
        for <linux-media@vger.kernel.org>; Fri,  9 Mar 2018 18:01:08 +0100 (CET)
Date: Fri, 9 Mar 2018 18:01:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: remove myself as soc-camera maintainer
Message-ID: <alpine.DEB.2.20.1803091800320.18806@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The soc-camera framework is deprecated, patches for it are very rare
and only contain trivial clean up. Further I haven't got any more
soc-camera systems running modern kernels.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 64cd083..80655f0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12942,10 +12942,9 @@ S:	Maintained
 F:	drivers/net/ethernet/smsc/smsc9420.*
 
 SOC-CAMERA V4L2 SUBSYSTEM
-M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
-S:	Maintained
+S:	Orphan
 F:	include/media/soc*
 F:	drivers/media/i2c/soc_camera/
 F:	drivers/media/platform/soc_camera/
-- 
1.9.3
