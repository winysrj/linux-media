Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:53541 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933187Ab2HPTtD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 15:49:03 -0400
Received: by lagy9 with SMTP id y9so1684671lag.19
        for <linux-media@vger.kernel.org>; Thu, 16 Aug 2012 12:49:01 -0700 (PDT)
Message-ID: <502D4E9D.5010401@iki.fi>
Date: Thu, 16 Aug 2012 22:48:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "htl10@users.sourceforge.net" <htl10@users.sourceforge.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"joe@perches.com" <joe@perches.com>
Subject: Re: noisy dev_dbg_ratelimited()
References: <1344991485.62541.YahooMailClassic@web29404.mail.ird.yahoo.com><502AF5E3.7080405@iki.fi><502C48DC.9090303@iki.fi> <20120816.101228.1829061240257077271.hdoyu@nvidia.com>
In-Reply-To: <20120816.101228.1829061240257077271.hdoyu@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hiroshi

On 08/16/2012 10:12 AM, Hiroshi Doyu wrote:
> Hi Antti,
>
> Antti Palosaari <crope@iki.fi> wrote @ Thu, 16 Aug 2012 03:11:56 +0200:
>
>> Hello Hiroshi,
>>
>> I see you have added dev_dbg_ratelimited() recently, commit
>> 6ca045930338485a8cdef117e74372aa1678009d .
>>
>> However it seems to be noisy as expected similar behavior than normal
>> dev_dbg() without a ratelimit.
>>
>> I looked ratelimit.c and there is:
>> printk(KERN_WARNING "%s: %d callbacks suppressed\n", func, rs->missed);
>>
>> What it looks my eyes it will print those "callbacks suppressed" always
>> because KERN_WARNING.
>
> Right. Can the following fix the problem?

No. That silences dev_dbg_reatelimited() totally.
dev_dbg() works as expected printing all the debugs. But when I change 
it to dev_dbg_reatelimited() all printings are silenced.


>>From 905b1dedb6c64bc46a70f6d203ef98c23fccb107 Mon Sep 17 00:00:00 2001
> From: Hiroshi Doyu <hdoyu@nvidia.com>
> Date: Thu, 16 Aug 2012 10:02:11 +0300
> Subject: [PATCH 1/1] driver-core: Shut up dev_dbg_reatelimited() without
>   DEBUG
>
> dev_dbg_reatelimited() without DEBUG printed "217078 callbacks
> suppressed". This shouldn't print anything without DEBUG.
>
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> Reported-by: Antti Palosaari <crope@iki.fi>
> ---
>   include/linux/device.h |    6 +++++-
>   1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/device.h b/include/linux/device.h
> index eb945e1..d4dc26e 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -962,9 +962,13 @@ do {									\
>   	dev_level_ratelimited(dev_notice, dev, fmt, ##__VA_ARGS__)
>   #define dev_info_ratelimited(dev, fmt, ...)				\
>   	dev_level_ratelimited(dev_info, dev, fmt, ##__VA_ARGS__)
> +#if defined(DEBUG)
>   #define dev_dbg_ratelimited(dev, fmt, ...)				\
>   	dev_level_ratelimited(dev_dbg, dev, fmt, ##__VA_ARGS__)
> -
> +#else
> +#define dev_dbg_ratelimited(dev, fmt, ...)			\
> +	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
> +#endif
>   /*
>    * Stupid hackaround for existing uses of non-printk uses dev_info
>    *
>

regards
Antti

-- 
http://palosaari.fi/
