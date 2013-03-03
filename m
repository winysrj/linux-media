Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-01.mandic.com.br ([200.225.81.132]:50769 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab3CCCAz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 21:00:55 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
	Cesar Eduardo Barros <cesarb@cesarb.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: [PATCH 04/14] MAINTAINERS: fix drivers/media/i2c/cx2341x.c
Date: Sat,  2 Mar 2013 22:53:42 -0300
Message-Id: <1362275632-20242-5-git-send-email-cesarb@cesarb.net>
In-Reply-To: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This file was moved to drivers/media/common/ by commit 6259582 ([media]
cx2341x: move from media/i2c to media/common).

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5af82f9..261b245 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2286,7 +2286,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
 S:	Maintained
-F:	drivers/media/i2c/cx2341x*
+F:	drivers/media/common/cx2341x*
 F:	include/media/cx2341x*
 
 CX88 VIDEO4LINUX DRIVER
-- 
1.7.11.7

