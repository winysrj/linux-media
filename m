Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0162.hostedemail.com ([216.40.44.162]:47432 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753557AbdGNJz2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 05:55:28 -0400
Message-ID: <1500026123.4457.66.camel@perches.com>
Subject: Re: [PATCH 13/14] iopoll: avoid -Wint-in-bool-context warning
From: Joe Perches <joe@perches.com>
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Date: Fri, 14 Jul 2017 02:55:23 -0700
In-Reply-To: <20170714093129.1366900-4-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de>
         <20170714093129.1366900-4-arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-07-14 at 11:31 +0200, Arnd Bergmann wrote:
> When we pass the result of a multiplication as the timeout, we
> can get a warning:
> 
> drivers/mmc/host/bcm2835.c:596:149: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
> drivers/mfd/arizona-core.c:247:195: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
> 
> This is easy to avoid by comparing the timeout to zero instead,
> making it a boolean expression.

Perhaps this is better as != 0 if the multiply is signed.

> diff --git a/include/linux/iopoll.h b/include/linux/iopoll.h
[]
> @@ -48,7 +48,8 @@
>  		(val) = op(addr); \
>  		if (cond) \
>  			break; \
> -		if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) { \
> +		if ((timeout_us) > 0 && \
> +		    ktime_compare(ktime_get(), timeout) > 0) { \
>  			(val) = op(addr); \
>  			break; \
>  		} \

etc...
