Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:64230 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZLAGfZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 01:35:25 -0500
Message-ID: <4B14B8F1.6000805@oracle.com>
Date: Mon, 30 Nov 2009 22:34:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH -next] media/common/tuners: fix use of KERNEL_VERSION
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

pms.c uses KERNEL_VERSION so it needs to include version.h.

drivers/media/video/pms.c:682: error: implicit declaration of function 'KERNEL_VERSION'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/video/pms.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20091130.orig/drivers/media/video/pms.c
+++ linux-next-20091130/drivers/media/video/pms.c
@@ -29,6 +29,7 @@
 #include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
+#include <linux/version.h>
 #include <asm/io.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
