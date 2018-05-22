Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:46106 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751702AbeEVQKu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 12:10:50 -0400
Date: Tue, 22 May 2018 11:10:48 -0500
From: Rob Herring <robh@kernel.org>
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>, linux-clk@vger.kernel.org
Subject: Re: [PATCH v6 07/13] media: dt-bindings: add bindings for i.MX7
 media driver
Message-ID: <20180522161048.GA17123@rob-hp-laptop>
References: <20180522145245.3143-1-rui.silva@linaro.org>
 <20180522145245.3143-8-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180522145245.3143-8-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 22, 2018 at 03:52:39PM +0100, Rui Miguel Silva wrote:
> Add bindings documentation for i.MX7 media drivers.
> The imx7 MIPI CSI2 and imx7 CMOS Sensor Interface.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  .../devicetree/bindings/media/imx7-csi.txt    | 44 ++++++++++
>  .../bindings/media/imx7-mipi-csi2.txt         | 82 +++++++++++++++++++
>  2 files changed, 126 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/imx7-csi.txt
>  create mode 100644 Documentation/devicetree/bindings/media/imx7-mipi-csi2.txt

Reviewed-by: Rob Herring <robh@kernel.org>
