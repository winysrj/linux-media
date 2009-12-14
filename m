Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbZLNN3y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2009 08:29:54 -0500
Message-ID: <4B263DB4.8050705@redhat.com>
Date: Mon, 14 Dec 2009 11:29:24 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS, 2.6.16-2.6.21:
 ERRORS
References: <200912131922.nBDJMMUm030337@smtp-vbr6.xs4all.nl>	<4B2552A4.5090901@freemail.hu> <20091214093730.75a5a0a2@tele>
In-Reply-To: <20091214093730.75a5a0a2@tele>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois Moine wrote:
> On Sun, 13 Dec 2009 21:46:28 +0100
> Németh Márton <nm127@freemail.hu> wrote:
> 
>> It seems that kernels before 2.6.24 (inclusively) do not have
>> "__devinitconst", so  conex.c and etoms.c can only build with 2.6.25
>> and later. Should USB_GSPCA_CONEX and USB_GSPCA_ETOMS be added to
>> v4l/versions.txt?
> 
> The fix is not the right one. Some other gspca subdrivers use
> "__devinitconst" (pac7302, pac7311, sonixb and spca506). The fix is to
> define the macro for kernels < 2.6.25:
> 
> diff -r 174ad3097f17 linux/drivers/media/video/gspca/gspca.h
> --- a/linux/drivers/media/video/gspca/gspca.h   Sun Dec 13 18:11:07
> 2009 +0100
> +++ b/linux/drivers/media/video/gspca/gspca.h   Mon Dec 14 09:28:51
> 2009 +0100 @@ -11,6 +11,10 @@ /* compilation option */
>  #define GSPCA_DEBUG 1
>  
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 25)
> +#define __devinitconst __section(.devinit.rodata)
> +#endif
> +

Better to add it at v4l/compat.h, to avoid polluting the drivers with
compat code.

Cheers
Mauro
