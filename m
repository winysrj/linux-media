Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850Ab2HIL1c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Aug 2012 07:27:32 -0400
Message-ID: <50239EDC.9010105@redhat.com>
Date: Thu, 09 Aug 2012 13:28:28 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] pwc: Use vb2 queue mutex through a single name
References: <1342332033-30250-1-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1342332033-30250-1-git-send-email-elezegarcia@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the patch, I've added it to my tree for 3.7:
http://git.linuxtv.org/hgoede/gspca.git/shortlog/refs/heads/media-for_v3.7-wip

Regards,

Hans


On 07/15/2012 08:00 AM, Ezequiel Garcia wrote:
> This lock was being taken using two different names
> (pointers) in the same function.
> Both names refer to the same lock,
> so this wasn't an error; but it looked very strange.
>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
>   drivers/media/video/pwc/pwc-if.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
> index de7c7ba..b5d0729 100644
> --- a/drivers/media/video/pwc/pwc-if.c
> +++ b/drivers/media/video/pwc/pwc-if.c
> @@ -1127,7 +1127,7 @@ static void usb_pwc_disconnect(struct usb_interface *intf)
>   	v4l2_device_disconnect(&pdev->v4l2_dev);
>   	video_unregister_device(&pdev->vdev);
>   	mutex_unlock(&pdev->v4l2_lock);
> -	mutex_unlock(pdev->vb_queue.lock);
> +	mutex_unlock(&pdev->vb_queue_lock);
>
>   #ifdef CONFIG_USB_PWC_INPUT_EVDEV
>   	if (pdev->button_dev)
>
