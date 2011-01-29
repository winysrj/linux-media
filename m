Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:61754 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab1A2Ayl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jan 2011 19:54:41 -0500
Date: Sat, 29 Jan 2011 01:53:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Baruch Siach <baruch@tkos.co.il>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: [PATCH 1/3] V4L: add missing EXPORT_SYMBOL* statements to vb2
In-Reply-To: <Pine.LNX.4.64.1101290113500.19247@axis700.grange>
Message-ID: <Pine.LNX.4.64.1101290151140.19247@axis700.grange>
References: <Pine.LNX.4.64.1101290113500.19247@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

videobuf2-memops and videobuf2-core can be compiled as modules, in which
case 3 more symbols from videobuf2-memops.c have to be exported.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/videobuf2-memops.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-memops.c b/drivers/media/video/videobuf2-memops.c
index 053c157..a3eb656 100644
--- a/drivers/media/video/videobuf2-memops.c
+++ b/drivers/media/video/videobuf2-memops.c
@@ -77,6 +77,7 @@ void vb2_put_vma(struct vm_area_struct *vma)
 
 	kfree(vma);
 }
+EXPORT_SYMBOL_GPL(vb2_put_vma);
 
 /**
  * vb2_get_contig_userptr() - lock physically contiguous userspace mapped memory
@@ -141,6 +142,7 @@ done:
 	up_read(&mm->mmap_sem);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vb2_get_contig_userptr);
 
 /**
  * vb2_mmap_pfn_range() - map physical pages to userspace
@@ -180,6 +182,7 @@ int vb2_mmap_pfn_range(struct vm_area_struct *vma, unsigned long paddr,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vb2_mmap_pfn_range);
 
 /**
  * vb2_common_vm_open() - increase refcount of the vma
-- 
1.7.2.3

