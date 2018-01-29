Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33046 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751256AbeA2NaV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 08:30:21 -0500
Received: by mail-wr0-f194.google.com with SMTP id s5so7225995wra.0
        for <linux-media@vger.kernel.org>; Mon, 29 Jan 2018 05:30:20 -0800 (PST)
Date: Mon, 29 Jan 2018 14:30:14 +0100
From: LABBE Corentin <clabbe@baylibre.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] staging: media: atomisp2: remove unused headers
Message-ID: <20180129133014.GB32503@Red>
References: <1517231511-2295-1-git-send-email-clabbe@baylibre.com>
 <CAHp75Vd_xmPvejjn71khk_-XcZQf=i2f0Xgn4Njq+bkju11_xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vd_xmPvejjn71khk_-XcZQf=i2f0Xgn4Njq+bkju11_xg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 29, 2018 at 03:22:33PM +0200, Andy Shevchenko wrote:
> On Mon, Jan 29, 2018 at 3:11 PM, Corentin Labbe <clabbe@baylibre.com> wrote:
> > All thoses headers are not used by any source files.
> > Lets just remove them.
> 
> How did you test this?
> 
> P.S. I like the patch, but since driver in a state of coma vigil, I'm
> afraid you may do something which shouldn't be done for working
> driver.
> 

For testing I have:
- successfully compiling the driver
- for each file, grepping its name in tree to be sure that no one uses it.
