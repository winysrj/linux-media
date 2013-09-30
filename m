Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1939 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab3I3MT6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 08:19:58 -0400
Message-ID: <52496C64.8090606@xs4all.nl>
Date: Mon, 30 Sep 2013 14:19:48 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
CC: linux-media@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] saa7134: Fix crash when device is closed before streamoff
References: <1379697328-9990-1-git-send-email-simon.farnsworth@onelan.co.uk>
In-Reply-To: <1379697328-9990-1-git-send-email-simon.farnsworth@onelan.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/2013 07:15 PM, Simon Farnsworth wrote:
> pm_qos_remove_request was not called on video_release, resulting in the PM
> core's list of requests being corrupted when the file handle was freed.
> 
> This has no immediate symptoms, but later in operation, the kernel will
> panic as the PM core dereferences a dangling pointer.
> 
> Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
> Cc: stable@vger.kernel.org

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
> 
> I didn't notice this when I first implemented the pm_qos_request as the
> userspace I was using always called streamoff before closing the
> device. I've since changed userspace components, and hit the kernel panic.
> 
>  drivers/media/pci/saa7134/saa7134-video.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
> index e12bbd8..fb60da8 100644
> --- a/drivers/media/pci/saa7134/saa7134-video.c
> +++ b/drivers/media/pci/saa7134/saa7134-video.c
> @@ -1455,6 +1455,7 @@ static int video_release(struct file *file)
>  
>  	/* stop video capture */
>  	if (res_check(fh, RESOURCE_VIDEO)) {
> +		pm_qos_remove_request(&dev->qos_request);
>  		videobuf_streamoff(&fh->cap);
>  		res_free(dev,fh,RESOURCE_VIDEO);
>  	}
> 

