Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48928 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab2JDNUk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 09:20:40 -0400
Received: from eusync2.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBD00BS5EEYZX20@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 14:20:58 +0100 (BST)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MBD000HTEEDUU10@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 14:20:38 +0100 (BST)
Message-id: <506D8D24.3090209@samsung.com>
Date: Thu, 04 Oct 2012 15:20:36 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media@vger.kernel.org, k.debski@samsung.com,
	joshi@samsung.com
Subject: Re: [PATCH] [media] s5p-mfc: Set vfl_dir for encoder
References: <1349378096-15696-1-git-send-email-arun.kk@samsung.com>
In-reply-to: <1349378096-15696-1-git-send-email-arun.kk@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/04/2012 09:14 PM, Arun Kumar K wrote:
> The vfl_dir flag is presently set to VFL_DIR_M2M only for decoder.
> The encoder is not working because of this. So adding this flag
> to the encoder part also.
> 
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index aa55133..130f4ac 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -1155,6 +1155,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
>  	vfd->release	= video_device_release,
>  	vfd->lock	= &dev->mfc_mutex;
>  	vfd->v4l2_dev	= &dev->v4l2_dev;
> +	vfd->vfl_dir	= VFL_DIR_M2M;
>  	snprintf(vfd->name, sizeof(vfd->name), "%s", S5P_MFC_ENC_NAME);
>  	dev->vfd_enc	= vfd;
>  	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);

I have added it to my tree, will send out to Mauro together with
your v10 of the patch series adding MFC v6 firmware support, with
Kamil's Ack.

--

Thanks,
Sylwester
