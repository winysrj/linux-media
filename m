Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454Ab2IXOOr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 10:14:47 -0400
Message-ID: <50606B26.6020406@redhat.com>
Date: Mon, 24 Sep 2012 16:16:06 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: elezegarcia@gmail.com
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/4] pwc: Add return code check at vb2_queue_init()
References: <1347889658-15116-1-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1347889658-15116-1-git-send-email-elezegarcia@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks I've added this to my media tree and it will be included in
my next pull-req to Mauro.

Regards,

Hans


On 09/17/2012 03:47 PM, elezegarcia@gmail.com wrote:
> From: Ezequiel Garcia <elezegarcia@gmail.com>
>
> This function returns an integer and it's mandatory
> to check the return code.
>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
>   drivers/media/usb/pwc/pwc-if.c |    4 +++-
>   1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
> index 42e36ba..31d082e 100644
> --- a/drivers/media/usb/pwc/pwc-if.c
> +++ b/drivers/media/usb/pwc/pwc-if.c
> @@ -1000,7 +1000,9 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
>   	pdev->vb_queue.buf_struct_size = sizeof(struct pwc_frame_buf);
>   	pdev->vb_queue.ops = &pwc_vb_queue_ops;
>   	pdev->vb_queue.mem_ops = &vb2_vmalloc_memops;
> -	vb2_queue_init(&pdev->vb_queue);
> +	rc = vb2_queue_init(&pdev->vb_queue);
> +	if (rc)
> +		goto err_free_mem;
>
>   	/* Init video_device structure */
>   	memcpy(&pdev->vdev, &pwc_template, sizeof(pwc_template));
>
