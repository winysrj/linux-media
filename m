Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:48507 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753230Ab2HCLX7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Aug 2012 07:23:59 -0400
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 0F2F6CA
	for <linux-media@vger.kernel.org>; Fri,  3 Aug 2012 11:23:56 +0000 (GMT)
Received: from Webmail-eu.st.com (safex1hubcas1.st.com [10.75.90.14])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id A98862C95
	for <linux-media@vger.kernel.org>; Fri,  3 Aug 2012 11:23:56 +0000 (GMT)
From: Nicolas THERY <nicolas.thery@st.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"pawel@osciak.com" <Pawel Osciak>,
	"m.szyprowski@samsung.com" <Marek Szyprowski>,
	"kyungmin.park@samsung.com" <Kyungmin Park>
Date: Fri, 3 Aug 2012 13:23:54 +0200
Subject: [PATCH for 3.6] videobuf2: fix sparse warning
Message-ID: <501BB4CA.4010003@st.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix "symbol 'vb2_vmalloc_memops' was not declared. Should it be static?"
sparse warning.

Signed-off-by: Nicolas Thery <nicolas.thery@st.com>
---
 drivers/media/video/videobuf2-vmalloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/video/videobuf2-vmalloc.c b/drivers/media/video/videobuf2-vmalloc.c
index 6b5ca6c..94efa04 100644
--- a/drivers/media/video/videobuf2-vmalloc.c
+++ b/drivers/media/video/videobuf2-vmalloc.c
@@ -18,6 +18,7 @@
 #include <linux/vmalloc.h>
 
 #include <media/videobuf2-core.h>
+#include <media/videobuf2-vmalloc.h>
 #include <media/videobuf2-memops.h>
 
 struct vb2_vmalloc_buf {
-- 
1.7.11.3
