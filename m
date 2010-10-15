Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:29760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876Ab0JOUQO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Oct 2010 16:16:14 -0400
Date: Fri, 15 Oct 2010 16:16:00 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 4/5] IR: ene_ir: add support for carrier reports
Message-ID: <20101015201600.GL9658@redhat.com>
References: <1287158799-21486-1-git-send-email-maximlevitsky@gmail.com>
 <1287158799-21486-5-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287158799-21486-5-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Oct 15, 2010 at 06:06:38PM +0200, Maxim Levitsky wrote:
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  drivers/media/IR/ene_ir.c |   37 +++++++++++++++++++++++++++++--------
>  1 files changed, 29 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/IR/ene_ir.c b/drivers/media/IR/ene_ir.c
> index 8639621..1962652 100644
> --- a/drivers/media/IR/ene_ir.c
> +++ b/drivers/media/IR/ene_ir.c
...
> @@ -209,13 +210,16 @@ void ene_rx_sense_carrier(struct ene_device *dev)
>  	dbg("RX: hardware carrier period = %02x", period);
>  	dbg("RX: hardware carrier pulse period = %02x", hperiod);
>  
> -
>  	carrier = 2000000 / period;
>  	duty_cycle = (hperiod * 100) / period;
>  	dbg("RX: sensed carrier = %d Hz, duty cycle %d%%",
> -							carrier, duty_cycle);
> -
> -	/* TODO: Send carrier & duty cycle to IR layer */
> +						carrier, duty_cycle);

Spacing is a bit odd here (random indent, no newline), but meh, looks sane
otherwise.

> +	if (dev->carrier_detect_enabled) {
> +		ev.carrier_report = true;
> +		ev.carrier = carrier;
> +		ev.duty_cycle = duty_cycle;
> +		ir_raw_event_store(dev->idev, &ev);
> +	}
>  }
>  
>  /* this enables/disables the CIR RX engine */

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

