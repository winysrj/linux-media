Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:32848 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbbFSQQQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2015 12:16:16 -0400
Received: by lbbvz5 with SMTP id vz5so27084624lbb.0
        for <linux-media@vger.kernel.org>; Fri, 19 Jun 2015 09:16:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c95df47c5405b494d19d20b2852a9378c9f661f3.1434152603.git.luto@kernel.org>
References: <cover.1434152603.git.luto@kernel.org> <c95df47c5405b494d19d20b2852a9378c9f661f3.1434152603.git.luto@kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 19 Jun 2015 09:15:53 -0700
Message-ID: <CALCETrVE-RsA6ud+Vt_YpXb=o_c_B0AUq-x21aqgMweTApeUvg@mail.gmail.com>
Subject: Re: [PATCH v2 09/17] staging/lirc_serial: Remove TSC-based timing
To: Andy Lutomirski <luto@kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Cc: X86 ML <x86@kernel.org>, Borislav Petkov <bp@suse.de>,
	Peter Zijlstra <peterz@infradead.org>,
	John Stultz <john.stultz@linaro.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Len Brown <lenb@kernel.org>, Huang Rui <ray.huang@amd.com>,
	Denys Vlasenko <dvlasenk@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>, devel@driverdev.osuosl.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, etc:

Are you okay with this change landing in the tip tree?

--Andy

On Fri, Jun 12, 2015 at 4:44 PM, Andy Lutomirski <luto@kernel.org> wrote:
> It wasn't compiled in by default.  I suspect that the driver was and
> still is broken, though -- it's calling udelay with a parameter
> that's derived from loops_per_jiffy.
>
> Cc: Jarod Wilson <jarod@wilsonet.com>
> Cc: devel@driverdev.osuosl.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  drivers/staging/media/lirc/lirc_serial.c | 63 ++------------------------------
>  1 file changed, 4 insertions(+), 59 deletions(-)
>
> diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
> index dc7984455c3a..465796a686c4 100644
> --- a/drivers/staging/media/lirc/lirc_serial.c
> +++ b/drivers/staging/media/lirc/lirc_serial.c
> @@ -327,9 +327,6 @@ static void safe_udelay(unsigned long usecs)
>   * time
>   */
>
> -/* So send_pulse can quickly convert microseconds to clocks */
> -static unsigned long conv_us_to_clocks;
> -
>  static int init_timing_params(unsigned int new_duty_cycle,
>                 unsigned int new_freq)
>  {
> @@ -344,7 +341,6 @@ static int init_timing_params(unsigned int new_duty_cycle,
>         /* How many clocks in a microsecond?, avoiding long long divide */
>         work = loops_per_sec;
>         work *= 4295;  /* 4295 = 2^32 / 1e6 */
> -       conv_us_to_clocks = work >> 32;
>
>         /*
>          * Carrier period in clocks, approach good up to 32GHz clock,
> @@ -357,10 +353,9 @@ static int init_timing_params(unsigned int new_duty_cycle,
>         pulse_width = period * duty_cycle / 100;
>         space_width = period - pulse_width;
>         dprintk("in init_timing_params, freq=%d, duty_cycle=%d, "
> -               "clk/jiffy=%ld, pulse=%ld, space=%ld, "
> -               "conv_us_to_clocks=%ld\n",
> +               "clk/jiffy=%ld, pulse=%ld, space=%ld\n",
>                 freq, duty_cycle, __this_cpu_read(cpu_info.loops_per_jiffy),
> -               pulse_width, space_width, conv_us_to_clocks);
> +               pulse_width, space_width);
>         return 0;
>  }
>  #else /* ! USE_RDTSC */
> @@ -431,63 +426,14 @@ static long send_pulse_irdeo(unsigned long length)
>         return ret;
>  }
>
> -#ifdef USE_RDTSC
> -/* Version that uses Pentium rdtsc instruction to measure clocks */
> -
> -/*
> - * This version does sub-microsecond timing using rdtsc instruction,
> - * and does away with the fudged LIRC_SERIAL_TRANSMITTER_LATENCY
> - * Implicitly i586 architecture...  - Steve
> - */
> -
> -static long send_pulse_homebrew_softcarrier(unsigned long length)
> -{
> -       int flag;
> -       unsigned long target, start, now;
> -
> -       /* Get going quick as we can */
> -       rdtscl(start);
> -       on();
> -       /* Convert length from microseconds to clocks */
> -       length *= conv_us_to_clocks;
> -       /* And loop till time is up - flipping at right intervals */
> -       now = start;
> -       target = pulse_width;
> -       flag = 1;
> -       /*
> -        * FIXME: This looks like a hard busy wait, without even an occasional,
> -        * polite, cpu_relax() call.  There's got to be a better way?
> -        *
> -        * The i2c code has the result of a lot of bit-banging work, I wonder if
> -        * there's something there which could be helpful here.
> -        */
> -       while ((now - start) < length) {
> -               /* Delay till flip time */
> -               do {
> -                       rdtscl(now);
> -               } while ((now - start) < target);
> -
> -               /* flip */
> -               if (flag) {
> -                       rdtscl(now);
> -                       off();
> -                       target += space_width;
> -               } else {
> -                       rdtscl(now); on();
> -                       target += pulse_width;
> -               }
> -               flag = !flag;
> -       }
> -       rdtscl(now);
> -       return ((now - start) - length) / conv_us_to_clocks;
> -}
> -#else /* ! USE_RDTSC */
>  /* Version using udelay() */
>
>  /*
>   * here we use fixed point arithmetic, with 8
>   * fractional bits.  that gets us within 0.1% or so of the right average
>   * frequency, albeit with some jitter in pulse length - Steve
> + *
> + * This should use ndelay instead.
>   */
>
>  /* To match 8 fractional bits used for pulse/space length */
> @@ -520,7 +466,6 @@ static long send_pulse_homebrew_softcarrier(unsigned long length)
>         }
>         return (actual-length) >> 8;
>  }
> -#endif /* USE_RDTSC */
>
>  static long send_pulse_homebrew(unsigned long length)
>  {
> --
> 2.4.2
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
