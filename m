Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:44035 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751111AbdGSEt1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 00:49:27 -0400
Date: Wed, 19 Jul 2017 07:49:23 +0300
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
Message-ID: <20170719044923.yae2ye4slvrmtyfe@sapphire.tkos.co.il>
References: <1498561654-14658-1-git-send-email-yong.deng@magewell.com>
 <1498561654-14658-3-git-send-email-yong.deng@magewell.com>
 <20170718115530.ssy7g5vv4siqnfpo@tarshish>
 <20170719092249.2fb6ec720ba1b194cea320c8@magewell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170719092249.2fb6ec720ba1b194cea320c8@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Wed, Jul 19, 2017 at 09:22:49AM +0800, Yong wrote:
> On Tue, 18 Jul 2017 14:55:30 +0300
> Baruch Siach <baruch@tkos.co.il> wrote:
> > I am trying to get this driver working on the Olimex A33 OLinuXino. I 
> > didn't get it working yet, but I had some progress. See the comment below 
> > on one issue I encountered.
> > 
> > On Tue, Jun 27, 2017 at 07:07:34PM +0800, Yong Deng wrote:
> > > Add binding documentation for Allwinner CSI.
> > > 
> > > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> > > ---

[...]

> > > +Example:
> > > +
> > > +	csi1: csi@01cb4000 {
> > > +		compatible = "allwinner,sun8i-v3s-csi";
> > > +		reg = <0x01cb4000 0x1000>;
> > 
> > You use platform_get_resource_byname() to get this IO resource. This requires 
> > adding mandatory
> > 
> >   reg-names = "csi";
> > 
> > But is it actually needed? Wouldn't a simple platform_get_resource() be 
> > enough?
> 
> You are right.
> This will be fixed in the next version.
> I am waiting for more comments for the sunxi-csi.h. It's pleasure if
> you have any suggestions about it.

You mean sunxi_csi.h, right?

Why do you need the sunxi_csi_ops indirection? Do you expect to add 
alternative implementations of these ops at some point?

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
