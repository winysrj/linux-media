Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43929 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750793AbeAUQdU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Jan 2018 11:33:20 -0500
Date: Sun, 21 Jan 2018 17:33:14 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 0/3] media: ov9650: support device tree probing
Message-ID: <20180121163314.GN24926@w540>
References: <1516547656-3879-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1516547656-3879-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Akinobu,

On Mon, Jan 22, 2018 at 12:14:13AM +0900, Akinobu Mita wrote:
> This patchset adds device tree probing for ov9650 driver. This contains
> an actual driver change and a newly added binding documentation part.
>
> * Changelog v3
> - Add Reviewed-by: tags
> - Add MAINTAINERS entry
>
> * Changelog v2
> - Split binding documentation, suggested by Rob Herring and Jacopo Mondi
> - Improve the wording for compatible property in the binding documentation,
>   suggested by Jacopo Mondi
> - Improve the description for the device node in the binding documentation,
>   suggested by Sakari Ailus
> - Remove ov965x_gpio_set() helper and open-code it, suggested by Jacopo Mondi
>   and Sakari Ailus
> - Call clk_prepare_enable() in s_power callback instead of probe, suggested
>   by Sakari Ailus
> - Unify clk and gpio configuration in a single if-else block and, also add
>   a check either platform data or fwnode is actually specified, suggested
>   by Jacopo Mondi
> - Add CONFIG_OF guards, suggested by Jacopo Mondi
>
> Akinobu Mita (3):
>   media: ov9650: support device tree probing
>   media: MAINTAINERS: add entry for ov9650 driver
>   media: ov9650: add device tree binding

As you've closed my comments on v1/v2, for driver and device tree bindings:

Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

No need to resend just to add the tags, but in case you have to, please
add them.

Thanks
   j

>
>  .../devicetree/bindings/media/i2c/ov9650.txt       |  36 ++++++
>  MAINTAINERS                                        |  10 ++
>  drivers/media/i2c/ov9650.c                         | 130 +++++++++++++++------
>  3 files changed, 138 insertions(+), 38 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov9650.txt
>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Jacopo Mondi <jacopo@jmondi.org>
> Cc: H. Nikolaus Schaller <hns@goldelico.com>
> Cc: Hugues Fruchet <hugues.fruchet@st.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Cc: Rob Herring <robh@kernel.org>
> --
> 2.7.4
>
