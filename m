Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752241AbZLVAV6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2009 19:21:58 -0500
Message-Id: <200912220021.nBM0LmnV004937@imap1.linux-foundation.org>
Subject: [patch 3/3] drivers/media/video/pms.c needs version.h
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	hverkuil@xs4all.nl
From: akpm@linux-foundation.org
Date: Mon, 21 Dec 2009 16:21:48 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>

i386 allmodconfig:

drivers/media/video/pms.c: In function 'pms_querycap':
drivers/media/video/pms.c:682: error: implicit declaration of function 'KERNEL_VERSION'

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/pms.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/media/video/pms.c~drivers-media-video-pmsc-needs-versionh drivers/media/video/pms.c
--- a/drivers/media/video/pms.c~drivers-media-video-pmsc-needs-versionh
+++ a/drivers/media/video/pms.c
@@ -24,6 +24,7 @@
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
+#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
_
