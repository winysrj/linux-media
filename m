Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45526 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727725AbeHGIix (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 04:38:53 -0400
MIME-Version: 1.0
In-Reply-To: <20180801094801.26627-1-embed3d@gmail.com>
References: <20180801094801.26627-1-embed3d@gmail.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Tue, 7 Aug 2018 14:25:44 +0800
Message-ID: <CAGb2v66oe71CEtqkB2S-AYRzGnTQiJjVPUoRPkefd=9aqK+XbA@mail.gmail.com>
Subject: Re: [PATCH v7 0/4] IR support for A83T
To: Philipp Rossak <embed3d@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Russell King <linux@armlinux.org.uk>, sean@mess.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 1, 2018 at 5:47 PM, Philipp Rossak <embed3d@gmail.com> wrote:
> This patch series adds support for the sunxi A83T ir module and enhances
> the sunxi-ir driver. Right now the base clock frequency for the ir driver
> is a hard coded define and is set to 8 MHz.
> This works for the most common ir receivers. On the Sinovoip Bananapi M3
> the ir receiver needs, a 3 MHz base clock frequency to work without
> problems with this driver.
>
> This patch series adds support for an optinal property that makes it able
> to override the default base clock frequency and enables the ir interface
> on the a83t and the Bananapi M3.

Queued up for 4.20.

Thanks!
