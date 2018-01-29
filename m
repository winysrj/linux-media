Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:34424 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751256AbeA2NWe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 08:22:34 -0500
MIME-Version: 1.0
In-Reply-To: <1517231511-2295-1-git-send-email-clabbe@baylibre.com>
References: <1517231511-2295-1-git-send-email-clabbe@baylibre.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Mon, 29 Jan 2018 15:22:33 +0200
Message-ID: <CAHp75Vd_xmPvejjn71khk_-XcZQf=i2f0Xgn4Njq+bkju11_xg@mail.gmail.com>
Subject: Re: [PATCH] staging: media: atomisp2: remove unused headers
To: Corentin Labbe <clabbe@baylibre.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 29, 2018 at 3:11 PM, Corentin Labbe <clabbe@baylibre.com> wrote:
> All thoses headers are not used by any source files.
> Lets just remove them.

How did you test this?

P.S. I like the patch, but since driver in a state of coma vigil, I'm
afraid you may do something which shouldn't be done for working
driver.

-- 
With Best Regards,
Andy Shevchenko
