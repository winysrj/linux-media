Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:36306 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932687AbbEMREs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 13:04:48 -0400
Received: by igbpi8 with SMTP id pi8so144815100igb.1
        for <linux-media@vger.kernel.org>; Wed, 13 May 2015 10:04:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1431536238-12738-1-git-send-email-ksenija.stanojevic@gmail.com>
References: <1431536238-12738-1-git-send-email-ksenija.stanojevic@gmail.com>
Date: Wed, 13 May 2015 10:04:48 -0700
Message-ID: <CALAqxLWjo3+h5QqVnJGe2vda9SbUGg1L8wZjuQWSVaX5di1MzA@mail.gmail.com>
Subject: Re: [PATCH v3] Staging: media: Replace timeval with ktime_t
From: John Stultz <john.stultz@linaro.org>
To: Ksenija Stanojevic <ksenija.stanojevic@gmail.com>
Cc: y2038 Mailman List <y2038@lists.linaro.org>,
	linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 13, 2015 at 9:57 AM, Ksenija Stanojevic
<ksenija.stanojevic@gmail.com> wrote:
> 'struct timeval last_tv' is used to get the time of last signal change
> and 'struct timeval last_intr_tv' is used to get the time of last UART
> interrupt.
> 32-bit systems using 'struct timeval' will break in the year 2038, so we
> have to replace that code with more appropriate types.
> Here struct timeval is replaced with ktime_t.
>
> Signed-off-by: Ksenija Stanojevic <ksenija.stanojevic@gmail.com>
> ---
> Changes in v3:
>         - as John suggested delta function is changed to inline function,
>         checkpatch signals a warning to change min to min_t. Is it a false
>         positive?
>         - change variable names.
>
> Changes in v2:
>         - change subject line
>
>  drivers/staging/media/lirc/lirc_sir.c | 51 +++++++++++++----------------------
>  1 file changed, 18 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
> index 29087f6..c98c486 100644
> --- a/drivers/staging/media/lirc/lirc_sir.c
> +++ b/drivers/staging/media/lirc/lirc_sir.c
> @@ -44,7 +44,7 @@
>  #include <linux/ioport.h>
>  #include <linux/kernel.h>
>  #include <linux/serial_reg.h>
> -#include <linux/time.h>
> +#include <linux/ktime.h>
>  #include <linux/string.h>
>  #include <linux/types.h>
>  #include <linux/wait.h>
> @@ -127,9 +127,9 @@ static int threshold = 3;
>  static DEFINE_SPINLOCK(timer_lock);
>  static struct timer_list timerlist;
>  /* time of last signal change detected */
> -static struct timeval last_tv = {0, 0};
> +static ktime_t last;
>  /* time of last UART data ready interrupt */
> -static struct timeval last_intr_tv = {0, 0};
> +static ktime_t last_intr_time;
>  static int last_value;
>
>  static DECLARE_WAIT_QUEUE_HEAD(lirc_read_queue);
> @@ -400,18 +400,11 @@ static void drop_chrdev(void)
>  }
>
>  /* SECTION: Hardware */
> -static long delta(struct timeval *tv1, struct timeval *tv2)
> +static inline long delta(ktime_t t1, ktime_t t2)
>  {
> -       unsigned long deltv;
> -
> -       deltv = tv2->tv_sec - tv1->tv_sec;
> -       if (deltv > 15)
> -               deltv = 0xFFFFFF;
> -       else
> -               deltv = deltv*1000000 +
> -                       tv2->tv_usec -
> -                       tv1->tv_usec;
> -       return deltv;
> +       /* return the delta in 32bit usecs, but cap to UINTMAX in case the
> +        * delta is greater then 32bits */
> +       return (long) min((unsigned int) ktime_us_delta(t1, t2), UINT_MAX);
>  }

This probably needs some close review from the media folks. Thinking
about it more, I'm really not certain the 15sec cap was to avoid a
32bit overflow or if there's some other subtle undocumented reason.

thanks
-john
