Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723Ab0BCLFh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 06:05:37 -0500
Message-ID: <4B695879.5060500@redhat.com>
Date: Wed, 03 Feb 2010 09:05:29 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Samuel Rakitnican <samuel.rakitnican@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RESEND PATCH] ir-kbd-i2c: Allow to disable Hauppauge filter
 through module parameter
References: <op.u6ov64og6dn9rq@denis-laptop.lan> <op.u6oxbgql6dn9rq@denis-laptop.lan>
In-Reply-To: <op.u6oxbgql6dn9rq@denis-laptop.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Samuel,

Samuel Rakitnican wrote:
> Some Hauppauge devices have id=0 so such devices won't work.
> For such devices add a module parameter that allow to turn
> off filtering.
> 
> Signed-off-by: Samuel Rakitničan <semiRocket@gmail.com>

Instead of a modprobe parameter, the proper fix is to make the usage of the
complete RC5 code received from this IR. This way, the handling of the
IR will depend only at the IR table used by the device.

Please take a look at the code at em28xx (seek for ir->full_code) to see
how to implement it.

Cheers,
Mauro.

> ---
> diff -r 82bbb3bd0f0a linux/drivers/media/video/ir-kbd-i2c.c
> --- a/linux/drivers/media/video/ir-kbd-i2c.c    Mon Jan 11 11:47:33 2010
> -0200
> +++ b/linux/drivers/media/video/ir-kbd-i2c.c    Sat Jan 16 16:39:14 2010
> +0100
> @@ -61,6 +61,10 @@
>   module_param(hauppauge, int, 0644);    /* Choose Hauppauge remote */
>   MODULE_PARM_DESC(hauppauge, "Specify Hauppauge remote: 0=black, 1=grey
> (defaults to 0)");
> 
> +static int haup_filter = 1;
> +module_param(haup_filter, int, 0644);
> +MODULE_PARM_DESC(haup_filter, "Hauppauge filter for other remotes,
> default is 1 (On)");
> +
> 
>   #define DEVNAME "ir-kbd-i2c"
>   #define dprintk(level, fmt, arg...)    if (debug >= level) \
> @@ -96,24 +100,27 @@
>       if (!start)
>           /* no key pressed */
>           return 0;
> -    /*
> -     * Hauppauge remotes (black/silver) always use
> -     * specific device ids. If we do not filter the
> -     * device ids then messages destined for devices
> -     * such as TVs (id=0) will get through causing
> -     * mis-fired events.
> -     *
> -     * We also filter out invalid key presses which
> -     * produce annoying debug log entries.
> -     */
> -    ircode= (start << 12) | (toggle << 11) | (dev << 6) | code;
> -    if ((ircode & 0x1fff)==0x1fff)
> -        /* invalid key press */
> -        return 0;
> 
> -    if (dev!=0x1e && dev!=0x1f)
> -        /* not a hauppauge remote */
> -        return 0;
> +    if (haup_filter != 0) {
> +        /*
> +         * Hauppauge remotes (black/silver) always use
> +         * specific device ids. If we do not filter the
> +         * device ids then messages destined for devices
> +         * such as TVs (id=0) will get through causing
> +         * mis-fired events.
> +         *
> +         * We also filter out invalid key presses which
> +         * produce annoying debug log entries.
> +         */
> +        ircode = (start << 12) | (toggle << 11) | (dev << 6) | code;
> +        if ((ircode & 0x1fff) == 0x1fff)
> +            /* invalid key press */
> +            return 0;
> +
> +        if (dev != 0x1e && dev != 0x1f)
> +            /* not a hauppauge remote */
> +            return 0;
> +    }
> 
>       if (!range)
>           code += 64;
> 


-- 

Cheers,
Mauro
