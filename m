Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36855 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753984AbdGNM1b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 08:27:31 -0400
MIME-Version: 1.0
In-Reply-To: <20170714120512.ioe67nnloqivtbr7@mwanda>
References: <20170714092540.1217397-1-arnd@arndb.de> <20170714093938.1469319-1-arnd@arndb.de>
 <20170714120512.ioe67nnloqivtbr7@mwanda>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 14 Jul 2017 14:27:19 +0200
Message-ID: <CAK8P3a0f84OPcCK1r3P9inGYDJC2KaAO4mjE2vn+vCws-oo_bw@mail.gmail.com>
Subject: Re: [PATCH 14/14] [media] fix warning on v4l2_subdev_call() result
 interpreted as bool
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, devel@driverdev.osuosl.org,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        adi-buildroot-devel@lists.sourceforge.net,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        IDE-ML <linux-ide@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 14, 2017 at 2:05 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Changing:
>
> - if (!frob()) {
> + if (frob() == 0) {
>
> is a totally pointless change.  They're both bad, because they're doing
> success testing instead of failure testing, but probably the second one
> is slightly worse.
>
> This warning seems dumb.  I can't imagine it has even a 10% success rate
> at finding real bugs.  Just disable it.
>
> Changing the code to propagate error codes, is the right thing of course
> so long as it doesn't introduce bugs.

It found a two of bugs that I fixed earlier:

f0e8faa7a5e8 ("ARM: ux500: fix prcmu_is_cpu_in_wfi() calculation")
af15769ffab1 ("scsi: mvsas: fix command_active typo")

plus three patches from this series:

1. staging:iio:resolver:ad2s1210 fix negative IIO_ANGL_VEL read
2. isdn: isdnloop: suppress a gcc-7 warning (my patch is wrong,
   as Joe pointed out there is a real bug)
3. drm/vmwgfx: avoid gcc-7 parentheses (here, Linus had a better
   analysis of the problem, so we should consider that a bug as well)

I would estimate around 25% success rate here, which isn't that
bad for a new warning.

I agree that most of the false positives are really dumb though.

       Arnd
