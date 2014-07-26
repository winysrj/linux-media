Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58205 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbaGZLIL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 07:08:11 -0400
Message-ID: <53D38C14.40501@iki.fi>
Date: Sat, 26 Jul 2014 14:08:04 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] rc-core: don't use dynamic_pr_debug for IR_dprintk()
References: <1406341536-14418-1-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1406341536-14418-1-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/26/2014 05:25 AM, Mauro Carvalho Chehab wrote:
> The hole point of IR_dprintk() is that, once a level is
> given at debug parameter, all enabled IR parsers will show their
> debug messages.
>
> While converting it to dynamic_printk might be a good idea,
> right now it just makes very hard to debug the drivers, as
> one needs to both pass debug=1 or debug=2 to rc-core and
> to use the dynamic printk to enable all the desired lines.

Did you know you could enable debugs as whole module too? Also per 
function or source file, not only per line you seems to use.

That is basic command to enable all debugs for module rc-core
modprobe rc-core; echo -n 'module rc-core +p' > 
/sys/kernel/debug/dynamic_debug/control

Look also other flags than '+p' from documentation
Documentation/dynamic-debug-howto.txt


> That doesn't make sense!
>
> So, revert to the old way, as a single line is changed,
> and the debug parameter will now work as expected.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>   include/media/rc-core.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index 3047837db1cc..2c7fbca40b69 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -26,7 +26,7 @@ extern int rc_core_debug;
>   #define IR_dprintk(level, fmt, ...)				\
>   do {								\
>   	if (rc_core_debug >= level)				\
> -		pr_debug("%s: " fmt, __func__, ##__VA_ARGS__);	\
> +		printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__);	\
>   } while (0)
>
>   enum rc_driver_type {
>

-- 
http://palosaari.fi/
