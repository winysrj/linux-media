Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:40280 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab1KKMFf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 07:05:35 -0500
Received: from epcpsbgm2.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LUH00LY6W8RPGT0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Nov 2011 21:05:34 +0900 (KST)
Received: from riverful-ubuntu.165.213.246.161 ([165.213.219.119])
 by mmp2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTPA id <0LUH00JHDW997900@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Nov 2011 21:05:33 +0900 (KST)
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: linux-media@vger.kernel.org
Cc: "HeungJun, Kim" <riverful.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] MAINTAINERS: Add m5mols driver maintainers
Date: Fri, 11 Nov 2011 21:05:33 +0900
Message-id: <1321013133-8763-1-git-send-email-riverful.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the maintainers for the m5mols driver

Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5e587fc..91c5511 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2804,6 +2804,14 @@ L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/fujitsu-laptop.c
 
+FUJITSU M-5MO LS CAMERA ISP DRIVER
+M:	Kyungmin Park <kyungmin.park@samsung.com>
+M:	Heungjun Kim <riverful.kim@samsung.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/video/m5mols/
+F:	include/media/m5mols.h
+
 FUSE: FILESYSTEM IN USERSPACE
 M:	Miklos Szeredi <miklos@szeredi.hu>
 L:	fuse-devel@lists.sourceforge.net
-- 
1.7.4.1

