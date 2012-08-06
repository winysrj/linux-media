Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11508 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2HFNUM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 09:20:12 -0400
Received: from eusync3.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8C00FNC52D6J60@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Aug 2012 14:20:37 +0100 (BST)
Received: from AMDN157 ([106.116.147.102])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0M8C00NOJ51L5880@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Aug 2012 14:20:10 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kmpark@infradead.org, joshi@samsung.com
References: <1343046557-25353-1-git-send-email-arun.kk@samsung.com>
In-reply-to: <1343046557-25353-1-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH v3 0/4] update MFC v4l2 driver to support MFC6.x
Date: Mon, 06 Aug 2012 15:20:09 +0200
Message-id: <00f001cd73d6$3468a040$9d39e0c0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

First and very important remark. When you split your changes into multiple
patches please make sure that after applying every patch the kernel compiles.
It is important for such tools as git bisect.

When I apply "s5p-mfc: update MFC v4l2 driver to support MFC6.x" the kernel no
longer compiles. If you look at the patches it can be seen that the order is
wrong. First Kconfig is modified and it requires files added in further
patches.

More comments in reply to specific patches.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> -----Original Message-----
> From: Arun Kumar K [mailto:arun.kk@samsung.com]
> Sent: 23 July 2012 14:29
> To: linux-media@vger.kernel.org
> Cc: jtp.park@samsung.com; janghyuck.kim@samsung.com; jaeryul.oh@samsung.com;
> ch.naveen@samsung.com; arun.kk@samsung.com; m.szyprowski@samsung.com;
> k.debski@samsung.com; kmpark@infradead.org; joshi@samsung.com
> Subject: [PATCH v3 0/4] update MFC v4l2 driver to support MFC6.x
> 
> The patchset adds support for MFCv6 firmware in s5p-mfc driver.
> The original patch is split into 4 patches for easy review.
> This patchset have to be applied on patches [1] and [2] posted
> earlier which adds the required v4l2 controls.
> 
> Changelog
> - Supports MFCv5 and v6 co-existence.
> - Tested for encoding & decoding in MFCv5.
> - Supports only decoding in MFCv6 now.
> - Can be compiled with kernel image and as module.
> - Config macros for MFC version selection removed.
> - All previous review comments addressed.
> 
> [1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg48972.html
> [2] http://www.mail-archive.com/linux-media@vger.kernel.org/msg48973.html
> 
> Jeongtae Park (4):
>   [media] s5p-mfc: update MFC v4l2 driver to support MFC6.x
>   [media] s5p-mfc: Decoder and encoder common files
>   [media] s5p-mfc: Modified command and opr files for MFCv5
>   [media] s5p-mfc: New files for MFCv6 support
> 
>  drivers/media/video/Kconfig                  |    4 +-
>  drivers/media/video/s5p-mfc/Makefile         |    7 +-
>  drivers/media/video/s5p-mfc/regs-mfc-v6.h    |  392 ++++++
>  drivers/media/video/s5p-mfc/regs-mfc.h       |   33 +-
>  drivers/media/video/s5p-mfc/s5p_mfc.c        |  225 ++--
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd.c    |   98 +--
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd.h    |   13 +
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c |  164 +++
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.h |   22 +
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c |  155 +++
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.h |   22 +
>  drivers/media/video/s5p-mfc/s5p_mfc_common.h |  153 ++-
>  drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  198 ++-
>  drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h   |    1 +
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |  223 ++-
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.h    |    1 +
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |  200 ++--
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.h    |    1 +
>  drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |   11 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.c    | 1402 ++-----------------
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |  179 ++-
>  drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.c | 1767 +++++++++++++++++++++++
>  drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.h |   85 ++
>  drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c | 1921
++++++++++++++++++++++++++
>  drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h |   50 +
>  drivers/media/video/s5p-mfc/s5p_mfc_pm.c     |    8 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_shm.c    |   47 -
>  drivers/media/video/s5p-mfc/s5p_mfc_shm.h    |   90 --
>  28 files changed, 5605 insertions(+), 1867 deletions(-)
>  create mode 100644 drivers/media/video/s5p-mfc/regs-mfc-v6.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h
>  delete mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.c
>  delete mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.h

