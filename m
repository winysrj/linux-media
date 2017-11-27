Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:5608 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752401AbdK0PL6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 10:11:58 -0500
Message-ID: <1511795153.25007.451.camel@linux.intel.com>
Subject: Re: [PATCH 7/8] [media] staging: atomisp: convert timestamps to
 ktime_t
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: y2038@lists.linaro.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 27 Nov 2017 17:05:53 +0200
In-Reply-To: <20171127132027.1734806-7-arnd@arndb.de>
References: <20171127132027.1734806-1-arnd@arndb.de>
         <20171127132027.1734806-7-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-11-27 at 14:19 +0100, Arnd Bergmann wrote:
> timespec overflows in 2038 on 32-bit architectures, and the
> getnstimeofday() suffers from possible time jumps, so the
> timestamps here are better done using ktime_get(), which has
> neither of those problems.
> 
> In case of ov2680, we don't seem to use the timestamp at
> all, so I just remove it.
> 

> +	ktime_t timedelay = ns_to_ktime(
>  		min((u32)abs(dev->number_of_steps) *
> DELAY_PER_STEP_NS,
> -		(u32)DELAY_MAX_PER_STEP_NS),
> -	};
> +		    (u32)DELAY_MAX_PER_STEP_NS));

Since you are touching this, it might make sense to convert to

min_t(u32, ...)

...and locate lines something like:

ktime_t timeday = ns_to_ktime(min_t(u32,
     param1,
     param2));

>From my pov will make readability better.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
