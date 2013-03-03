Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-01.mandic.com.br ([200.225.81.132]:54037 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab3CCCA6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 21:00:58 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
	Cesar Eduardo Barros <cesarb@cesarb.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 10/14] MAINTAINERS: remove include/media/sh_veu.h
Date: Sat,  2 Mar 2013 22:53:48 -0300
Message-Id: <1362275632-20242-11-git-send-email-cesarb@cesarb.net>
In-Reply-To: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Apparently a copy-paste mistake; the similar sh_vou.h exists, and both
were added to MAINTAINERS by commit b618b69 ([media] MAINTAINERS: add
entries for sh_veu and sh_vou V4L2 drivers).

Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 44b9f69..5cb888a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7088,7 +7088,6 @@ M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
 L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	drivers/media/platform/sh_veu.c
-F:	include/media/sh_veu.h
 
 SH_VOU V4L2 OUTPUT DRIVER
 M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
-- 
1.7.11.7

