Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:56779 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751333AbdEDPgW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 11:36:22 -0400
Message-ID: <1493912180.2381.35.camel@pengutronix.de>
Subject: Re: [PATCH] [media] tc358743: fix register i2c_rd/wr function fix
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Date: Thu, 04 May 2017 17:36:20 +0200
In-Reply-To: <CAK8P3a00XGeiYXR28aM4EXcMLhSgLdnTDJwTKNk8qKO+B2TXMg@mail.gmail.com>
References: <20170504152017.3696-1-p.zabel@pengutronix.de>
         <CAK8P3a00XGeiYXR28aM4EXcMLhSgLdnTDJwTKNk8qKO+B2TXMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Thu, 2017-05-04 at 17:24 +0200, Arnd Bergmann wrote:
> On Thu, May 4, 2017 at 5:20 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > The below mentioned fix contains a small but severe bug,
> > fix it to make the driver work again.
> >
> > Fixes: 3538aa6ecfb2 ("[media] tc358743: fix register i2c_rd/wr functions")
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> 
> Cc: stable@vger.kernel.org # v4.11
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> Sorry about the typo

Thanks, the original fix currently is only in the media-tree master
branch. I don't see any indication that it is queued for
stable/linux-4.11.y though. Should it be?

regards
Philipp
