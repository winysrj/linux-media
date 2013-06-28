Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59748 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab3F1ME7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 08:04:59 -0400
Message-id: <51CD7BE7.90204@samsung.com>
Date: Fri, 28 Jun 2013 14:04:55 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Felipe Balbi <balbi@ti.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	linux-fbdev@vger.kernel.org, 'Kukjin Kim' <kgene.kim@samsung.com>,
	'Tomasz Figa' <t.figa@samsung.com>,
	Jingoo Han <jg1.han@samsung.com>,
	'Donghwa Lee' <dh09.lee@samsung.com>,
	'Kishon Vijay Abraham I' <kishon@ti.com>,
	'Inki Dae' <inki.dae@samsung.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH V2 3/3] video: exynos_dp: Use the generic PHY driver
References: <002101ce73cf$ac989b70$05c9d250$@samsung.com>
 <20130628093459.GD11297@arwen.pp.htv.fi>
 <20130628102702.GK305@game.jcrosoft.org>
In-reply-to: <20130628102702.GK305@game.jcrosoft.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/28/2013 12:27 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 12:35 Fri 28 Jun     , Felipe Balbi wrote:
>> > On Fri, Jun 28, 2013 at 04:18:23PM +0900, Jingoo Han wrote:
>>> > > Use the generic PHY API instead of the platform callback to control
>>> > > the DP PHY. The 'phy_label' field is added to the platform data
>>> > > structure to allow PHY lookup on non-dt platforms.
>>> > > 
>>> > > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
>>> > > ---
[...]
>>> > > diff --git a/Documentation/devicetree/bindings/video/exynos_dp.txt b/Documentation/devicetree/bindings/video/exynos_dp.txt
>>> > > index 84f10c1..a8320e3 100644
>>> > > --- a/Documentation/devicetree/bindings/video/exynos_dp.txt
>>> > > +++ b/Documentation/devicetree/bindings/video/exynos_dp.txt
>>> > > @@ -1,17 +1,6 @@
>>> > >  The Exynos display port interface should be configured based on
>>> > >  the type of panel connected to it.
>>> > >  
>>> > > -We use two nodes:
>>> > > -	-dp-controller node
>>> > > -	-dptx-phy node(defined inside dp-controller node)
>>> > > -
>>> > > -For the DP-PHY initialization, we use the dptx-phy node.
>>> > > -Required properties for dptx-phy:
>>> > > -	-reg:
>>> > > -		Base address of DP PHY register.
>>> > > -	-samsung,enable-mask:
>>> > > -		The bit-mask used to enable/disable DP PHY.
>>> > > -
>>> > >  For the Panel initialization, we read data from dp-controller node.
>>> > >  Required properties for dp-controller:
>>> > >  	-compatible:
>>> > > @@ -67,12 +56,6 @@ SOC specific portion:
>>> > >  		interrupt-parent = <&combiner>;
>>> > >  		clocks = <&clock 342>;
>>> > >  		clock-names = "dp";
>>> > > -
>>> > > -		dptx-phy {
>>> > > -			reg = <0x10040720>;
>>> > > -			samsung,enable-mask = <1>;
>>> > > -		};
>
> I've an issue here you break dt compatibilty

Indeed. Ideally the PHYs should be detachable from the controllers.
I'd assume such a change could be acceptable, given that the driver
still supports the original binding.

--
Thanks,
Sylwester
