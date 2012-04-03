Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25599 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab2DCKpv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2012 06:45:51 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M1W006DEGJ5WT@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Apr 2012 11:45:05 +0100 (BST)
Received: from [106.116.48.223] by spt2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0M1W00AJOGKAAP@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Apr 2012 11:45:47 +0100 (BST)
Date: Tue, 03 Apr 2012 12:45:47 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH] [media] s5p-tv: Fix compiler warning in mixer_video.c file
In-reply-to: <1333440294-382-1-git-send-email-sachin.kamat@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	patches@linaro.org
Message-id: <4F7AD4DB.9040403@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
References: <1333440294-382-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin Kamat,
Thanks for the patch.
However, the patch is already a duplicate of

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/45756/focus=45752

Regards,
Tomasz Stanislawski

On 04/03/2012 10:04 AM, Sachin Kamat wrote:
> Fixes the following warning:
> 
> mixer_video.c:857:3: warning: format ‘%lx’ expects argument of type
> ‘long unsigned int’, but argument 5 has type ‘unsigned int’ [-Wformat]
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/video/s5p-tv/mixer_video.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
> index f7ca5cc..bb33d7c 100644
> --- a/drivers/media/video/s5p-tv/mixer_video.c
> +++ b/drivers/media/video/s5p-tv/mixer_video.c
> @@ -854,7 +854,7 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
>  	for (i = 0; i < fmt->num_subframes; ++i) {
>  		alloc_ctxs[i] = layer->mdev->alloc_ctx;
>  		sizes[i] = PAGE_ALIGN(planes[i].sizeimage);
> -		mxr_dbg(mdev, "size[%d] = %08lx\n", i, sizes[i]);
> +		mxr_dbg(mdev, "size[%d] = %08x\n", i, sizes[i]);
>  	}
>  
>  	if (*nbuffers == 0)

