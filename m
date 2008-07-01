Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m61CkaED005056
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 08:46:36 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.234])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m61CjU9n021241
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 08:46:24 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2164027rvb.51
	for <video4linux-list@redhat.com>; Tue, 01 Jul 2008 05:46:24 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Tue, 01 Jul 2008 21:46:38 +0900
Message-Id: <20080701124638.30446.81449.sendpatchset@rx1.opensource.se>
Cc: akpm@linux-foundation.org, lethal@linux-sh.org, mchehab@infradead.org,
	linux-sh@vger.kernel.org
Subject: [PATCH 00/07] soc_camera: SuperH Mobile CEU support
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

These patches add support for the SuperH Mobile CEU interface.

[PATCH 01/07] soc_camera: Remove default spinlock operations
[PATCH 02/07] soc_camera: Let the host select videobuf_queue type
[PATCH 03/07] soc_camera: Remove vbq_ops and msize
[PATCH 04/07] soc_camera: Remove unused file lock pointer
[PATCH 05/07] soc_camera: Add 16-bit bus width support
[PATCH 06/07] videobuf: Add physically contiguous queue code
[PATCH 07/07] sh_mobile_ceu_camera: Add SuperH Mobile CEU driver

The patches can be divided in 3 groups:
 - soc_camera - make videobuf_queue host specific + minor changes
 - videobuf - add support for physically contiguous memory buffers
 - new driver - add the SuperH Mobile CEU driver 

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/media/video/Kconfig                |   16 
 drivers/media/video/Makefile               |    2 
 drivers/media/video/pxa_camera.c           |   21 
 drivers/media/video/sh_mobile_ceu_camera.c |  622 ++++++++++++++++++++++++++++
 drivers/media/video/soc_camera.c           |   52 --
 drivers/media/video/videobuf-dma-contig.c  |  413 ++++++++++++++++++
 include/asm-sh/sh_mobile_ceu.h             |   10 
 include/media/soc_camera.h                 |   16 
 include/media/videobuf-dma-contig.h        |   39 +
 9 files changed, 1129 insertions(+), 62 deletions(-)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
