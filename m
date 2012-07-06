Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437Ab2GFCYi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 22:24:38 -0400
Message-ID: <4FF64C60.1070804@redhat.com>
Date: Thu, 05 Jul 2012 23:24:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Douglas Bagnall <douglas@paradise.net.nz>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Avoid sysfs oops when an rc_dev's raw device is absent
References: <4FE7AA34.8090304@paradise.net.nz>
In-Reply-To: <4FE7AA34.8090304@paradise.net.nz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 24-06-2012 21:00, Douglas Bagnall escreveu:
> For some reason, when the lirc daemon learns that a usb remote control
> has been unplugged, it wants to read the sysfs attributes of the
> disappearing device. This is useful for uncovering transient
> inconsistencies, but less so for keeping the system running when such
> inconsistencies exist.
> 
> Under some circumstances (like every time I unplug my dvb stick from
> my laptop), lirc catches an rc_dev whose raw event handler has been
> removed (presumably by ir_raw_event_unregister), and proceeds to
> interrogate the raw protocols supported by the NULL pointer.
> 
> This patch avoids the NULL dereference, and ignores the issue of how
> this state of affairs came about in the first place.

Please add your Signed-off-by: as described at:
	http://www.linuxtv.org/wiki/index.php/Development:_Submitting_Patches

> ---
>   drivers/media/rc/rc-main.c |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 6e16b09..58789c9 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -775,10 +775,12 @@ static ssize_t show_protocols(struct device *device,
>   	if (dev->driver_type == RC_DRIVER_SCANCODE) {
>   		enabled = dev->rc_map.rc_type;
>   		allowed = dev->allowed_protos;
> -	} else {
> +	} else if (dev->raw) {
>   		enabled = dev->raw->enabled_protocols;
>   		allowed = ir_raw_get_allowed_protocols();
>   	}
> +	else
> +		return -EINVAL;

The return code there should be -ENODEV, as the device got removed.

Regards,
Mauro
