Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2832 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbZKIKQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 05:16:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: =?utf-8?q?N=C3=A9meth_M=C3=A1rton?= <nm127@freemail.hu>
Subject: Re: [PATCH] v4l2-dbg: report fail reason to the user
Date: Mon, 9 Nov 2009 11:16:06 +0100
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
References: <4AF6BA72.4070809@freemail.hu>
In-Reply-To: <4AF6BA72.4070809@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200911091116.06578.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 08 November 2009 13:32:50 Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> Report the fail reason to the user when writing a register even if
> the verbose mode is switched off.
> 
> Remove duplicated code ioctl() call which may cause different ioctl()
> function call in case of verbose and non verbose if not handled carefully.
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> diff -r 19c0469c02c3 v4l2-apps/util/v4l2-dbg.cpp
> --- a/v4l2-apps/util/v4l2-dbg.cpp	Sat Nov 07 15:51:01 2009 -0200
> +++ b/v4l2-apps/util/v4l2-dbg.cpp	Sun Nov 08 14:13:52 2009 +0100
> @@ -354,13 +354,14 @@
>  {
>  	int retVal;
> 
> -	if (!options[OptVerbose]) return ioctl(fd, request, parm);
>  	retVal = ioctl(fd, request, parm);
> -	printf("%s: ", name);
> -	if (retVal < 0)
> -		printf("failed: %s\n", strerror(errno));
> -	else
> -		printf("ok\n");
> +	if (options[OptVerbose]) {
> +		printf("%s: ", name);
> +		if (retVal < 0)
> +			printf("failed: %s\n", strerror(errno));

Strictly speaking if the printf two line back would produce an error, then
errno would now contain the errno from the printf and not from the ioctl.
So errno should be assigned to a local variable right after the ioctl.

Note that this was already a bug in the original code.

Note also that I fail to see any difference in the old vs the new code.

> +		else
> +			printf("ok\n");
> +	}
> 
>  	return retVal;
>  }
> @@ -586,8 +587,9 @@
> 
>  				printf(" set to 0x%llx\n", set_reg.val);
>  			} else {
> -				printf("Failed to set register 0x%08llx value 0x%llx\n",
> -					set_reg.reg, set_reg.val);
> +				printf("Failed to set register 0x%08llx value 0x%llx: "
> +					"%s\n",

Please keep this printf on one line. Yes, you get a checkpatch warning but
I'd rather have a slightly longer line than an ugly split line.

Regards,

	Hans

> +					set_reg.reg, set_reg.val, strerror(errno));
>  			}
>  			set_reg.reg++;
>  		}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
