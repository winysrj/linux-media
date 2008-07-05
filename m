Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m652raKp001047
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 22:53:36 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.173])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m652rOOB024013
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 22:53:24 -0400
Received: by wf-out-1314.google.com with SMTP id 25so1337595wfc.6
	for <video4linux-list@redhat.com>; Fri, 04 Jul 2008 19:53:23 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Sat, 05 Jul 2008 11:53:35 +0900
Message-Id: <20080705025335.27137.98068.sendpatchset@rx1.opensource.se>
Cc: paulius.zaleckas@teltonika.lt, linux-sh@vger.kernel.org,
	mchehab@infradead.org, lethal@linux-sh.org,
	akpm@linux-foundation.org, g.liakhovetski@gmx.de
Subject: [PATCH 00/04] soc_camera: SuperH Mobile CEU support V2
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

This is V2 of the SuperH Mobile CEU interface patches.

[PATCH 01/04] soc_camera: Move spinlocks
[PATCH 02/04] soc_camera: Add 16-bit bus width support
[PATCH 03/04] videobuf: Add physically contiguous queue code V2
[PATCH 04/04] sh_mobile_ceu_camera: Add SuperH Mobile CEU driver V2

Changes since V1:
 - dropped former V1 patches [01/07]->[04/07]
 - rebased on top of [PATCH] soc_camera: make videobuf independent
 - rewrote spinlock changes into the new [01/04] patch
 - updated the videobuf-dma-contig code with feeback from Paulius Zaleckas
 - fixed the CEU driver to work with the newly updated patches

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 Applies on top of 2.6.26-rc8-next-20080703 together with
 "[PATCH] soc_camera: make videobuf independent".

 drivers/media/video/Kconfig                |   13 
 drivers/media/video/Makefile               |    2 
 drivers/media/video/pxa_camera.c           |   17 
 drivers/media/video/sh_mobile_ceu_camera.c |  623 ++++++++++++++++++++++++++++
 drivers/media/video/soc_camera.c           |   39 -
 drivers/media/video/videobuf-dma-contig.c  |  417 ++++++++++++++++++
 include/asm-sh/sh_mobile_ceu.h             |   10 
 include/media/soc_camera.h                 |   12 
 include/media/videobuf-dma-contig.h        |   32 +
 9 files changed, 1108 insertions(+), 57 deletions(-)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
