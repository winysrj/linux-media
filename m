Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:39511 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753057AbeAZQZz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 11:25:55 -0500
MIME-Version: 1.0
In-Reply-To: <20180126124939.GC7893@Red>
References: <1516718246-24746-1-git-send-email-clabbe@baylibre.com>
 <CAHp75Vf9aK3V=0+2ZPpA5K7ey2tR930ZFKt+e+FJxJvgPB54Vw@mail.gmail.com>
 <20180123182012.GA11384@kroah.com> <20180126124939.GC7893@Red>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Fri, 26 Jan 2018 18:25:54 +0200
Message-ID: <CAHp75VeWj2ymLOzJ3Kt4br+S9f25NCH+fCSnCdZmsNbv3=YRmg@mail.gmail.com>
Subject: Re: [PATCH] staging: media: remove unused VIDEO_ATOMISP_OV8858 kconfig
To: LABBE Corentin <clabbe@baylibre.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 26, 2018 at 2:49 PM, LABBE Corentin <clabbe@baylibre.com> wrote:
> On Tue, Jan 23, 2018 at 07:20:12PM +0100, Greg Kroah-Hartman wrote:
>> On Tue, Jan 23, 2018 at 07:31:27PM +0200, Andy Shevchenko wrote:
>> > On Tue, Jan 23, 2018 at 4:37 PM, Corentin Labbe <clabbe@baylibre.com> wrote:
>> > > Nothing in kernel use VIDEO_ATOMISP_OV8858 since commit 3a81c7660f80 ("media: staging: atomisp: Remove IMX sensor support")
>> > > Lets remove this kconfig option.
>> >
>> > First of all, I hardly understand how that change is related.
>> > Second, did you check Makefile?
>>
>> I don't see it being used in any Makefile, what file do you see it:
>>       $ git grep VIDEO_ATOMISP_OV8858
>>       drivers/staging/media/atomisp/i2c/Kconfig:config VIDEO_ATOMISP_OV8858
>>
>> So it should be removed.
>>
>> thanks,

> I just see that 3a81c7660f80 left ov8858.c so do you agree that I send a v2 which remove also this file ?
> av8858.c is useless without dw9718.c and vcm.c which 3a81c7660f80 removed.

Removal of dead code is pretty fine to me, though the decision is to
Alan and Sakari.

-- 
With Best Regards,
Andy Shevchenko
