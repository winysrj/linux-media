Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:55432 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1JNED0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 00:03:26 -0400
Received: from epcpsbgm2.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LT100EYXF9DCRH0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 14 Oct 2011 13:03:24 +0900 (KST)
Received: from jtppark ([12.23.121.105])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LT10080EF9N1R70@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Fri, 14 Oct 2011 13:03:24 +0900 (KST)
Reply-to: jtp.park@samsung.com
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>
Cc: 'Marek Szyprowski' <m.szyprowski@samsung.com>,
	'Kamil Debski' <k.debski@samsung.com>, kgene.kim@samsung.com,
	kyungmin.park@samsung.com, 'Jeongtae Park' <jtp.park@samsung.com>
Subject: [PATCH] MAINTAINERS: add a maintainer for s5p-mfc driver
Date: Fri, 14 Oct 2011 13:03:23 +0900
Message-id: <007601cc8a26$3809f9f0$a81dedd0$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a maintainer for s5p-mfc driver.

Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5e207a8..ef16770 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1087,6 +1087,7 @@ F:        drivers/media/video/s5p-fimc/
 ARM/SAMSUNG S5P SERIES Multi Format Codec (MFC) SUPPORT
 M:     Kyungmin Park <kyungmin.park@samsung.com>
 M:     Kamil Debski <k.debski@samsung.com>
+M:     Jeongtae Park <jtp.park@samsung.com>
 L:     linux-arm-kernel@lists.infradead.org
 L:     linux-media@vger.kernel.org
 S:     Maintained
-- 
1.7.1

