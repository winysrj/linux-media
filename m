Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:44055 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752785AbdGSGdx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 02:33:53 -0400
Date: Wed, 19 Jul 2017 09:33:49 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Yong <yong.deng@magewell.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        hans.verkuil@cisco.com, peter.griffin@linaro.org,
        hugues.fruchet@st.com, krzk@kernel.org, bparrot@ti.com,
        arnd@arndb.de, jean-christophe.trotin@st.com,
        benjamin.gaignard@linaro.org, tiffany.lin@mediatek.com,
        kamil@wypas.org, kieran+renesas@ksquared.org.uk,
        andrew-ct.chen@mediatek.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] dt-bindings: add binding documentation for
 Allwinner CSI
Message-ID: <20170719063349.m5yg4n2radkvy74r@sapphire.tkos.co.il>
References: <1498561654-14658-1-git-send-email-yong.deng@magewell.com>
 <1498561654-14658-3-git-send-email-yong.deng@magewell.com>
 <20170718115530.ssy7g5vv4siqnfpo@tarshish>
 <20170719092249.2fb6ec720ba1b194cea320c8@magewell.com>
 <20170719044923.yae2ye4slvrmtyfe@sapphire.tkos.co.il>
 <20170719142120.d00469cf9fce844d40b9988e@magewell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170719142120.d00469cf9fce844d40b9988e@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Wed, Jul 19, 2017 at 02:21:20PM +0800, Yong wrote:
> On Wed, 19 Jul 2017 07:49:23 +0300
> Baruch Siach <baruch@tkos.co.il> wrote:
> > On Wed, Jul 19, 2017 at 09:22:49AM +0800, Yong wrote:
> > > I am waiting for more comments for the sunxi-csi.h. It's pleasure if
> > > you have any suggestions about it.
> > 
> > You mean sunxi_csi.h, right?
> 
> Yes. My spelling mistake.
> 
> > Why do you need the sunxi_csi_ops indirection? Do you expect to add 
> > alternative implementations of these ops at some point?
> 
> I want to seperate the sunxi_video.c and sunxi_csi_v3s.c. 
> sunxi_csi_v3s.c is Soc specific. Maybe there will be sunxi_csi_r40.c
> in the futrue. But the sunxi_video.c and sunxi_csi.c are common.

I'd say it is a premature optimization. The file separation is fine, IMO, but 
the added csi_ops indirection makes the code less readable. Someone with 
access to R40 hardware with CSI setup would be a better position to abstract 
the platform specific code.

But I'd defer to the media maintainers on that.

Thanks,
baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
