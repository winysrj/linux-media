Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18888 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaIOOme (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 10:42:34 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBY007576BNA850@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Sep 2014 15:45:23 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Kiran AVND' <avnd.kiran@samsung.com>, linux-media@vger.kernel.org
Cc: wuchengli@chromium.org, posciak@chromium.org, arun.m@samsung.com,
	ihf@chromium.org, prathyush.k@samsung.com, arun.kk@samsung.com
References: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
 <1410763393-12183-4-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1410763393-12183-4-git-send-email-avnd.kiran@samsung.com>
Subject: RE: [PATCH 03/17] [media] s5p-mfc: set B-frames as 2 while encoding
Date: Mon, 15 Sep 2014 16:42:31 +0200
Message-id: <022a01cfd0f3$48185be0$d84913a0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Kiran AVND [mailto:avnd.kiran@samsung.com]
> Sent: Monday, September 15, 2014 8:43 AM
> 
> set default number of B-frames as 2 while encoding for better
> compression. This User can however change this setting using
> V4L2_CID_MPEG_VIDEO_B_FRAMES.

The last sentence should be rephrased, as it is not clear.

The tougher question is what should be the default?
In my opinion the default should produce a stream that is as
simple as it gets. It should be playable on most hardware,
some of which may not support B frames.

Anyway - this setting can be changed by the user to 2 using
V4L2_CID_MPEG_VIDEO_B_FRAMES ;)

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

> 
> Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> index cd1b2a2..f7a6f68 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
> @@ -280,7 +280,7 @@ static struct mfc_control controls[] = {
>  		.minimum = 0,
>  		.maximum = 2,
>  		.step = 1,
> -		.default_value = 0,
> +		.default_value = 2,
>  	},
>  	{
>  		.id = V4L2_CID_MPEG_VIDEO_H264_PROFILE,
> --
> 1.7.3.rc2

