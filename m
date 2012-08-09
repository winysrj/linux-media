Return-path: <linux-media-owner@vger.kernel.org>
Received: from softlayer.compulab.co.il ([50.23.254.55]:33616 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758254Ab2HINVE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Aug 2012 09:21:04 -0400
Message-ID: <5023B93A.8050707@compulab.co.il>
Date: Thu, 09 Aug 2012 16:20:58 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
MIME-Version: 1.0
To: Timo Kokkonen <timo.t.kokkonen@iki.fi>
CC: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] media: rc: Introduce RX51 IR transmitter driver
References: <1344516086-24615-1-git-send-email-timo.t.kokkonen@iki.fi> <1344516086-24615-2-git-send-email-timo.t.kokkonen@iki.fi>
In-Reply-To: <1344516086-24615-2-git-send-email-timo.t.kokkonen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/09/12 15:41, Timo Kokkonen wrote:
> This is the driver for the IR transmitter diode found on the Nokia
> N900 (also known as RX51) device. The driver is mostly the same as
> found in the original 2.6.28 based kernel that comes with the device.
> 
> The following modifications have been made compared to the original
> driver version:
> 
> - Adopt to the changes that has happen in the kernel during the past
>   five years, such as the change in the include paths
> 
> - The OMAP DM-timers require much more care nowadays. The timers need
>   to be enabled and disabled or otherwise many actions fail. Timers
>   must not be freed without first stopping them or otherwise the timer
>   cannot be requested again.
> 
> The code has been tested with sending IR codes with N900 device
> running Debian userland. The device receiving the codes was Anysee
> DVB-C USB receiver.
> 
> Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
> ---
>  drivers/media/rc/Kconfig   |   10 +
>  drivers/media/rc/Makefile  |    1 +
>  drivers/media/rc/ir-rx51.c |  496 ++++++++++++++++++++++++++++++++++++++++++++
>  drivers/media/rc/ir-rx51.h |   10 +

I think the file ir-rx51.h should be placed in include/media instead.

[...]

>  4 files changed, 517 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/rc/ir-rx51.c
>  create mode 100644 drivers/media/rc/ir-rx51.h

[...]

> diff --git a/drivers/media/rc/ir-rx51.h b/drivers/media/rc/ir-rx51.h
> new file mode 100644
> index 0000000..104aa89
> --- /dev/null
> +++ b/drivers/media/rc/ir-rx51.h
> @@ -0,0 +1,10 @@
> +#ifndef _LIRC_RX51_H
> +#define _LIRC_RX51_H
> +
> +struct lirc_rx51_platform_data {
> +	int pwm_timer;
> +
> +	int(*set_max_mpu_wakeup_lat)(struct device *dev, long t);
> +};
> +
> +#endif

-- 
Regards,
Igor.
