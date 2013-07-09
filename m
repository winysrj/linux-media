Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25874 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3GIPdT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jul 2013 11:33:19 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MPO00CNPDMJDPA0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Jul 2013 16:33:17 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Mateusz Krawczuk' <m.krawczuk@samsung.com>,
	linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.local>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
References: <51D6781A.2000202@samsung.com>
In-reply-to: <51D6781A.2000202@samsung.com>
Subject: RE: [PATCH] media: s5p-tv: Fix Warn on driver probe
Date: Tue, 09 Jul 2013 17:32:29 +0200
Message-id: <02c601ce7cb9$87063cd0$9512b670$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mateusz,

Thank you for this patch. However if you set timestamp type to monotonic it
is necessary for the driver to set the timestamp value.

You can use the v4l2_get_timestamp helper to set the timestamp. According
to the documentation it should be set to the time when the first data byte
was sent to hardware.

Here you can find more information on how the timestamp field should be
handled in drivers https://patchwork.linuxtv.org/patch/18813/

Best wishes,
-- 
Kamil Debski
Linux Kernel Developer
Samsung R&D Institute Poland


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Mateusz Krawczuk
> Sent: Friday, July 05, 2013 9:39 AM
> To: linux-media@vger.kernel.org
> Subject: [PATCH] media: s5p-tv: Fix Warn on driver probe
> 
>  From 2cbf0f259fe24d0e3fe9f5b45036dcae3ffb6213 Mon Sep 17 00:00:00 2001
> From: Mateusz Krawczuk<m.krawczuk@samsung.com>
> Date: Wed, 3 Jul 2013 14:51:45 +0200
> Subject: [PATCH] media: s5p-tv: Fix Warn on driver probe
> 
> The timestamp_type field in struct vb2_queue wasn`t initalized at s5p-
> tv probe.
> This caused warn on message at boot. This patch fixed this issue.
> 
> Signed-off-by: Mateusz Krawczuk<m.krawczuk@partner.samsung.com>
> Acked-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
> ---
>   drivers/media/platform/s5p-tv/mixer_video.c |    1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/s5p-tv/mixer_video.c
> b/drivers/media/platform/s5p-tv/mixer_video.c
> index 641b1f0..87e3b0a 100644
> --- a/drivers/media/platform/s5p-tv/mixer_video.c
> +++ b/drivers/media/platform/s5p-tv/mixer_video.c
> @@ -1125,6 +1125,7 @@ struct mxr_layer *mxr_base_layer_create(struct
> mxr_device *mdev,
>   		.buf_struct_size = sizeof(struct mxr_buffer),
>   		.ops = &mxr_video_qops,
>   		.mem_ops = &vb2_dma_contig_memops,
> +		.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC,
>   	};
> 
>   	return layer;
> -- 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html


