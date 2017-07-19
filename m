Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-50.mail.aliyun.com ([115.124.20.50]:38527 "EHLO
        out20-50.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752070AbdGSHBF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 03:01:05 -0400
Date: Wed, 19 Jul 2017 15:00:38 +0800
From: Yong <yong.deng@magewell.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Baruch Siach <baruch@tkos.co.il>, mchehab@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, wens@csie.org,
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
Message-Id: <20170719150038.f43e701ad2bb31fbe54e12a2@magewell.com>
In-Reply-To: <20170719065019.sc2xivtm4d77vrzw@flea>
References: <1498561654-14658-1-git-send-email-yong.deng@magewell.com>
        <1498561654-14658-3-git-send-email-yong.deng@magewell.com>
        <20170718115530.ssy7g5vv4siqnfpo@tarshish>
        <20170719092249.2fb6ec720ba1b194cea320c8@magewell.com>
        <20170719044923.yae2ye4slvrmtyfe@sapphire.tkos.co.il>
        <20170719142120.d00469cf9fce844d40b9988e@magewell.com>
        <20170719063349.m5yg4n2radkvy74r@sapphire.tkos.co.il>
        <20170719065019.sc2xivtm4d77vrzw@flea>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 19 Jul 2017 08:50:19 +0200
Maxime Ripard <maxime.ripard@free-electrons.com> wrote:

> On Wed, Jul 19, 2017 at 09:33:49AM +0300, Baruch Siach wrote:
> > Hi Yong,
> > 
> > On Wed, Jul 19, 2017 at 02:21:20PM +0800, Yong wrote:
> > > On Wed, 19 Jul 2017 07:49:23 +0300
> > > Baruch Siach <baruch@tkos.co.il> wrote:
> > > > On Wed, Jul 19, 2017 at 09:22:49AM +0800, Yong wrote:
> > > > > I am waiting for more comments for the sunxi-csi.h. It's pleasure if
> > > > > you have any suggestions about it.
> > > > 
> > > > You mean sunxi_csi.h, right?
> > > 
> > > Yes. My spelling mistake.
> > > 
> > > > Why do you need the sunxi_csi_ops indirection? Do you expect to add 
> > > > alternative implementations of these ops at some point?
> > > 
> > > I want to seperate the sunxi_video.c and sunxi_csi_v3s.c. 
> > > sunxi_csi_v3s.c is Soc specific. Maybe there will be sunxi_csi_r40.c
> > > in the futrue. But the sunxi_video.c and sunxi_csi.c are common.
> > 
> > I'd say it is a premature optimization. The file separation is fine, IMO, but 
> > the added csi_ops indirection makes the code less readable. Someone with 
> > access to R40 hardware with CSI setup would be a better position to abstract 
> > the platform specific code.
> 
> I agree

Well, I made things complicated.
So, the initial version is just to make V3s CSI working.
Beside csi_ops, are there some comments for sunxi_csi_v3s.c? I will
send a new version in the next few days.

> 
> Maxime
> 
> -- 
> Maxime Ripard, Free Electrons
> Embedded Linux and Kernel engineering
> http://free-electrons.com


Thanks,
Yong
