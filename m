Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:63655 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2FNJD0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 05:03:26 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5L001HENTMMGU0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 18:03:25 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M5L004I3NTIPV80@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 14 Jun 2012 18:03:25 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org
Cc: 'Hans Verkuil' <hverkuil@xs4all.nl>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>
References: <1339657446-21916-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1339657446-21916-1-git-send-email-a.hajda@samsung.com>
Subject: RE: [PATCH] v4l/s5p-mfc: corrected encoder v4l control definitions
Date: Thu, 14 Jun 2012 11:03:14 +0200
Message-id: <000101cd4a0c$8c6366c0$a52a3440$%debski@samsung.com>
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
> Sent: 14 June 2012 09:04
> To: linux-media@vger.kernel.org
> Cc: Hans Verkuil; Marek Szyprowski; Kamil Debski; Andrzej Hajda; Kyungmin
> Park
> Subject: [PATCH] v4l/s5p-mfc: corrected encoder v4l control definitions
> 
> Patch corrects definition of H264 level control and
> changes bare numbers to enums in two other cases.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/video/s5p-mfc/s5p_mfc_enc.c |   10 ++--------
>  1 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> index acedb20..9c19aa8 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
> @@ -243,12 +243,6 @@ static struct mfc_control controls[] = {
>  		.minimum = V4L2_MPEG_VIDEO_H264_LEVEL_1_0,
>  		.maximum = V4L2_MPEG_VIDEO_H264_LEVEL_4_0,
>  		.default_value = V4L2_MPEG_VIDEO_H264_LEVEL_1_0,
> -		.menu_skip_mask = ~(
> -				(1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_1) |
> -				(1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_2) |
> -				(1 << V4L2_MPEG_VIDEO_H264_LEVEL_5_0) |
> -				(1 << V4L2_MPEG_VIDEO_H264_LEVEL_5_1)
> -				),
>  	},
>  	{
>  		.id = V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL,
> @@ -494,7 +488,7 @@ static struct mfc_control controls[] = {
>  		.type = V4L2_CTRL_TYPE_MENU,
>  		.minimum = V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_UNSPECIFIED,
>  		.maximum = V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_EXTENDED,
> -		.default_value = 0,
> +		.default_value = V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_UNSPECIFIED,
>  		.menu_skip_mask = 0,
>  	},
>  	{
> @@ -534,7 +528,7 @@ static struct mfc_control controls[] = {
>  		.type = V4L2_CTRL_TYPE_MENU,
>  		.minimum = V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE,
>  		.maximum = V4L2_MPEG_VIDEO_MPEG4_PROFILE_ADVANCED_SIMPLE,
> -		.default_value = 0,
> +		.default_value = V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE,
>  		.menu_skip_mask = 0,
>  	},
>  	{
> --
> 1.7.0.4

