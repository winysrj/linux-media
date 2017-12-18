Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-13.mail.aliyun.com ([115.124.20.13]:50048 "EHLO
        out20-13.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758336AbdLRJnc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 04:43:32 -0500
Date: Mon, 18 Dec 2017 17:43:09 +0800
From: Yong <yong.deng@magewell.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: wens@csie.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Benoit Parrot <bparrot@ti.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Rick Chang <rick.chang@mediatek.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        =?UTF-8?B?T25kxZllag==?= Jirman <megous@megous.com>
Subject: Re: [linux-sunxi] [PATCH v3 2/3] dt-bindings: media: Add Allwinner
 V3s Camera Sensor Interface (CSI)
Message-Id: <20171218174309.9170c971c5acac0d14dd782d@magewell.com>
In-Reply-To: <20171218092437.ksczam5h7hirmpcv@flea.lan>
References: <1510558344-45402-1-git-send-email-yong.deng@magewell.com>
        <CAGb2v67JhMfba8Ao7WyrYikkxvTxX8WaBRqu3GkrhOCWndresg@mail.gmail.com>
        <20171218164921.227b82349c778283f5e5eba8@magewell.com>
        <20171218092437.ksczam5h7hirmpcv@flea.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, 18 Dec 2017 10:24:37 +0100
Maxime Ripard <maxime.ripard@free-electrons.com> wrote:

> Hi,
> 
> On Mon, Dec 18, 2017 at 04:49:21PM +0800, Yong wrote:
> > > > +               compatible = "allwinner,sun8i-v3s-csi";
> > > > +               reg = <0x01cb4000 0x1000>;
> > > > +               interrupts = <GIC_SPI 84 IRQ_TYPE_LEVEL_HIGH>;
> > > > +               clocks = <&ccu CLK_BUS_CSI>,
> > > > +                        <&ccu CLK_CSI1_SCLK>,
> > > 
> > > CSI also has an MCLK. Do you need that one?
> > 
> > MCLK is not needed if the front end is not a sensor (like adv7611).
> > I will add it as an option.
> 
> I guess this should always be needed then. And the driver will make
> the decision to enable it or not.

But how the driver to know if it should be enabled?
I think MCLK should be added in DT just if the subdev need it.

> 
> Maxime
> 
> -- 
> Maxime Ripard, Free Electrons
> Embedded Linux and Kernel engineering
> http://free-electrons.com


Thanks,
Yong
