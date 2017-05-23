Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:49845 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762701AbdEWJU3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 05:20:29 -0400
Date: Tue, 23 May 2017 10:20:27 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 5/7] rc-core: ir-raw - leave the internals of rc_dev alone
Message-ID: <20170523092026.GA30040@gofer.mess.org>
References: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
 <149365501711.13489.17027324920634077369.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <149365501711.13489.17027324920634077369.stgit@zeus.hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 01, 2017 at 06:10:17PM +0200, David H�rdeman wrote:
> Replace the REP_DELAY value with a static value, which makes more sense.
> Automatic repeat handling in the input layer has no relevance for the drivers
> idea of "a long time".
> 
> Signed-off-by: David H�rdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/rc-ir-raw.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
> index ae7785c4fbe7..967ab9531e0a 100644
> --- a/drivers/media/rc/rc-ir-raw.c
> +++ b/drivers/media/rc/rc-ir-raw.c
> @@ -102,20 +102,18 @@ int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type)
>  	s64			delta; /* ns */
>  	DEFINE_IR_RAW_EVENT(ev);
>  	int			rc = 0;
> -	int			delay;
>  
>  	if (!dev->raw)
>  		return -EINVAL;
>  
>  	now = ktime_get();
>  	delta = ktime_to_ns(ktime_sub(now, dev->raw->last_event));
> -	delay = MS_TO_NS(dev->input_dev->rep[REP_DELAY]);
>  
>  	/* Check for a long duration since last event or if we're
>  	 * being called for the first time, note that delta can't
>  	 * possibly be negative.
>  	 */
> -	if (delta > delay || !dev->raw->last_type)
> +	if (delta > MS_TO_NS(500) || !dev->raw->last_type)
>  		type |= IR_START_EVENT;

So this is just a fail-safe to ensure that the IR decoders are reset after
a period of IR silence. The decoders should reset themselves anyway if they
receive a long space, so it's just belt and braces.

Why is a static value better? At least REP_DELAY can be changed from
user space.

Maybe we should do away with it.


Sean

>  	else
>  		ev.duration = delta;
