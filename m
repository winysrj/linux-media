Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752333AbeFATll (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Jun 2018 15:41:41 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Steve Longerbeam <slongerbeam@gmail.com>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com
From: Stephen Boyd <sboyd@kernel.org>
In-Reply-To: <20180522145245.3143-6-rui.silva@linaro.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        linux-clk@vger.kernel.org, Rui Miguel Silva <rui.silva@linaro.org>
References: <20180522145245.3143-1-rui.silva@linaro.org>
 <20180522145245.3143-6-rui.silva@linaro.org>
Message-ID: <152788209979.225090.13218442162083992241@swboyd.mtv.corp.google.com>
Subject: Re: [PATCH v6 05/13] clk: imx7d: reset parent for mipi csi root
Date: Fri, 01 Jun 2018 12:41:39 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Rui Miguel Silva (2018-05-22 07:52:37)
> To guarantee that we do not get Overflow in image FIFO the outer bandwidt=
h has
> to be faster than inputer bandwidth. For that it must be possible to set a
> faster frequency clock. So set new parent to sys_pfd3 clock for the mipi =
csi
> block.
> =

> Acked-by: Shawn Guo <shawnguo@kernel.org>
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---

Applied to clk-next
