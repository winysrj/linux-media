Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:40831 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933685AbeEILD7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 07:03:59 -0400
References: <20180507162152.2545-1-rui.silva@linaro.org> <20180507162152.2545-13-rui.silva@linaro.org> <CAOMZO5B+P5jyPshBe1NyyFyXCtmeQ_=pEB3CGHQuX_1Gfpa8rQ@mail.gmail.com>
From: Rui Miguel Silva <rmfrfs@gmail.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Rui Miguel Silva <rui.silva@linaro.org>,
        devel@driverdev.osuosl.org,
        "open list\:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 12/14] ARM: dts: imx7s-warp: add ov2680 sensor node
In-reply-to: <CAOMZO5B+P5jyPshBe1NyyFyXCtmeQ_=pEB3CGHQuX_1Gfpa8rQ@mail.gmail.com>
Date: Wed, 09 May 2018 12:03:56 +0100
Message-ID: <m3efil9jkz.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,
On Tue 08 May 2018 at 13:28, Fabio Estevam wrote:
> Hi Rui,
>
> On Mon, May 7, 2018 at 1:21 PM, Rui Miguel Silva 
> <rui.silva@linaro.org> wrote:
>
>> +       reg_peri_3p15v: regulator-peri-3p15v {
>> +               compatible = "regulator-fixed";
>> +               regulator-name = "peri_3p15v_reg";
>> +               regulator-min-microvolt = <3150000>;
>> +               regulator-max-microvolt = <3150000>;
>> +               regulator-always-on;
>
> You can remove the 'regulator-always-on' property as this 
> regulator
> will be controlled by AVDD-supply.

Yeah, will do.

---
Cheers,
	Rui
