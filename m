Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50852 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbeAWSUN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Jan 2018 13:20:13 -0500
Date: Tue, 23 Jan 2018 19:20:12 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Corentin Labbe <clabbe@baylibre.com>, devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] staging: media: remove unused VIDEO_ATOMISP_OV8858
 kconfig
Message-ID: <20180123182012.GA11384@kroah.com>
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
> Second, did you check Makefile?

I don't see it being used in any Makefile, what file do you see it:
	$ git grep VIDEO_ATOMISP_OV8858
	drivers/staging/media/atomisp/i2c/Kconfig:config VIDEO_ATOMISP_OV8858

So it should be removed.

thanks,

greg k-h
