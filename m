Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:63285 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbZEMRSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2009 13:18:15 -0400
Received: by ey-out-2122.google.com with SMTP id 9so237645eyd.37
        for <linux-media@vger.kernel.org>; Wed, 13 May 2009 10:18:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200905122058.n4CKwg2m004390@imap1.linux-foundation.org>
References: <200905122058.n4CKwg2m004390@imap1.linux-foundation.org>
Date: Wed, 13 May 2009 21:18:14 +0400
Message-ID: <208cbae30905131018i5a761224ued35bf79e0abfac5@mail.gmail.com>
Subject: Re: [patch 1/4] radio-mr800.c: missing mutex include
From: Alexey Klimov <klimov.linux@gmail.com>
To: akpm@linux-foundation.org
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	abogani@texware.it
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wed, May 13, 2009 at 12:39 AM,  <akpm@linux-foundation.org> wrote:
> From: Alessio Igor Bogani <abogani@texware.it>
>
> radio-mr800.c uses struct mutex, so while <linux/mutex.h> seems to be
> pulled in indirectly by one of the headers it already includes, the right
> thing is to include it directly.
>
> Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  drivers/media/radio/radio-mr800.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff -puN drivers/media/radio/radio-mr800.c~radio-mr800c-missing-mutex-include drivers/media/radio/radio-mr800.c
> --- a/drivers/media/radio/radio-mr800.c~radio-mr800c-missing-mutex-include
> +++ a/drivers/media/radio/radio-mr800.c
> @@ -64,6 +64,7 @@
>  #include <media/v4l2-ioctl.h>
>  #include <linux/usb.h>
>  #include <linux/version.h>     /* for KERNEL_VERSION MACRO */
> +#include <linux/mutex.h>
>
>  /* driver and module definitions */
>  #define DRIVER_AUTHOR "Alexey Klimov <klimov.linux@gmail.com>"
> _

There was discussion about this patch.
http://www.mail-archive.com/linux-media@vger.kernel.org/msg03556.html

Well, i'm not against this patch.

-- 
Best regards, Klimov Alexey
