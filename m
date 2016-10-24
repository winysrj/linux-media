Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:34246 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753826AbcJXU0j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 16:26:39 -0400
Subject: Re: cron job: media_tree daily build: ERRORS
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <1b1055a59b35cd85bf39d3da86266798@smtp-cloud3.xs4all.net>
 <20161024182146.2be5b500@vento.lan>
Cc: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <538cb387-163b-5481-74be-1f1c9d3a1baa@xs4all.nl>
Date: Mon, 24 Oct 2016 22:26:33 +0200
MIME-Version: 1.0
In-Reply-To: <20161024182146.2be5b500@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've applied this patch to my smatch. Thanks for looking into this.

Regards,

	Hans

On 10/24/2016 10:21 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 24 Oct 2016 06:03:16 +0200
> "Hans Verkuil" <hverkuil@xs4all.nl> escreveu:
> 
>> This message is generated daily by a cron job that builds media_tree for
>> the kernels and architectures in the list below.
>>
>> Results of the daily build of media_tree:
> 
> ...
> 
>> sparse: WARNINGS
>>
>> Detailed results are available here:
>>
>> http://www.xs4all.nl/~hverkuil/logs/Monday.log
> 
> I'm noticing that you're getting lots of warnings like this one:
> 
> /home/hans/work/build/media-git/drivers/media/pci/bt8xx/bttv-driver.c:3847 bttv_irq() warn: invalid KERN_* level: KERN_SOH_ASCII followed by '\x63'
> 
> This warning is bogus, and it is result of a new implementation for 
> KERN_CONT.
> 
> Please apply the following patch to get rid of that on the daily builds.
> 
> Dan,
> 
> Could you also apply it (or some variant of it upstream), to avoid us
> the need of carry on this patch on our git trees?
> 
> Thanks,
> Mauro
> 
> check_kernel_printf: Ignore the new "continue" level
>     
> [PATCH] Suppress warnings like this one:
> 	drivers/media/rc/imon.c:1879 imon_get_ffdc_type() warn: invalid KERN_* level: KERN_SOH_ASCII followed by '\x63'
>     
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> diff --git a/check_kernel_printf.c b/check_kernel_printf.c
> index d0ca89e5bd61..a7ae4f2e1588 100644
> --- a/check_kernel_printf.c
> +++ b/check_kernel_printf.c
> @@ -807,10 +807,12 @@ check_format_string(const char *fmt, const char *caller)
>  			 * "%c...". printk explicitly supports
>  			 * this.
>  			 */
> +			if (f[1] == 'c')
> +				break;
>  			if (!(('0' <= f[1] && f[1] <= '7') ||
>  			      f[1] == 'd' ||
>  			      (f[1] == '%' && f[2] == 'c')))
> -				sm_msg("warn: invalid KERN_* level: KERN_SOH_ASCII followed by '\\x%02x'", (unsigned char)f[1]);
> +				sm_msg("warn: invalid KERN_* level: KERN_SOH_ASCII followed by 0x%02x ('%c')", (unsigned char)f[1], f[1]);
>  			break;
>  		case '\t':
>  		case '\n':
> 
