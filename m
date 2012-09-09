Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591Ab2IIV4C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Sep 2012 17:56:02 -0400
Message-ID: <504D10B9.2010406@redhat.com>
Date: Sun, 09 Sep 2012 23:57:13 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 02/10] pwc: Remove unneeded struct vb2_queue clearing
References: <1345727311-27478-1-git-send-email-elezegarcia@gmail.com> <1345727311-27478-2-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1345727311-27478-2-git-send-email-elezegarcia@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks! Applied to my gspca / media / pwc tree and included in my pull-req for 3.7 which I just send out.

Regards,

Hans


On 08/23/2012 03:08 PM, Ezequiel Garcia wrote:
> struct vb2_queue is allocated through kzalloc as part of a larger struct,
> there's no need to clear it.
>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
>   drivers/media/usb/pwc/pwc-if.c |    1 -
>   1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
> index de7c7ba..825c61a 100644
> --- a/drivers/media/usb/pwc/pwc-if.c
> +++ b/drivers/media/usb/pwc/pwc-if.c
> @@ -994,7 +994,6 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
>   	pdev->power_save = my_power_save;
>
>   	/* Init videobuf2 queue structure */
> -	memset(&pdev->vb_queue, 0, sizeof(pdev->vb_queue));
>   	pdev->vb_queue.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>   	pdev->vb_queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
>   	pdev->vb_queue.drv_priv = pdev;
>
