Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:1581 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbZKLH3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 02:29:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: =?utf-8?q?N=C3=A9meth_M=C3=A1rton?= <nm127@freemail.hu>
Subject: Re: [PATCH] v4l2-dbg: report fail reason to the user
Date: Thu, 12 Nov 2009 08:29:40 +0100
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
References: <4AF6BA72.4070809@freemail.hu> <4AF8F8EB.8090705@freemail.hu> <4AFBB7FD.5090607@freemail.hu>
In-Reply-To: <4AFBB7FD.5090607@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200911120829.40193.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 12 November 2009 08:23:41 Németh Márton wrote:
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
> diff -r 60f784aa071d v4l2-apps/util/v4l2-dbg.cpp
> --- a/v4l2-apps/util/v4l2-dbg.cpp	Wed Nov 11 18:28:53 2009 +0100
> +++ b/v4l2-apps/util/v4l2-dbg.cpp	Thu Nov 12 08:21:20 2009 +0100
> @@ -353,14 +353,21 @@
>  static int doioctl(int fd, int request, void *parm, const char *name)
>  {
>  	int retVal;
> +	int ioctl_errno;
> 
>  	if (!options[OptVerbose]) return ioctl(fd, request, parm);
>  	retVal = ioctl(fd, request, parm);
> -	printf("%s: ", name);
> -	if (retVal < 0)
> -		printf("failed: %s\n", strerror(errno));
> -	else
> -		printf("ok\n");
> +	if (options[OptVerbose]) {
> +		/* Save errno because printf() may modify it */
> +		ioctl_errno = errno;
> +		printf("%s: ", name);
> +		if (retVal < 0)
> +			printf("failed: %s\n", strerror(errno));
> +		else
> +			printf("ok\n");

I'm an idiot for not realizing this when I did the first review, but this
can be done without making a copy of errno. Just do this:

	if (options[OptVerbose]) {
		if (retVal < 0)
			printf("%s: failed: %s\n", name, strerror(errno));
		else
			printf("%s: ok\n", name);

Much simpler :-)

Can you change this and post again? Then I'll add it to my pending pull
request.

Thanks,

	Hans

> +		/* Restore errno for caller's use */
> +		errno = ioctl_errno;
> +	}
> 
>  	return retVal;
>  }
> @@ -586,8 +593,8 @@
> 
>  				printf(" set to 0x%llx\n", set_reg.val);
>  			} else {
> -				printf("Failed to set register 0x%08llx value 0x%llx\n",
> -					set_reg.reg, set_reg.val);
> +				printf("Failed to set register 0x%08llx value 0x%llx: %s\n",
> +					set_reg.reg, set_reg.val, strerror(errno));
>  			}
>  			set_reg.reg++;
>  		}
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
