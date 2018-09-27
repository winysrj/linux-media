Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39878 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbeI0PXh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 11:23:37 -0400
MIME-Version: 1.0
References: <20180926125127.2004280-1-arnd@arndb.de> <20180926211706.eswbm2hgbmgy2oog@kekkonen.localdomain>
In-Reply-To: <20180926211706.eswbm2hgbmgy2oog@kekkonen.localdomain>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 27 Sep 2018 11:06:06 +0200
Message-ID: <CAK8P3a0K6aX_GR+yh4MhkWkBDiHiaq5NC+TrKfqcWFXoptNHmg@mail.gmail.com>
Subject: Re: [PATCH] media: ov9650: avoid maybe-uninitialized warnings
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 26, 2018 at 11:17 PM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
>
> Hi Arnd,
>
> On Wed, Sep 26, 2018 at 02:51:01PM +0200, Arnd Bergmann wrote:
> > The regmap change causes multiple warnings like
> >
> > drivers/media/i2c/ov9650.c: In function 'ov965x_g_volatile_ctrl':
> > drivers/media/i2c/ov9650.c:889:29: error: 'reg2' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> >    exposure = ((reg2 & 0x3f) << 10) | (reg1 << 2) |
> >               ~~~~~~~~~~~~~~~^~~~~~
> >
> > It is apparently hard for the compiler to see here if ov965x_read()
> > returned successfully or not. Besides, we have a v4l2_dbg() statement
> > that prints an uninitialized value if regmap_read() fails.
> >
> > Adding an 'else' clause avoids the ambiguity.
>
> Thanks!
>
> I'm not sure what happened here but the two lines use spaces for
> indentation. I've replaced those with tabs.

Thanks a lot, that was clearly what I had intended to send.

        Arnd
