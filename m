Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:61334 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab3GKMSW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 08:18:22 -0400
Received: by mail-la0-f47.google.com with SMTP id fe20so6735626lab.34
        for <linux-media@vger.kernel.org>; Thu, 11 Jul 2013 05:18:20 -0700 (PDT)
Message-ID: <51DEA289.5050509@cogentembedded.com>
Date: Thu, 11 Jul 2013 16:18:17 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Juergen Stuber <starblue@users.sourceforge.net>
Subject: Re: [PATCH 08/50] USB: legousbtower: spin_lock in complete() cleanup
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com> <1373533573-12272-9-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1373533573-12272-9-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 11-07-2013 13:05, Ming Lei wrote:

> Complete() will be run with interrupt enabled, so change to
> spin_lock_irqsave().

> Cc: Juergen Stuber <starblue@users.sourceforge.net>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>   drivers/usb/misc/legousbtower.c |    5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)

> diff --git a/drivers/usb/misc/legousbtower.c b/drivers/usb/misc/legousbtower.c
> index 8089479..4044989 100644
> --- a/drivers/usb/misc/legousbtower.c
> +++ b/drivers/usb/misc/legousbtower.c
> @@ -771,6 +771,7 @@ static void tower_interrupt_in_callback (struct urb *urb)
>   	struct lego_usb_tower *dev = urb->context;
>   	int status = urb->status;
>   	int retval;
> +	unsigned long flags;
>
>   	dbg(4, "%s: enter, status %d", __func__, status);
>
> @@ -788,7 +789,7 @@ static void tower_interrupt_in_callback (struct urb *urb)
>   	}
>
>   	if (urb->actual_length > 0) {
> -		spin_lock (&dev->read_buffer_lock);
> +		spin_lock_irqsave (&dev->read_buffer_lock, flags);
>   		if (dev->read_buffer_length + urb->actual_length < read_buffer_size) {
>   			memcpy (dev->read_buffer + dev->read_buffer_length,
>   				dev->interrupt_in_buffer,
> @@ -799,7 +800,7 @@ static void tower_interrupt_in_callback (struct urb *urb)
>   		} else {
>   			printk(KERN_WARNING "%s: read_buffer overflow, %d bytes dropped", __func__, urb->actual_length);
>   		}
> -		spin_unlock (&dev->read_buffer_lock);
> +		spin_unlock_irqrestore (&dev->read_buffer_lock, flags);
>   	}

    I don't think this patch passes checkpatch.pl.

WBR, Sergei


