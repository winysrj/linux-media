Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35246 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbdGNVkp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 17:40:45 -0400
Date: Fri, 14 Jul 2017 14:40:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        IDE-ML <linux-ide@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH 08/14] Input: adxl34x - fix gcc-7 -Wint-in-bool-context
 warning
Message-ID: <20170714214041.GA33582@dtor-ws>
References: <20170714092540.1217397-1-arnd@arndb.de>
 <20170714092540.1217397-9-arnd@arndb.de>
 <CA+55aFw076kkn_NS1K+nSHDLoajhviHUsnCOmJOpz5YajpEtFw@mail.gmail.com>
 <CAK8P3a0nZsqWtFX84FTHmm=aVFevrU5ZATnaLVSA39PZeG=6UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0nZsqWtFX84FTHmm=aVFevrU5ZATnaLVSA39PZeG=6UQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 14, 2017 at 10:17:10PM +0200, Arnd Bergmann wrote:
> On Fri, Jul 14, 2017 at 9:24 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Fri, Jul 14, 2017 at 2:25 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> FIFO_MODE is an macro expression with a '<<' operator, which
> >> gcc points out could be misread as a '<':
> >
> > Yeah, no, NAK again.
> >
> > We don't make the code look worse just because gcc is being a f*cking
> > moron about things.
> >
> > This warning is clearly pure garbage.
> >
> 
> I looked at this one again and found a better approach, matching the
> check that is done a few lines later. Unless you find something wrong
> with that one, I'd resubmit it with the fixup below.
> 
>       Arnd
> 
> --- a/drivers/input/misc/adxl34x.c
> +++ b/drivers/input/misc/adxl34x.c
> @@ -789,21 +789,21 @@ struct adxl34x *adxl34x_probe(struct device *dev, int irq,
>                 __set_bit(pdata->ev_code_ff, input_dev->keybit);
>         }
> 
>         if (pdata->ev_code_act_inactivity)
>                 __set_bit(pdata->ev_code_act_inactivity, input_dev->keybit);
> 
>         ac->int_mask |= ACTIVITY | INACTIVITY;
> 
>         if (pdata->watermark) {
>                 ac->int_mask |= WATERMARK;
> -               if (FIFO_MODE(pdata->fifo_mode) == 0)
> +               if (FIFO_MODE(pdata->fifo_mode) == FIFO_BYPASS)

This is better, not because of GCC, but it makes sense logically; 0 is
not a special value here.

Still, I am not sure that GCC is being that helpful here. Checking
result of shift for 0/non 0 with "!" is very common pattern.

Thanks.

-- 
Dmitry
