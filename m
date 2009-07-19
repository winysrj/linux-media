Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:52654 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbZGSS7F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 14:59:05 -0400
Received: by rv-out-0506.google.com with SMTP id f6so513916rvb.1
        for <linux-media@vger.kernel.org>; Sun, 19 Jul 2009 11:59:04 -0700 (PDT)
From: Brian Johnson <brijohn@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Brian Johnson <brijohn@gmail.com>
Subject: [PATCH] Add gspca sn9c20x subdriver entry to MAINTAINERS file
Date: Sun, 19 Jul 2009 14:58:56 -0400
Message-Id: <1248029936-6888-1-git-send-email-brijohn@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Brian Johnson <brijohn@gmail.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 18c3f0c..a28944f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2599,6 +2599,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 F:	drivers/media/video/gspca/pac207.c
 
+GSPCA SN9C20X SUBDRIVER
+P:	Brian Johnson
+M:	brijohn@gmail.com
+L:	linux-media@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
+S:	Maintained
+F:	drivers/media/video/gspca/sn9c20x.c
+
 GSPCA T613 SUBDRIVER
 P:	Leandro Costantino
 M:	lcostantino@gmail.com
-- 
1.5.6.3

