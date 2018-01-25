Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:43434 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750769AbeAYKvf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 05:51:35 -0500
MIME-Version: 1.0
In-Reply-To: <20180124004340.GA25212@embeddedgus>
References: <20180124004340.GA25212@embeddedgus>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 25 Jan 2018 11:51:34 +0100
Message-ID: <CAK8P3a3-Cx0Az9d6rpVUA4dRtCH7kghS65MOEGp0zd5tyU2FFQ@mail.gmail.com>
Subject: Re: [PATCH] staging: imx-media-vdic: fix inconsistent IS_ERR and PTR_ERR
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 24, 2018 at 1:43 AM, Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
> Fix inconsistent IS_ERR and PTR_ERR in vdic_get_ipu_resources.
> The proper pointer to be passed as argument is ch.
>
> This issue was detected with the help of Coccinelle.
>
> Fixes: 0b2e9e7947e7 ("media: staging/imx: remove confusing IS_ERR_OR_NULL usage")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

good catch!

Acked-by: Arnd Bergmann <arnd@arndb.de>
