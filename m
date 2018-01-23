Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:34640 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751907AbeAWRb3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Jan 2018 12:31:29 -0500
MIME-Version: 1.0
In-Reply-To: <1516718246-24746-1-git-send-email-clabbe@baylibre.com>
References: <1516718246-24746-1-git-send-email-clabbe@baylibre.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue, 23 Jan 2018 19:31:27 +0200
Message-ID: <CAHp75Vf9aK3V=0+2ZPpA5K7ey2tR930ZFKt+e+FJxJvgPB54Vw@mail.gmail.com>
Subject: Re: [PATCH] staging: media: remove unused VIDEO_ATOMISP_OV8858 kconfig
To: Corentin Labbe <clabbe@baylibre.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 23, 2018 at 4:37 PM, Corentin Labbe <clabbe@baylibre.com> wrote:
> Nothing in kernel use VIDEO_ATOMISP_OV8858 since commit 3a81c7660f80 ("media: staging: atomisp: Remove IMX sensor support")
> Lets remove this kconfig option.

First of all, I hardly understand how that change is related.
Second, did you check Makefile?
Third, the files are in the folder (for OV8858).

Taking all above into account, it seems NACK, though regression might
be made by renaming patch from Sakari (no, it's not).
So, it looks like it was never enabled in the first place.

Anyway, do you have hardware to test? This is *most* important reason
why to accept or decline a change to the driver.

-- 
With Best Regards,
Andy Shevchenko
