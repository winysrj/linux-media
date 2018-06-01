Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752333AbeFATli (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Jun 2018 15:41:38 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Steve Longerbeam <slongerbeam@gmail.com>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com
From: Stephen Boyd <sboyd@kernel.org>
In-Reply-To: <20180522145245.3143-5-rui.silva@linaro.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        linux-clk@vger.kernel.org, Rui Miguel Silva <rui.silva@linaro.org>
References: <20180522145245.3143-1-rui.silva@linaro.org>
 <20180522145245.3143-5-rui.silva@linaro.org>
Message-ID: <152788209717.225090.6042608735474113985@swboyd.mtv.corp.google.com>
Subject: Re: [PATCH v6 04/13] clk: imx7d: fix mipi dphy div parent
Date: Fri, 01 Jun 2018 12:41:37 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Rui Miguel Silva (2018-05-22 07:52:36)
> Fix the mipi dphy root divider to mipi_dphy_pre_div, this would remove a =
orphan
> clock and set the correct parent.
> =

> before:
> cat clk_orphan_summary
>                                  enable  prepare  protect
>    clock                          count    count    count        rate   a=
ccuracy   phase
> -------------------------------------------------------------------------=
---------------

Applied to clk-next
