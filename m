Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:42516 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934321AbaDIXaT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 19:30:19 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-doc@vger.kernel.org,
	Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 2/2] dma-buf: update exp_name when using dma_buf_export()
Date: Thu, 10 Apr 2014 01:30:06 +0200
Message-Id: <1397086206-5898-2-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1397086206-5898-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1397086206-5898-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit c0b00a5 ("dma-buf: update debugfs output") modified the
default exporter name to be the KBUILD_MODNAME pre-processor
macro instead of __FILE__ but the documentation was not updated.

Also the "Supporting existing mmap interfaces in exporters" section
title seems wrong since talks about the interface used by importers.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 Documentation/dma-buf-sharing.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
index 505e711..7d61cef 100644
--- a/Documentation/dma-buf-sharing.txt
+++ b/Documentation/dma-buf-sharing.txt
@@ -66,7 +66,7 @@ The dma_buf buffer sharing API usage contains the following steps:
 
    Exporting modules which do not wish to provide any specific name may use the
    helper define 'dma_buf_export()', with the same arguments as above, but
-   without the last argument; a __FILE__ pre-processor directive will be
+   without the last argument; a KBUILD_MODNAME pre-processor directive will be
    inserted in place of 'exp_name' instead.
 
 2. Userspace gets a handle to pass around to potential buffer-users
@@ -352,7 +352,7 @@ Being able to mmap an export dma-buf buffer object has 2 main use-cases:
 
    No special interfaces, userspace simply calls mmap on the dma-buf fd.
 
-2. Supporting existing mmap interfaces in exporters
+2. Supporting existing mmap interfaces in importers
 
    Similar to the motivation for kernel cpu access it is again important that
    the userspace code of a given importing subsystem can use the same interfaces
-- 
1.9.0

