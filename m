Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933144Ab1KCSZy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Nov 2011 14:25:54 -0400
Message-ID: <4EB2DCAC.2060106@redhat.com>
Date: Thu, 03 Nov 2011 16:25:48 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-media@vger.kernel.org, Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [GIT PULL] More Samsung patches for v3.2
References: <1317913025-11534-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1317913025-11534-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-10-2011 11:57, Marek Szyprowski escreveu:
> Hello Mauro,
> 
> The following changes since commit 2f4cf2c3a971c4d5154def8ef9ce4811d702852d:
> 
>   [media] dib9000: release a lock on error (2011-09-30 13:32:56 -0300)
> 
> are available in the git repository at:
>   git://git.infradead.org/users/kmpark/linux-2.6-samsung for_mauro
> 
> Kamil Debski (2):
>       v4l: add G2D driver for s5p device family
>       v4l: s5p-mfc: fix reported capabilities

Not sure what happened, but the patches that came from the above are these, instead:

0001-media-vb2-add-a-check-for-uninitialized-buffer.patch
0002-media-vb2-set-buffer-length-correctly-for-all-buffer.patch
0003-media-vb2-reset-queued-list-on-REQBUFS-0-call.patch
0004-vb2-add-vb2_get_unmapped_area-in-vb2-core.patch
0005-v4l-add-G2D-driver-for-s5p-device-family.patch
0006-v4l-s5p-mfc-fix-reported-capabilities.patch
0007-MFC-Change-MFC-firmware-binary-name.patch
0008-v4l-Add-AUTO-option-for-the-V4L2_CID_POWER_LINE_FREQ.patch
0009-v4l-Add-v4l2-subdev-driver-for-S5K6AAFX-sensor.patch


> 
>  drivers/media/video/Kconfig               |    9 +
>  drivers/media/video/Makefile              |    2 +
>  drivers/media/video/s5p-g2d/Makefile      |    3 +
>  drivers/media/video/s5p-g2d/g2d-hw.c      |  106 ++++
>  drivers/media/video/s5p-g2d/g2d-regs.h    |  115 ++++
>  drivers/media/video/s5p-g2d/g2d.c         |  824 +++++++++++++++++++++++++++++
>  drivers/media/video/s5p-g2d/g2d.h         |   83 +++
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.c |    4 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.c |    4 +-
>  9 files changed, 1146 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/media/video/s5p-g2d/Makefile
>  create mode 100644 drivers/media/video/s5p-g2d/g2d-hw.c
>  create mode 100644 drivers/media/video/s5p-g2d/g2d-regs.h
>  create mode 100644 drivers/media/video/s5p-g2d/g2d.c
>  create mode 100644 drivers/media/video/s5p-g2d/g2d.h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

