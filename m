Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:65477 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbbETOGp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 10:06:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: y2038@lists.linaro.org
Cc: Tina Ruchandani <ruchandani.tina@gmail.com>,
	Shuah Khan <shuah.kh@samsung.com>,
	Akihiro Tsukada <tskd08@gmail.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [Y2038] [PATCH v2] [media] dvb-frontend: Replace timeval with ktime_t
Date: Wed, 20 May 2015 16:06:39 +0200
Message-ID: <287053272.pKmVI1JmAO@wuerfel>
In-Reply-To: <20150519082210.GA2998@tinar>
References: <20150519082210.GA2998@tinar>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 19 May 2015 13:52:10 Tina Ruchandani wrote:
> struct timeval uses a 32-bit seconds representation which will
> overflow in the year 2038 and beyond. This patch replaces
> the usage of struct timeval with ktime_t which is a 64-bit
> timestamp and is year 2038 safe.
> This patch is part of a larger attempt to remove all instances
> of 32-bit timekeeping variables (timeval, timespec, time_t)
> which are not year 2038 safe, from the kernel.

Ok.

> The patch is a work-in-progress - correctness of the following
> changes is unclear:
> (a) Usage of timeval_usec_diff - The function seems to subtract
> usec values without caring about the difference of the seconds field.
> There may be an implicit assumption in the original code that the
> time delta is always of the order of microseconds.
> The patch replaces the usage of timeval_usec_diff with
> ktime_to_us(ktime_sub()) which computes the real timestamp difference,
> not just the difference in the usec field.

Yes, I'm sure this is a safe assumption.

When you change the code to ktime_us_delta, please also update the
comment here.

> (b) printk diffing the tv[i] and tv[i-1] values. The original
> printk statement seems to get the order wrong. This patch preserves
> that order.

I also think that's ok, but it would be nice to split this out
as a separate patch that gets applied first, so just swap out the
arguments in the timeval_usec_diff() definition as preparation
and add an explanation why you think it was wrong.

> @@ -2489,7 +2469,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>  				printk("%s(%d): switch delay (should be 32k followed by all 8k\n",
>  					__func__, fe->dvb->num);
>  				for (i = 1; i < 10; i++)
> -					printk("%d: %d\n", i, timeval_usec_diff(tv[i-1] , tv[i]));
> +					printk("%d: %d\n", i, (int) ktime_to_us(ktime_sub(tv[i-1], tv[i])));

This can still be simplified using ktime_us_delta().

>  			stv0299_writeregI (state, 0x0c, reg0x0c | (last ? lv_mask : 0x50));
> @@ -443,7 +444,7 @@ static int stv0299_send_legacy_dish_cmd (struct dvb_frontend* fe, unsigned long
>  		printk ("%s(%d): switch delay (should be 32k followed by all 8k\n",
>  			__func__, fe->dvb->num);
>  		for (i = 1; i < 10; i++)
> -			printk ("%d: %d\n", i, timeval_usec_diff(tv[i-1] , tv[i]));
> +			printk("%d: %d\n", i, (int) ktime_to_us(ktime_sub(tv[i-1], tv[i])));
>  	}

This, too.

The patch looks correct to me now, so just do the cosmetic changes I
suggested above and submit a version 3.

	Arnd
