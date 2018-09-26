Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33014 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727736AbeIZUPr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 16:15:47 -0400
MIME-Version: 1.0
References: <20180926130139.2320343-1-arnd@arndb.de> <20180926133738.GA19690@pengutronix.de>
In-Reply-To: <20180926133738.GA19690@pengutronix.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 26 Sep 2018 16:02:24 +0200
Message-ID: <CAK8P3a11n3yeU8=6ZEr+qSRr-hbvY3s5ayYjRriHcaaKcrp00A@mail.gmail.com>
Subject: Re: [PATCH] media: imx-pxp: include linux/interrupt.h
To: pza@pengutronix.de
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 26, 2018 at 3:37 PM Philipp Zabel <pza@pengutronix.de> wrote:
>
> Hi Arnd,
>
> On Wed, Sep 26, 2018 at 03:01:26PM +0200, Arnd Bergmann wrote:
> > The newly added driver fails to build in some configurations due to a
> > missing header inclusion:
>
> Thank you, did you see this error on an older kernel version and rebase
> the patch afterwards?

Yes, sorry about that. I created my patch yesterday, but apparently
this was on next-20180913 rather than the current one.

     Arnd
