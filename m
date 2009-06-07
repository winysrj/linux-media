Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60508 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbZFGNv4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2009 09:51:56 -0400
Message-ID: <4A2BE212.2070009@redhat.com>
Date: Sun, 07 Jun 2009 17:51:46 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Lennart Poettering <mzxreary@0pointer.de>
CC: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] V4L/pwc - use usb_interface as parent, not usb_device
References: <20090604191813.GA6281@tango.0pointer.de>
In-Reply-To: <20090604191813.GA6281@tango.0pointer.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks good, we recently fixed the same issue in the gspca driver to,

Acked-by: Hans de Goede <hdegoede@redhat.com>

On 06/04/2009 09:18 PM, Lennart Poettering wrote:
> The current code creates a sysfs device path where the video4linux
> device is child of the usb device itself instead of the interface it
> belongs to. That is evil and confuses udev.
>
> This patch does basically the same thing as Kay's similar patch for the
> ov511 driver:
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ce96d0a44a4f8d1bb3dc12b5e98cb688c1bc730d
>
> (Resent 2nd time, due to missing Signed-off-by)
>
> Lennart
>
> Signed-off-by: Lennart Poettering<mzxreary@0pointer.de>
> ---
>   drivers/media/video/pwc/pwc-if.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
> index 7c542ca..92d4177 100644
> --- a/drivers/media/video/pwc/pwc-if.c
> +++ b/drivers/media/video/pwc/pwc-if.c
> @@ -1783,7 +1783,7 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
>   		return -ENOMEM;
>   	}
>   	memcpy(pdev->vdev,&pwc_template, sizeof(pwc_template));
> -	pdev->vdev->parent =&(udev->dev);
> +	pdev->vdev->parent =&intf->dev;
>   	strcpy(pdev->vdev->name, name);
>   	video_set_drvdata(pdev->vdev, pdev);
>
