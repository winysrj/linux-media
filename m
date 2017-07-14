Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:32822 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750786AbdGNTc1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 15:32:27 -0400
MIME-Version: 1.0
In-Reply-To: <20170714130955.zqe26g6zpixr3xj2@mwanda>
References: <20170714092540.1217397-1-arnd@arndb.de> <20170714093938.1469319-1-arnd@arndb.de>
 <20170714120512.ioe67nnloqivtbr7@mwanda> <CAK8P3a0f84OPcCK1r3P9inGYDJC2KaAO4mjE2vn+vCws-oo_bw@mail.gmail.com>
 <20170714125525.kjemhcn4poon6r3i@mwanda> <20170714130955.zqe26g6zpixr3xj2@mwanda>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 14 Jul 2017 21:32:25 +0200
Message-ID: <CAK8P3a1ckDk2VEhK9EWXU7ZWqh1UoZVMac9j3-1KGioj8EE+kw@mail.gmail.com>
Subject: Re: [PATCH 14/14] [media] fix warning on v4l2_subdev_call() result
 interpreted as bool
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        IDE-ML <linux-ide@vger.kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 14, 2017 at 3:09 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Fri, Jul 14, 2017 at 03:55:26PM +0300, Dan Carpenter wrote:
>> I don't agree with it as a static analysis dev...
>
> What I mean is if it's a macro that returns -ENODEV or a function that
> returns -ENODEV, they should both be treated the same.  The other
> warnings this check prints are quite clever.

I think this is what gcc tries to do, and it should work normally, but it
fails when using ccache. I know I had cases like that, not entirely sure
if this is one of them. Maybe it just means I should give up on using
ccache in preprocessor mode.

       Arnd
