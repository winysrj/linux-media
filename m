Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36013 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756846AbdABVJn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2017 16:09:43 -0500
MIME-Version: 1.0
In-Reply-To: <1483050455-10683-1-git-send-email-steve_longerbeam@mentor.com>
References: <1483050455-10683-1-git-send-email-steve_longerbeam@mentor.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Mon, 2 Jan 2017 19:09:41 -0200
Message-ID: <CAOMZO5DM4aRwzCWkRoZLmbCxn155YL+CUR_gJyDh+FjzSKD3PQ@mail.gmail.com>
Subject: Re: [PATCH 00/20] i.MX Media Driver
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, mchehab@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        devel@driverdev.osuosl.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Thu, Dec 29, 2016 at 8:27 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> This is a media driver for video capture on i.MX.
>
> Refer to Documentation/media/v4l-drivers/imx.rst for example capture
> pipelines on SabreSD, SabreAuto, and SabreLite reference platforms.
>
> This patchset includes the OF graph layout as proposed by Philipp Zabel,
> with only minor changes which are enumerated in the patch header.

Patches 13, 14 and 19 miss your Signed-off-by tag.

Tested the whole series on a mx6qsabresd:

Tested-by: Fabio Estevam <fabio.estevam@nxp.com>
