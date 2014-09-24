Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34121 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaIXW1y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 18:27:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>
Subject: [PATCH 05/18] [media] pms: Fix a bad usage of the stack
Date: Wed, 24 Sep 2014 19:27:05 -0300
Message-Id: <7c1bc498f8e43841b8673756e016f62420611c05.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/parport/pms.c:632:21: warning: Variable length array is used.

The pms driver is doing something really bad: it is using the
stack to read data into a buffer whose size is given by the
user by the read() syscall. Replace it by a dynamically allocated
buffer.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/parport/pms.c b/drivers/media/parport/pms.c
index 9bc105b3db1b..e6b497528cea 100644
--- a/drivers/media/parport/pms.c
+++ b/drivers/media/parport/pms.c
@@ -629,11 +629,15 @@ static int pms_capture(struct pms *dev, char __user *buf, int rgb555, int count)
 {
 	int y;
 	int dw = 2 * dev->width;
-	char tmp[dw + 32]; /* using a temp buffer is faster than direct  */
+	char *tmp; /* using a temp buffer is faster than direct  */
 	int cnt = 0;
 	int len = 0;
 	unsigned char r8 = 0x5;  /* value for reg8  */
 
+	tmp = kmalloc(dw + 32, GFP_KERNEL);
+	if (!tmp)
+		return 0;
+
 	if (rgb555)
 		r8 |= 0x20; /* else use untranslated rgb = 565 */
 	mvv_write(dev, 0x08, r8); /* capture rgb555/565, init DRAM, PC enable */
@@ -664,6 +668,7 @@ static int pms_capture(struct pms *dev, char __user *buf, int rgb555, int count)
 			len += dt;
 		}
 	}
+	kfree(tmp);
 	return len;
 }
 
-- 
1.9.3

