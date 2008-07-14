Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6EC232W003902
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 08:02:03 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.224])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6EC1XwS001053
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 08:01:52 -0400
Received: by rv-out-0506.google.com with SMTP id f6so5595959rvb.51
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 05:01:52 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Mon, 14 Jul 2008 21:02:04 +0900
Message-Id: <20080714120204.4806.87287.sendpatchset@rx1.opensource.se>
Cc: paulius.zaleckas@teltonika.lt, linux-sh@vger.kernel.org,
	mchehab@infradead.org, lethal@linux-sh.org,
	akpm@linux-foundation.org, g.liakhovetski@gmx.de
Subject: [PATCH 00/06] soc_camera: SuperH Mobile CEU patches V3
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

This is V3 of the SuperH Mobile CEU interface patches.

[PATCH 01/06] soc_camera: Move spinlocks
[PATCH 02/06] soc_camera: Add 16-bit bus width support
[PATCH 03/06] videobuf: Fix gather spelling
[PATCH 04/06] videobuf: Add physically contiguous queue code V3
[PATCH 05/06] sh_mobile_ceu_camera: Add SuperH Mobile CEU driver V3
[PATCH 06/06] soc_camera_platform: Add SoC Camera Platform driver

Changes since V2:
 - use dma_handle for physical address for videobuf-dma-contig
 - spell gather correctly
 - remove SUPERH Kconfig dependency
 - move sh_mobile_ceu.h to include/media
 - add board callback support with enable_camera()/disable_camera()
 - add support for declare_coherent_memory
 - rework video memory limit
 - more verbose error messages
 - add soc_camera_platform driver for simple camera devices

Changes since V1:
 - dropped former V1 patches [01/07]->[04/07]
 - rebased on top of [PATCH] soc_camera: make videobuf independent
 - rewrote spinlock changes into the new [01/04] patch
 - updated the videobuf-dma-contig code with feeback from Paulius Zaleckas
 - fixed the CEU driver to work with the newly updated patches

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/media/video/Kconfig                |   19 
 drivers/media/video/Makefile               |    3 
 drivers/media/video/pxa_camera.c           |   17 
 drivers/media/video/sh_mobile_ceu_camera.c |  657 ++++++++++++++++++++++++++++
 drivers/media/video/soc_camera.c           |   39 -
 drivers/media/video/soc_camera_platform.c  |  198 ++++++++
 drivers/media/video/videobuf-dma-contig.c  |  417 +++++++++++++++++
 drivers/media/video/videobuf-dma-sg.c      |    2 
 drivers/media/video/videobuf-vmalloc.c     |    2 
 include/media/sh_mobile_ceu.h              |   12 
 include/media/soc_camera.h                 |   12 
 include/media/soc_camera_platform.h        |   15 
 include/media/videobuf-dma-contig.h        |   32 +
 include/media/videobuf-dma-sg.h            |    2 
 include/media/videobuf-vmalloc.h           |    2 
 15 files changed, 1368 insertions(+), 61 deletions(-)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
