Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:49388 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab3GKMP0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 08:15:26 -0400
Received: by mail-lb0-f178.google.com with SMTP id y6so6506858lbh.23
        for <linux-media@vger.kernel.org>; Thu, 11 Jul 2013 05:15:25 -0700 (PDT)
Message-ID: <51DEA1DA.5060706@cogentembedded.com>
Date: Thu, 11 Jul 2013 16:15:22 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 05/50] USB: misc: uss720: spin_lock in complete() cleanup
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com> <1373533573-12272-6-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1373533573-12272-6-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 11-07-2013 13:05, Ming Lei wrote:

> Complete() will be run with interrupt enabled, so change to
> spin_lock_irqsave().

> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>   drivers/usb/misc/uss720.c |    6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)

> diff --git a/drivers/usb/misc/uss720.c b/drivers/usb/misc/uss720.c
> index e129cf6..f7d15e8 100644
> --- a/drivers/usb/misc/uss720.c
> +++ b/drivers/usb/misc/uss720.c
> @@ -121,6 +121,7 @@ static void async_complete(struct urb *urb)
>   		dev_err(&urb->dev->dev, "async_complete: urb error %d\n",
>   			status);
>   	} else if (rq->dr.bRequest == 3) {
> +		unsigned long flags;

    Empty line wouldn't hurt here, after declaration.

>   		memcpy(priv->reg, rq->reg, sizeof(priv->reg));

WBR, Sergei


