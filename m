Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6I7egFa008318
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 03:40:42 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6I7eUP0025901
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 03:40:31 -0400
Date: Fri, 18 Jul 2008 09:40:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <20080714120204.4806.87287.sendpatchset@rx1.opensource.se>
Message-ID: <Pine.LNX.4.64.0807180940010.13569@axis700.grange>
References: <20080714120204.4806.87287.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, paulius.zaleckas@teltonika.lt,
	linux-sh@vger.kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
	lethal@linux-sh.org, akpm@linux-foundation.org
Subject: Re: [PATCH 00/06] soc_camera: SuperH Mobile CEU patches V3
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

On Mon, 14 Jul 2008, Magnus Damm wrote:

> This is V3 of the SuperH Mobile CEU interface patches.
> 
> [PATCH 01/06] soc_camera: Move spinlocks
> [PATCH 02/06] soc_camera: Add 16-bit bus width support
> [PATCH 03/06] videobuf: Fix gather spelling
> [PATCH 04/06] videobuf: Add physically contiguous queue code V3
> [PATCH 05/06] sh_mobile_ceu_camera: Add SuperH Mobile CEU driver V3
> [PATCH 06/06] soc_camera_platform: Add SoC Camera Platform driver
> 
> Changes since V2:
>  - use dma_handle for physical address for videobuf-dma-contig
>  - spell gather correctly
>  - remove SUPERH Kconfig dependency
>  - move sh_mobile_ceu.h to include/media
>  - add board callback support with enable_camera()/disable_camera()
>  - add support for declare_coherent_memory
>  - rework video memory limit
>  - more verbose error messages
>  - add soc_camera_platform driver for simple camera devices
> 
> Changes since V1:
>  - dropped former V1 patches [01/07]->[04/07]
>  - rebased on top of [PATCH] soc_camera: make videobuf independent
>  - rewrote spinlock changes into the new [01/04] patch
>  - updated the videobuf-dma-contig code with feeback from Paulius Zaleckas
>  - fixed the CEU driver to work with the newly updated patches
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---

Thanks, applied to soc-camera.

Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
