Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:37334 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932103AbeAXIkp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Jan 2018 03:40:45 -0500
Date: Wed, 24 Jan 2018 11:35:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Corentin Labbe <clabbe@baylibre.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] staging: media: remove unused VIDEO_ATOMISP_OV8858
 kconfig
Message-ID: <20180124083523.k72x34eoork3fm4j@mwanda>
References: <1516718246-24746-1-git-send-email-clabbe@baylibre.com>
 <CAHp75Vf9aK3V=0+2ZPpA5K7ey2tR930ZFKt+e+FJxJvgPB54Vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vf9aK3V=0+2ZPpA5K7ey2tR930ZFKt+e+FJxJvgPB54Vw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 23, 2018 at 07:31:27PM +0200, Andy Shevchenko wrote:
> On Tue, Jan 23, 2018 at 4:37 PM, Corentin Labbe <clabbe@baylibre.com> wrote:
> > Nothing in kernel use VIDEO_ATOMISP_OV8858 since commit 3a81c7660f80 ("media: staging: atomisp: Remove IMX sensor support")
> > Lets remove this kconfig option.
> 
> First of all, I hardly understand how that change is related.

It's pretty obvious if you look at the commit.

-obj-$(CONFIG_VIDEO_ATOMISP_OV8858)     += atomisp-ov8858.o

It sounds like you deleted that line by mistake and re-added it to your
local Makefile?

regards,
dan carpenter
