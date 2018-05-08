Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:36325 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932170AbeEHN2N (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 09:28:13 -0400
MIME-Version: 1.0
In-Reply-To: <20180507162152.2545-13-rui.silva@linaro.org>
References: <20180507162152.2545-1-rui.silva@linaro.org> <20180507162152.2545-13-rui.silva@linaro.org>
From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 8 May 2018 10:28:11 -0300
Message-ID: <CAOMZO5B+P5jyPshBe1NyyFyXCtmeQ_=pEB3CGHQuX_1Gfpa8rQ@mail.gmail.com>
Subject: Re: [PATCH v3 12/14] ARM: dts: imx7s-warp: add ov2680 sensor node
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org, Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rui,

On Mon, May 7, 2018 at 1:21 PM, Rui Miguel Silva <rui.silva@linaro.org> wrote:

> +       reg_peri_3p15v: regulator-peri-3p15v {
> +               compatible = "regulator-fixed";
> +               regulator-name = "peri_3p15v_reg";
> +               regulator-min-microvolt = <3150000>;
> +               regulator-max-microvolt = <3150000>;
> +               regulator-always-on;

You can remove the 'regulator-always-on' property as this regulator
will be controlled by AVDD-supply.
