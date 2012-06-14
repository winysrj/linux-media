Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:63622 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2FNJDX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 05:03:23 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5L001HENTMMGU0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 18:03:22 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M5L004I3NTIPV80@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 18:03:22 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org
Cc: 'Hans Verkuil' <hverkuil@xs4all.nl>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>
References: <1339657861-22160-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1339657861-22160-1-git-send-email-a.hajda@samsung.com>
Subject: RE: [PATCH] v4l/s5p-mfc: added image size align in VIDIOC_TRY_FMT
Date: Thu, 14 Jun 2012 11:03:14 +0200
Message-id: <000001cd4a0c$8ac8f0a0$a05ad1e0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej, 

Thank you for the patch.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> -----Original Message-----
> From: Andrzej Hajda [mailto:a.hajda@samsung.com]
> Sent: 14 June 2012 09:11
> To: linux-media@vger.kernel.org
> Cc: Hans Verkuil; Marek Szyprowski; Kamil Debski; Andrzej Hajda; Kyungmin
> Park
> Subject: [PATCH] v4l/s5p-mfc: added image size align in VIDIOC_TRY_FMT
> 
> Image size for MFC encoder should have size between
> 8x4 and 1920x1080 with even width and height.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> index 9c19aa8..03d8334 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> @@ -901,6 +901,8 @@ static int vidioc_try_fmt(struct file *file, void
> *priv, struct v4l2_format *f)
>  			mfc_err("failed to try output format\n");
>  			return -EINVAL;
>  		}
> +		v4l_bound_align_image(&pix_fmt_mp->width, 8, 1920, 1,
> +			&pix_fmt_mp->height, 4, 1080, 1, 0);
>  	} else {
>  		mfc_err("invalid buf type\n");
>  		return -EINVAL;
> --
> 1.7.0.4

