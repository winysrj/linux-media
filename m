Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35510 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751746AbdEDPYx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 May 2017 11:24:53 -0400
Received: by mail-it0-f67.google.com with SMTP id 131so2056492itz.2
        for <linux-media@vger.kernel.org>; Thu, 04 May 2017 08:24:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170504152017.3696-1-p.zabel@pengutronix.de>
References: <20170504152017.3696-1-p.zabel@pengutronix.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 4 May 2017 17:24:51 +0200
Message-ID: <CAK8P3a00XGeiYXR28aM4EXcMLhSgLdnTDJwTKNk8qKO+B2TXMg@mail.gmail.com>
Subject: Re: [PATCH] [media] tc358743: fix register i2c_rd/wr function fix
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 4, 2017 at 5:20 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> The below mentioned fix contains a small but severe bug,
> fix it to make the driver work again.
>
> Fixes: 3538aa6ecfb2 ("[media] tc358743: fix register i2c_rd/wr functions")
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---

Cc: stable@vger.kernel.org # v4.11
Acked-by: Arnd Bergmann <arnd@arndb.de>

Sorry about the typo
