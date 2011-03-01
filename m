Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:37460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab1CANSQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 08:18:16 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p21DIGlI030232
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 1 Mar 2011 08:18:16 -0500
Received: from pedra (vpn-225-140.phx2.redhat.com [10.3.225.140])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p21DIEb6025546
	for <linux-media@vger.kernel.org>; Tue, 1 Mar 2011 08:18:15 -0500
Date: Tue, 1 Mar 2011 10:17:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] matrox: Remove legacy VIDIOC_*_OLD ioctls
Message-ID: <20110301101757.6ad68480@pedra>
In-Reply-To: <cover.1298985234.git.mchehab@redhat.com>
References: <cover.1298985234.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Those ioctls were produced by the wrong arguments for _IO macros,
and were replaced by fixed versions on an early 2.6 kernel.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matrox/matroxfb_base.c
index a082deb..8c9dbac 100644
--- a/drivers/video/matrox/matroxfb_base.c
+++ b/drivers/video/matrox/matroxfb_base.c
@@ -101,8 +101,6 @@
 
 #include <linux/version.h>
 
-#define __OLD_VIDIOC_
-
 #include "matroxfb_base.h"
 #include "matroxfb_misc.h"
 #include "matroxfb_accel.h"
@@ -1152,7 +1150,6 @@ static int matroxfb_ioctl(struct fb_info *info,
 					return -EFAULT;
 				return err;
 			}
-		case VIDIOC_S_CTRL_OLD:
 		case VIDIOC_S_CTRL:
 			{
 				struct v4l2_control ctrl;
-- 
1.7.1


