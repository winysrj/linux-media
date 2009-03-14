Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:18253 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbZCNSVh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 14:21:37 -0400
Date: Sat, 14 Mar 2009 19:21:24 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] MAINTAINERS: Drop references to deprecated video4linux list
Message-ID: <20090314192124.127e286b@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mailing list video4linux-list@redhat.com is deprecated, so drop
references to it in MAINTAINERS.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 MAINTAINERS |    2 --
 1 file changed, 2 deletions(-)

--- linux-2.6.29-rc8.orig/MAINTAINERS	2009-03-13 08:39:30.000000000 +0100
+++ linux-2.6.29-rc8/MAINTAINERS	2009-03-14 19:17:56.000000000 +0100
@@ -1040,7 +1040,6 @@ BTTV VIDEO4LINUX DRIVER
 P:	Mauro Carvalho Chehab
 M:	mchehab@infradead.org
 L:	linux-media@vger.kernel.org
-L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
@@ -4739,7 +4738,6 @@ VIDEO FOR LINUX (V4L)
 P:	Mauro Carvalho Chehab
 M:	mchehab@infradead.org
 L:	linux-media@vger.kernel.org
-L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained


-- 
Jean Delvare
