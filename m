Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36031 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936015AbdACVS5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 16:18:57 -0500
MIME-Version: 1.0
In-Reply-To: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 3 Jan 2017 19:10:49 -0200
Message-ID: <CAOMZO5D6e-HBERjg0hp8NwvxsE8MkLriy0HExd8OBvgLX_THPQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/19] i.MX Media Driver
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        mchehab@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        devel@driverdev.osuosl.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 3, 2017 at 6:57 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> In version 2 (no functional changes):
>
> - removed patch "gpio: pca953x: Add optional reset gpio control", it
>   has been submitted separately.
> - fixed some whitespace errors.
> - added a few missing Signed-off-by's.

Tested the series on a mx6qsabresd, so:

Tested-by: Fabio Estevam <fabio.estevam@nxp.com>
