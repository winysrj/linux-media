Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-01.mandic.com.br ([200.225.81.132]:34656 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab3CCCA6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 21:00:58 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
	Cesar Eduardo Barros <cesarb@cesarb.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 09/14] MAINTAINERS: fix Documentation/video4linux/saa7134/
Date: Sat,  2 Mar 2013 22:53:47 -0300
Message-Id: <1362275632-20242-10-git-send-email-cesarb@cesarb.net>
In-Reply-To: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That directory never existed. The intention was probably to match
CARDLIST.saa7134 and README.saa7134.

Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 46c1288..44b9f69 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6741,7 +6741,7 @@ L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Odd fixes
-F:	Documentation/video4linux/saa7134/
+F:	Documentation/video4linux/*.saa7134
 F:	drivers/media/pci/saa7134/
 
 SAA7146 VIDEO4LINUX-2 DRIVER
-- 
1.7.11.7

