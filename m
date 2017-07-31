Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:44935 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750764AbdGaFNP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 01:13:15 -0400
Date: Mon, 31 Jul 2017 08:13:10 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Yong <yong.deng@magewell.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benoit Parrot <bparrot@ti.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] media: V3s: Add support for Allwinner CSI.
Message-ID: <20170731051310.jp45cj7lugcueztc@tarshish>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
 <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
 <20170728160233.xooevio4hoqkgfaq@flea.lan>
 <20170730060801.bkc2kvm72ktixy74@tarshish>
 <20170731094806.88c3188576d7e2c14b5e3e33@magewell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170731094806.88c3188576d7e2c14b5e3e33@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Mon, Jul 31, 2017 at 09:48:06AM +0800, Yong wrote:
> On Sun, 30 Jul 2017 09:08:01 +0300
> Baruch Siach <baruch@tkos.co.il> wrote:
> > On Fri, Jul 28, 2017 at 06:02:33PM +0200, Maxime Ripard wrote:
> > > On Thu, Jul 27, 2017 at 01:01:35PM +0800, Yong Deng wrote:
> > > > +	regmap_write(sdev->regmap, CSI_CH_F0_BUFA_REG,
> > > > +		     (bus_addr + sdev->planar_offset[0]) >> 2);
> > 
> > Why do you need the bit shift? Does that work for you?
> > 
> > The User Manuals of both the V3s and the and the A33 (AKA R16) state that the 
> > BUFA field size in this register is 31:00, that is 32bit. I have found no 
> > indication of this bit shift in the Olimex provided sunxi-vfe[1] driver. On 
> > the A33 I have found that only after removing the bit-shift, (some sort of) 
> > data started to appear in the buffer.
> > 
> > [1] https://github.com/hehopmajieh/a33_linux/tree/master/drivers/media/video/sunxi-vfe
> 
> The Users Manuals do not document this bit shift. You should see line 10 to
> 32 in https://github.com/hehopmajieh/a33_linux/blob/master/drivers/media/video/sunxi-vfe/csi/csi_reg.c

Thanks. So for my reference, the SoCs that don't need bit shift are A31, A23, 
and A33. SoCs that need bit shift are A80, A83, H3, and V3s (AKA V30).

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
