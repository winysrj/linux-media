Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:33955 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbcEaOd2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2016 10:33:28 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
	Dave Jones <davej@codemonkey.org.uk>
Subject: [PATCH 2/2] dma-buf/sync_file: improve Kconfig description for Sync Files
Date: Tue, 31 May 2016 11:33:16 -0300
Message-Id: <1464705196-24369-2-git-send-email-gustavo@padovan.org>
In-Reply-To: <1464705196-24369-1-git-send-email-gustavo@padovan.org>
References: <1464705196-24369-1-git-send-email-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.co.uk>

We've got a complaint saying that the description was quite obtuse and
indeed it was. This patch tries to improve it.

Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
---
 drivers/dma-buf/Kconfig | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/dma-buf/Kconfig b/drivers/dma-buf/Kconfig
index 9824bc4..7e2d2c4 100644
--- a/drivers/dma-buf/Kconfig
+++ b/drivers/dma-buf/Kconfig
@@ -1,11 +1,20 @@
 menu "DMABUF options"
 
 config SYNC_FILE
-	bool "sync_file support for fences"
+	bool "Explicit Synchronization Framework"
 	default n
 	select ANON_INODES
 	select DMA_SHARED_BUFFER
 	---help---
-	  This option enables the fence framework synchronization to export
-	  sync_files to userspace that can represent one or more fences.
+	  The Sync File Framework adds explicit syncronization via
+	  userspace. It enables send/receive 'struct fence' objects to/from
+	  userspace via Sync File fds for synchronization between drivers via
+	  userspace components. It has been ported from Android.
+
+	  The first and main user for this is graphics in which a fence is
+	  associated with a buffer. When a job is submitted to the GPU a fence
+	  is attached to the buffer and is transfered via userspace, using Sync
+	  Files fds, to the DRM driver for example. More details at
+	  Documentation/sync_file.txt.
+
 endmenu
-- 
2.5.5

