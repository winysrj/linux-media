Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:61434 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbZKYFcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 00:32:12 -0500
Message-ID: <4B0CC15E.8070605@freemail.hu>
Date: Wed, 25 Nov 2009 06:32:14 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab via Mercurial <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [hg:v4l-dvb] v4l2-dbg: report fail reason to the user
References: <E1NCz3Z-0003qs-Qe@mail.linuxtv.org>
In-Reply-To: <E1NCz3Z-0003qs-Qe@mail.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,
Patch from Mauro Carvalho Chehab wrote:
> The patch number 13472 was added via Mauro Carvalho Chehab <mchehab@redhat.com>
> to http://linuxtv.org/hg/v4l-dvb master development tree.
> 
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
> 
> If anyone has any objections, please let us know by sending a message to:
> 	Linux Media Mailing List <linux-media@vger.kernel.org>
> 
> ------
> 
> From: Mauro Carvalho Chehab  <mchehab@redhat.com>
> v4l2-dbg: report fail reason to the user
> 
> 
> Report the fail reason to the user when writing a register even if
> the verbose mode is switched off.
> 
> Remove duplicated code ioctl() call which may cause different ioctl()
> function call in case of verbose and non verbose if not handled carefully.
> 
> Priority: normal
> 
> [hverkuil@xs4all.nl: minor additional cleanup in doioctl()]
> [mchehab@redhat.com: As I've already applied the original version, apply the diff version now]
> Signed-off-by: Marton Nemeth <nm127@freemail.hu>
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> 
> ---
> 
>  v4l2-apps/util/v4l2-dbg.cpp |   17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff -r c1b0ff440683 -r 98a8e3a2b8b3 v4l2-apps/util/v4l2-dbg.cpp
> --- a/v4l2-apps/util/v4l2-dbg.cpp	Tue Nov 10 17:14:51 2009 +0100
> +++ b/v4l2-apps/util/v4l2-dbg.cpp	Tue Nov 24 15:18:02 2009 -0200
> @@ -354,14 +354,13 @@
>  {
>  	int retVal;
>  
> +	if (!options[OptVerbose]) return ioctl(fd, request, parm);
>  	retVal = ioctl(fd, request, parm);
> -	if (options[OptVerbose]) {
> -		printf("%s: ", name);
> -		if (retVal < 0)
> -			printf("failed: %s\n", strerror(errno));
> -		else
> -			printf("ok\n");
> -	}
> +	printf("%s: ", name);
> +	if (retVal < 0)
> +		printf("failed: %s\n", strerror(errno));
> +	else
> +		printf("ok\n");
>  
>  	return retVal;
>  }
> @@ -587,8 +586,8 @@
>  
>  				printf(" set to 0x%llx\n", set_reg.val);
>  			} else {
> -				printf("Failed to set register 0x%08llx value 0x%llx: %s\n",
> -					set_reg.reg, set_reg.val, strerror(errno));
> +				printf("Failed to set register 0x%08llx value 0x%llx\n",
> +					set_reg.reg, set_reg.val);
>  			}
>  			set_reg.reg++;
>  		}
> 
> 
> ---
> 
> Patch is available at: http://linuxtv.org/hg/v4l-dvb/rev/98a8e3a2b8b39732055f03533acf9aa8d0c896c2
> 
> 

Do you really want this patch? It does the opposite what the comment says: when
the verbose mode is switched off, strerror(errno) is not printed at all.
Actually this reverts changeset 13405:65a25dd73390 as far as I can see:

http://linuxtv.org/hg/v4l-dvb/log/98a8e3a2b8b3/v4l2-apps/util/v4l2-dbg.cpp

Regards,

	Márton Németh

