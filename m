Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38220 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889Ab0HKCJ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Aug 2010 22:09:27 -0400
Subject: [PATCH] V4L/DVB: v4l2-ctrls: add inclusion of slab.h
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	kernel-janitors <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 11 Aug 2010 04:12:56 +0200
Message-ID: <1281492776.4423.14.camel@lovely.krouter>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

This patch adds inclusion of slab.h to get kzalloc, kfree and kmalloc
to work.

Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
---
 drivers/media/video/v4l2-ctrls.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 84c1a53..ea8d32c 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/ctype.h>
+#include <linux/slab.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
-- 
1.7.1



