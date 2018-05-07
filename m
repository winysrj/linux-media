Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:57343 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752636AbeEGPmO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 11:42:14 -0400
Date: Mon, 7 May 2018 17:42:01 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Florent Revest <florent.revest@free-electrons.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Randy Li <ayaka@soulik.info>
Subject: Re: [PATCH v3 11/14] media: platform: Add Sunxi-Cedrus VPU decoder
 driver
Message-ID: <20180507154201.4vz3y6j7u7kzfud6@flea>
References: <20180507124500.20434-1-paul.kocialkowski@bootlin.com>
 <20180507124500.20434-12-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20180507124500.20434-12-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 07, 2018 at 02:44:57PM +0200, Paul Kocialkowski wrote:
> +#define SYSCON_SRAM_CTRL_REG0	0x0
> +#define SYSCON_SRAM_C1_MAP_VE	0x7fffffff

This isn't needed anymore

> +	dev->ahb_clk = devm_clk_get(dev->dev, "ahb");
> +	if (IS_ERR(dev->ahb_clk)) {
> +		dev_err(dev->dev, "failed to get ahb clock\n");
> +		return PTR_ERR(dev->ahb_clk);
> +	}
> +	dev->mod_clk = devm_clk_get(dev->dev, "mod");
> +	if (IS_ERR(dev->mod_clk)) {
> +		dev_err(dev->dev, "failed to get mod clock\n");
> +		return PTR_ERR(dev->mod_clk);
> +	}
> +	dev->ram_clk = devm_clk_get(dev->dev, "ram");
> +	if (IS_ERR(dev->ram_clk)) {
> +		dev_err(dev->dev, "failed to get ram clock\n");
> +		return PTR_ERR(dev->ram_clk);
> +	}

Please add some blank lines between those blocks

> +	dev->rstc = devm_reset_control_get(dev->dev, NULL);

You're not checking the error code here

> +	dev->syscon = syscon_regmap_lookup_by_phandle(dev->dev->of_node,
> +						      "syscon");
> +	if (IS_ERR(dev->syscon)) {
> +		dev->syscon = NULL;
> +	} else {
> +		regmap_write_bits(dev->syscon, SYSCON_SRAM_CTRL_REG0,
> +				  SYSCON_SRAM_C1_MAP_VE,
> +				  SYSCON_SRAM_C1_MAP_VE);
> +	}

You don't need the syscon part anymore either

> +	ret = clk_prepare_enable(dev->ahb_clk);
> +	if (ret) {
> +		dev_err(dev->dev, "could not enable ahb clock\n");
> +		return -EFAULT;
> +	}
> +	ret = clk_prepare_enable(dev->mod_clk);
> +	if (ret) {
> +		clk_disable_unprepare(dev->ahb_clk);
> +		dev_err(dev->dev, "could not enable mod clock\n");
> +		return -EFAULT;
> +	}
> +	ret = clk_prepare_enable(dev->ram_clk);
> +	if (ret) {
> +		clk_disable_unprepare(dev->mod_clk);
> +		clk_disable_unprepare(dev->ahb_clk);
> +		dev_err(dev->dev, "could not enable ram clock\n");
> +		return -EFAULT;
> +	}
> +
> +	ret = reset_control_reset(dev->rstc);
> +	if (ret) {
> +		clk_disable_unprepare(dev->ram_clk);
> +		clk_disable_unprepare(dev->mod_clk);
> +		clk_disable_unprepare(dev->ahb_clk);
> +		dev_err(dev->dev, "could not reset device\n");
> +		return -EFAULT;

labels would simplify this greatly, and you should also release the
sram and the memory region here.

Maxime

-- 
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com
