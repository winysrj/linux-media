Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab2JSKnR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Oct 2012 06:43:17 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9JAhHIU021806
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 19 Oct 2012 06:43:17 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] [media] Remove include/linux/dvb/ stuff
Date: Fri, 19 Oct 2012 07:43:12 -0300
Message-Id: <1350643392-2193-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1350643392-2193-1-git-send-email-mchehab@redhat.com>
References: <1350643392-2193-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The only file left there is include/linux/dvb/video.h. The
only function for it is to include linux/compiler.h, but this
is already indirectly included. So, get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 include/linux/dvb/video.h | 29 -----------------------------
 1 file changed, 29 deletions(-)
 delete mode 100644 include/linux/dvb/Kbuild
 delete mode 100644 include/linux/dvb/video.h

diff --git a/include/linux/dvb/Kbuild b/include/linux/dvb/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/linux/dvb/video.h b/include/linux/dvb/video.h
deleted file mode 100644
index 85c20d9..0000000
--- a/include/linux/dvb/video.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- * video.h
- *
- * Copyright (C) 2000 Marcus Metzler <marcus@convergence.de>
- *                  & Ralph  Metzler <ralph@convergence.de>
- *                    for convergence integrated media GmbH
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public License
- * as published by the Free Software Foundation; either version 2.1
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
- *
- */
-#ifndef _DVBVIDEO_H_
-#define _DVBVIDEO_H_
-
-#include <linux/compiler.h>
-#include <uapi/linux/dvb/video.h>
-
-#endif /*_DVBVIDEO_H_*/
-- 
1.7.11.7

