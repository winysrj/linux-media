Return-path: <mchehab@pedra>
Received: from web45816.mail.sp1.yahoo.com ([68.180.199.61]:32003 "HELO
	web45816.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753650Ab0ICVUl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Sep 2010 17:20:41 -0400
Message-ID: <257277.1946.qm@web45816.mail.sp1.yahoo.com>
References: <666098.4241.qm@web45811.mail.sp1.yahoo.com> <Pine.LNX.4.64.1008312227240.25720@axis700.grange> <934905.16227.qm@web45811.mail.sp1.yahoo.com> <Pine.LNX.4.64.1009032201180.8788@axis700.grange>
Date: Fri, 3 Sep 2010 14:20:41 -0700 (PDT)
From: Poyo VL <poyo_vl@yahoo.com>
Subject: [PATCH] drivers/media/video/mt9v022.c (2.6.35.4): Fixed compilation warning
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1009032201180.8788@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

From: Ionut Gabriel Popescu <poyo_vl@yahoo.com>
Kernel: 2.6.35.4

The drivers/media/video/mt9v022.c file, on line 405, tries a "case 0" o a 
v4l2_mbus_pixelcode enum which don't have an 0 value element, so I got a compile 
warning. That "case" is useless so it can be removed. 


Signed-off-by: Ionut Gabriel Popescu <poyo_vl@yahoo.com>
---

--- a/drivers/media/video/mt9v022.c    2010-08-27 02:47:12.000000000 +0300
+++ b/drivers/media/video/mt9v022.c    2010-09-01 16:12:00.704505851 +0300
@@ -402,9 +402,6 @@
         if (mt9v022->model != V4L2_IDENT_MT9V022IX7ATC)
             return -EINVAL;
         break;
-    case 0:
-        /* No format change, only geometry */
-        break;
     default:
         return -EINVAL;
     }


      
