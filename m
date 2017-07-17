Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43098 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751534AbdGQOan (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 10:30:43 -0400
Date: Mon, 17 Jul 2017 17:28:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, devel@driverdev.osuosl.org,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        IDE-ML <linux-ide@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 14/14] [media] fix warning on v4l2_subdev_call() result
 interpreted as bool
Message-ID: <20170717142817.gq7xnmj3ajkvpqhe@mwanda>
References: <20170714092540.1217397-1-arnd@arndb.de>
 <20170714093938.1469319-1-arnd@arndb.de>
 <f57e08d9-0984-b67c-c64b-c7e0542d0361@xs4all.nl>
 <CAK8P3a1zBW_QuPtRFNwuVyE_ziySoV9_ebz4sD7Bya3eRoo8SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1zBW_QuPtRFNwuVyE_ziySoV9_ebz4sD7Bya3eRoo8SA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 17, 2017 at 04:26:23PM +0200, Arnd Bergmann wrote:
> On Mon, Jul 17, 2017 at 3:45 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On 14/07/17 11:36, Arnd Bergmann wrote:
> >> @@ -201,8 +202,9 @@ static int cx18_g_fmt_sliced_vbi_cap(struct file *file, void *fh,
> >>        * digitizer/slicer.  Note, cx18_av_vbi() wipes the passed in
> >>        * fmt->fmt.sliced under valid calling conditions
> >>        */
> >> -     if (v4l2_subdev_call(cx->sd_av, vbi, g_sliced_fmt, &fmt->fmt.sliced))
> >> -             return -EINVAL;
> >> +     ret = v4l2_subdev_call(cx->sd_av, vbi, g_sliced_fmt, &fmt->fmt.sliced);
> >> +     if (ret)
> >> +             return ret;
> >
> > Please keep the -EINVAL here. I can't be 100% certain that returning 'ret' wouldn't
> > break something.
> 
> I think Dan was recommending the opposite here, if I understood you
> both correctly:
> he said we should propagate the error code unless we know it's wrong, while you
> want to keep the current behavior to avoid introducing changes ;-)
> 

I don't know the subsystem rules at all, so don't listen to me.

regards,
dan carpenter
