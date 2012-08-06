Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63605 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2HFNUP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 09:20:15 -0400
Received: from eusync3.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8C0095S52HST70@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Aug 2012 14:20:41 +0100 (BST)
Received: from AMDN157 ([106.116.147.102])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0M8C00NOJ51L5880@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Aug 2012 14:20:13 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kmpark@infradead.org, joshi@samsung.com
References: <1343046557-25353-1-git-send-email-arun.kk@samsung.com>
 <1343046557-25353-2-git-send-email-arun.kk@samsung.com>
In-reply-to: <1343046557-25353-2-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH v3 1/4] [media] s5p-mfc: update MFC v4l2 driver to support
 MFC6.x
Date: Mon, 06 Aug 2012 15:20:12 +0200
Message-id: <00f201cd73d6$36371eb0$a2a55c10$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

Please find my comments below.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> From: Arun Kumar K [mailto:arun.kk@samsung.com]
> Sent: 23 July 2012 14:29
> 
> From: Jeongtae Park <jtp.park@samsung.com>
> 
> Multi Format Codec 6.x is a hardware video coding acceleration
> module fount in new Exynos5 SoC series.
> It is capable of handling a range of video codecs and this driver
> provides a V4L2 interface for video decoding and encoding.
> 
> This is the first patch in the series for MFCv6 support. The major
> changes done in this patch is for MFCv5 and MFCv6 co-existence
> in the same kernel image.
> 
> Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
> Singed-off-by: Janghyuck Kim <janghyuck.kim@samsung.com>
> Singed-off-by: Jaeryul Oh <jaeryul.oh@samsung.com>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Kamil Debski <k.debski@samsung.com>
> ---
>  drivers/media/video/Kconfig                  |    4 +-
>  drivers/media/video/s5p-mfc/Makefile         |    7 +-
>  drivers/media/video/s5p-mfc/regs-mfc.h       |   33 +-
>  drivers/media/video/s5p-mfc/s5p_mfc.c        |  225 +++--
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd.c    |   98 +--
>  drivers/media/video/s5p-mfc/s5p_mfc_cmd.h    |   13 +
>  drivers/media/video/s5p-mfc/s5p_mfc_common.h |  153 +++-
>  drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  198 +++--
>  drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h   |    1 +
>  drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |   11 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.c    | 1402
+++-----------------------
>  drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |  179 +++--
>  drivers/media/video/s5p-mfc/s5p_mfc_pm.c     |    8 +-
>  drivers/media/video/s5p-mfc/s5p_mfc_shm.c    |   47 -
>  drivers/media/video/s5p-mfc/s5p_mfc_shm.h    |   90 --
>  15 files changed, 756 insertions(+), 1713 deletions(-)
>  delete mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.c
>  delete mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.h
> 

[snip]

> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
> b/drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
> index 5ceebfe..2be0b64 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
> @@ -21,10 +21,23 @@ struct s5p_mfc_cmd_args {
>  	unsigned int	arg[MAX_H2R_ARG];

After applying all the patches MAX_H2R_ARG is defined in 3 places and
I think only the one in s5p_mfc_cmd.h is used. 

>  };

[snip]

> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> index e6217cb..8afda8d 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> @@ -12,1386 +12,276 @@

[snip]

> 
> -	s5p_mfc_set_dec_stream_buffer(ctx, 0, 0, 0);
> -	dev->curr_ctx = ctx->num;
> -	s5p_mfc_clean_ctx_int_flags(ctx);
> -	s5p_mfc_decode_one_frame(ctx, MFC_DEC_RES_CHANGE);
> +int s5p_mfc_get_warn_start(struct s5p_mfc_dev *dev)
> +{
> +	return s5p_mfc_ops->s5p_mfc_get_warn_start(dev);
>  }

I think that a callback is not necessary, a simple integer variable should
do the job. 

[snip]

