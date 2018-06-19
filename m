Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:50525 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937592AbeFSMIO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 08:08:14 -0400
Received: by mail-wm0-f65.google.com with SMTP id e16-v6so19492473wmd.0
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2018 05:08:14 -0700 (PDT)
Message-ID: <1529410092.28510.20.camel@baylibre.com>
Subject: Re: [1/3] media: rc: drivers should produce alternate pulse and
 space timing events
From: Jerome Brunet <jbrunet@baylibre.com>
To: Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Date: Tue, 19 Jun 2018 14:08:12 +0200
In-Reply-To: <20180512105531.30482-1-sean@mess.org>
References: <20180512105531.30482-1-sean@mess.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2018-05-12 at 11:55 +0100, Sean Young wrote:
> Report an error if this is not the case or any problem with the generated
> raw events.

Hi,

Since the inclusion of this patch, every 3 to 15 seconds, I get the following
message: 

 "rc rc0: two consecutive events of type space"

on the console of amlogic s400 platform (arch/arm64/boot/dts/amlogic/meson-axg-
s400.dts). I don't know much about ir protocol and surely there is something
worth investigating in the related driver, but ...

> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/rc-ir-raw.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
> index 2e50104ae138..49c56da9bc67 100644
> --- a/drivers/media/rc/rc-ir-raw.c
> +++ b/drivers/media/rc/rc-ir-raw.c
> @@ -22,16 +22,27 @@ static int ir_raw_event_thread(void *data)
>  {
>  	struct ir_raw_event ev;
>  	struct ir_raw_handler *handler;
> -	struct ir_raw_event_ctrl *raw = (struct ir_raw_event_ctrl *)data;
> +	struct ir_raw_event_ctrl *raw = data;
> +	struct rc_dev *dev = raw->dev;
>  
>  	while (1) {
>  		mutex_lock(&ir_raw_handler_lock);
>  		while (kfifo_out(&raw->kfifo, &ev, 1)) {
> +			if (is_timing_event(ev)) {
> +				if (ev.duration == 0)
> +					dev_err(&dev->dev, "nonsensical timing event of duration 0");
> +				if (is_timing_event(raw->prev_ev) &&
> +				    !is_transition(&ev, &raw->prev_ev))
> +					dev_err(&dev->dev, "two consecutive events of type %s",
> +						TO_STR(ev.pulse));
> +				if (raw->prev_ev.reset && ev.pulse == 0)
> +					dev_err(&dev->dev, "timing event after reset should be pulse");
> +			}

... considering that we continue the processing as if nothing happened, is it
really an error ? 

Could we consider something less invasive ? like dev_dbg() or dev_warn_once() ?

>  			list_for_each_entry(handler, &ir_raw_handler_list, list)
> -				if (raw->dev->enabled_protocols &
> +				if (dev->enabled_protocols &
>  				    handler->protocols || !handler->protocols)
> -					handler->decode(raw->dev, ev);
> -			ir_lirc_raw_event(raw->dev, ev);
> +					handler->decode(dev, ev);
> +			ir_lirc_raw_event(dev, ev);
>  			raw->prev_ev = ev;
>  		}
>  		mutex_unlock(&ir_raw_handler_lock);
