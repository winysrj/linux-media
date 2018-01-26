Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:52351 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751621AbeAZMtn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 07:49:43 -0500
Received: by mail-wm0-f65.google.com with SMTP id g1so1057410wmg.2
        for <linux-media@vger.kernel.org>; Fri, 26 Jan 2018 04:49:42 -0800 (PST)
Date: Fri, 26 Jan 2018 13:49:39 +0100
From: LABBE Corentin <clabbe@baylibre.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] staging: media: remove unused VIDEO_ATOMISP_OV8858
 kconfig
Message-ID: <20180126124939.GC7893@Red>
References: <1516718246-24746-1-git-send-email-clabbe@baylibre.com>
 <CAHp75Vf9aK3V=0+2ZPpA5K7ey2tR930ZFKt+e+FJxJvgPB54Vw@mail.gmail.com>
 <20180123182012.GA11384@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180123182012.GA11384@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 23, 2018 at 07:20:12PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Jan 23, 2018 at 07:31:27PM +0200, Andy Shevchenko wrote:
> > On Tue, Jan 23, 2018 at 4:37 PM, Corentin Labbe <clabbe@baylibre.com> wrote:
> > > Nothing in kernel use VIDEO_ATOMISP_OV8858 since commit 3a81c7660f80 ("media: staging: atomisp: Remove IMX sensor support")
> > > Lets remove this kconfig option.
> > 
> > First of all, I hardly understand how that change is related.
> > Second, did you check Makefile?
> 
> I don't see it being used in any Makefile, what file do you see it:
> 	$ git grep VIDEO_ATOMISP_OV8858
> 	drivers/staging/media/atomisp/i2c/Kconfig:config VIDEO_ATOMISP_OV8858
> 
> So it should be removed.
> 
> thanks,
> 

Hello

I just see that 3a81c7660f80 left ov8858.c so do you agree that I send a v2 which remove also this file ?
av8858.c is useless without dw9718.c and vcm.c which 3a81c7660f80 removed.

Regards
