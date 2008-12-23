Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBNBZhoQ028550
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 06:35:43 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBNBZShC019861
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 06:35:29 -0500
Date: Tue, 23 Dec 2008 12:35:28 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
To: video4linux-list@redhat.com
In-Reply-To: <Pine.LNX.4.64.0812231225520.5188@axis700.grange>
Message-ID: <Pine.LNX.4.64.0812231230090.5188@axis700.grange>
References: <Pine.LNX.4.64.0812231225520.5188@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: 
Subject: [PATCH 1/3 v2] plat-mxc: define CONSISTENT_DMA_SIZE to 8M - needed
 by the camera driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

The mx3-camera soc-camera driver uses contiguous memory regions for its DMA
buffers. Reserve 8M RAM for consistent DMA allocations instead of the default
2M.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---

I know there has been a patch arond, making CONSISTENT_DMA_SIZE 
configurable. If it gets upstream, this patch can be dropped.

 arch/arm/plat-mxc/include/mach/memory.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/memory.h b/arch/arm/plat-mxc/include/mach/memory.h
index 203688e..d28cd4d 100644
--- a/arch/arm/plat-mxc/include/mach/memory.h
+++ b/arch/arm/plat-mxc/include/mach/memory.h
@@ -13,4 +13,7 @@
 
 #include <mach/hardware.h>
 
+/* We allocate 6MB for the camera driver video buffers */
+#define CONSISTENT_DMA_SIZE SZ_8M
+
 #endif /* __ASM_ARCH_MXC_MEMORY_H__ */
-- 
1.5.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
