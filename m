Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47290 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbeJEO7W (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 10:59:22 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH] MAINTAINERS: update videobuf2 entry
Date: Fri, 05 Oct 2018 10:01:41 +0200
Message-id: <20181005080141.2048-1-m.szyprowski@samsung.com>
References: <CGME20181005080146eucas1p1a5891321b2807e82dd9683f2bf7c6497@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commits 03fbdb2fc2b8 ("media: move videobuf2 to drivers/media/common")
and 7952be9b6ece ("media: drivers/media/common/videobuf2: rename from
videobuf") moved videobuf2 framework source code finally to
drivers/media/common/videobuf2 directory, so update relevant paths in
MAINTAINERS file.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 29c08106bd22..4455fe05d3a3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15720,7 +15720,7 @@ M:	Marek Szyprowski <m.szyprowski@samsung.com>
 M:	Kyungmin Park <kyungmin.park@samsung.com>
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	drivers/media/v4l2-core/videobuf2-*
+F:	drivers/media/common/videobuf2/*
 F:	include/media/videobuf2-*
 
 VIMC VIRTUAL MEDIA CONTROLLER DRIVER
-- 
2.17.1
