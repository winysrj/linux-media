Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19086 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab2GINJJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2012 09:09:09 -0400
Received: from eusync1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6W00FXE9W1IR20@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Jul 2012 14:09:37 +0100 (BST)
Received: from AMDN157 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0M6W00LGU9V5L340@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Jul 2012 14:09:07 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	hans.verkuil@cisco.com, mchehab@infradead.org
References: <1341583217-11305-1-git-send-email-arun.kk@samsung.com>
In-reply-to: <1341583217-11305-1-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH v2 0/2] update MFC v4l2 driver to support MFC6.x
Date: Mon, 09 Jul 2012 15:09:05 +0200
Message-id: <005901cd5dd4$0577ce40$10676ac0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

First of all you have not addressed all the comments presented in the
previous conversation about this patch.

Look here:
http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/4519
7
--------------------
> +#define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */

Note that these new formats need to be documented in the spec as well.
(Hint: Documentation/DocBook/media/v4l)
--------------------

I agree with Hans here - you need to describe the new format in the
documentation. Without it the patch will not get accepted.

Also, you have just removed all the new controls introduced in that patch.
This is not the way to go, especially when your code uses these controls.

For example in s5p_mfc_opr_v6.c:962 you use the following control:
V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_INTERLEAVED_SLICES

I cannot find it in the videodev2.h you have posted. (also remember
that drivers/media/video/v4l2-ctrls.c has to be updated as well).

This means that if I compile for Exynos5 (v6) I will still get errors.

Also, your modification to Makefile are wrong. It will work if MFC is
built into the kernel image. If I choose to build it as a module it
does not compile.

Best regards,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> -----Original Message-----
> From: Arun Kumar K [mailto:arun.kk@samsung.com]
> Sent: 06 July 2012 16:00
> To: linux-media@vger.kernel.org
> Cc: jtp.park@samsung.com; janghyuck.kim@samsung.com;
> jaeryul.oh@samsung.com; ch.naveen@samsung.com; arun.kk@samsung.com;
> m.szyprowski@samsung.com; k.debski@samsung.com; s.nawrocki@samsung.com;
> hans.verkuil@cisco.com; mchehab@infradead.org
> Subject: [PATCH v2 0/2] update MFC v4l2 driver to support MFC6.x
> 
> This is the v2 series of patches for adding support for MFC v6.x.
> In this the new v4l controls added in patch [1] are removed. These can be
> added as a separate patch later for providing extra encoder controls for
> MFC v6. This also incorporates the review comments received for the
> original
> patch and fixed for backward compatibility with MFC v5.
> 
> [1] http://article.gmane.org/gmane.linux.drivers.video-input-
> infrastructure/45190/
> 
> Jeongtae Park (2):
>   [media] v4l: add fourcc definitions for new formats
>   [media] s5p-mfc: update MFC v4l2 driver to support MFC6.x
> 
>  drivers/media/video/Kconfig                  |   16 +-
>  drivers/media/video/s5p-mfc/Makefile         |    7 +-
>  drivers/media/video/s5p-mfc/regs-mfc-v6.h    |  676 ++++++++++
>  drivers/media/video/s5p-mfc/regs-mfc.h       |   29 +
>  drivers/media/video/s5p-mfc/s5p_mfc.c        |  163 ++-
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd.c    |    6 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd.h    |    3 +
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c |   96 ++
>  drivers/media/video/s5p-mfc/s5p_mfc_common.h |  123 ++-
>  drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  160 ++-
>  drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h   |    1 +
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |  210 +++-
>  drivers/media/video/s5p-mfc/s5p_mfc_dec.h    |    1 +
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |  191 ++--
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.h    |    1 +
>  drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |    1 -
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.c    |  278 +++--
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |   25 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c | 1697
> ++++++++++++++++++++++++++
>  drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h |  140 +++
>  drivers/media/video/s5p-mfc/s5p_mfc_pm.c     |    6 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_shm.c    |   28 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_shm.h    |   13 +-
>  drivers/media/video/v4l2-ctrls.c             |    1 -
>  include/linux/videodev2.h                    |    4 +
>  25 files changed, 3480 insertions(+), 396 deletions(-)
>  create mode 100644 drivers/media/video/s5p-mfc/regs-mfc-v6.h
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c
>  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h

