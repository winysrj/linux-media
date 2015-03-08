Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34224 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750937AbbCHADH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2015 19:03:07 -0500
Date: Sun, 8 Mar 2015 02:03:03 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com
Subject: Re: [RFC 17/18] arm: dts: n950, n9: Add primary camera support
Message-ID: <20150308000303.GJ6539@valkosipuli.retiisi.org.uk>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
 <1425764475-27691-18-git-send-email-sakari.ailus@iki.fi>
 <5342826.KbVLN7n8xZ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5342826.KbVLN7n8xZ@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sun, Mar 08, 2015 at 01:56:13AM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Saturday 07 March 2015 23:41:14 Sakari Ailus wrote:
> > Add support for the primary camera of the Nokia N950 and N9.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  arch/arm/boot/dts/omap3-n9.dts       |   39 +++++++++++++++++++++++++++++++
> >  arch/arm/boot/dts/omap3-n950-n9.dtsi |    4 ----
> >  arch/arm/boot/dts/omap3-n950.dts     |   39 +++++++++++++++++++++++++++++++
> >  3 files changed, 78 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/omap3-n9.dts b/arch/arm/boot/dts/omap3-n9.dts
> > index 9938b5d..05f32ae 100644
> > --- a/arch/arm/boot/dts/omap3-n9.dts
> > +++ b/arch/arm/boot/dts/omap3-n9.dts
> > @@ -16,3 +16,42 @@
> >  	model = "Nokia N9";
> >  	compatible = "nokia,omap3-n9", "ti,omap36xx", "ti,omap3";
> >  };
> > +
> > +&i2c2 {
> > +	clock-frequency = <400000>;
> > +
> > +	smia_1: camera@10 {
> > +		compatible = "nokia,smia";
> > +		reg = <0x10>;
> > +		/* No reset gpio */
> > +		vana-supply = <&vaux3>;
> > +		clocks = <&omap3_isp 0>;
> > +		clock-frequency = <9600000>;
> > +		nokia,nvm-size = <1024>; /* 16 * 64 */
> 
> You could actually specify that as "<(16 * 64)>".

Will fix.

> > +		link-frequencies = /bits/ 64 <199200000 210000000 499200000>;
> > +		port {
> > +			smia_1_1: endpoint {
> > +				clock-lanes = <0>;
> > +				data-lanes = <1 2>;
> > +				remote-endpoint = <&csi2a_ep>;
> > +			};
> > +		};
> > +	};
> > +};
> > +
> > +&omap3_isp {
> > +	vdd-csiphy1-supply = <&vaux2>;
> > +	vdd-csiphy2-supply = <&vaux2>;
> > +	ports {
> > +		port@2 {
> > +			reg = <2>;
> > +			csi2a_ep: endpoint {
> > +				remote-endpoint = <&smia_1_1>;
> > +				clock-lanes = <2>;
> > +				data-lanes = <1 3>;
> > +				crc = <1>;
> > +				lane-polarity = <1 1 1>;
> > +			};
> > +		};
> > +	};
> > +};
> > diff --git a/arch/arm/boot/dts/omap3-n950-n9.dtsi
> > b/arch/arm/boot/dts/omap3-n950-n9.dtsi index c41db94..51e5043 100644
> > --- a/arch/arm/boot/dts/omap3-n950-n9.dtsi
> > +++ b/arch/arm/boot/dts/omap3-n950-n9.dtsi
> > @@ -86,10 +86,6 @@
> >  	regulator-max-microvolt = <2800000>;
> >  };
> > 
> > -&i2c2 {
> > -	clock-frequency = <400000>;
> > -};
> > -
> 
> What's the reason for moving this to the N9 and N950 DT files as you keep the 
> same value in both ?

Just before submitting the patches I thought someone might ask. :-D

I'll fix that.

> >  &i2c3 {
> >  	clock-frequency = <400000>;
> >  };
> > diff --git a/arch/arm/boot/dts/omap3-n950.dts
> > b/arch/arm/boot/dts/omap3-n950.dts index 261c558..2b2ed9c 100644
> > --- a/arch/arm/boot/dts/omap3-n950.dts
> > +++ b/arch/arm/boot/dts/omap3-n950.dts
> > @@ -16,3 +16,42 @@
> >  	model = "Nokia N950";
> >  	compatible = "nokia,omap3-n950", "ti,omap36xx", "ti,omap3";
> >  };
> > +
> > +&i2c2 {
> > +	clock-frequency = <400000>;
> > +
> > +	smia_1: camera@10 {
> > +		compatible = "nokia,smia";
> > +		reg = <0x10>;
> > +		/* No reset gpio */
> > +		vana-supply = <&vaux3>;
> > +		clocks = <&omap3_isp 0>;
> > +		clock-frequency = <9600000>;
> > +		nokia,nvm-size = <1024>; /* 16 * 64 */
> > +		link-frequencies = /bits/ 64 <210000000 333600000 398400000>;
> > +		port {
> > +			smia_1_1: endpoint {
> > +				clock-lanes = <0>;
> > +				data-lanes = <1 2>;
> > +				remote-endpoint = <&csi2a_ep>;
> > +			};
> > +		};
> > +	};
> > +};
> > +
> > +&omap3_isp {
> > +	vdd-csiphy1-supply = <&vaux2>;
> > +	vdd-csiphy2-supply = <&vaux2>;
> > +	ports {
> > +		port@2 {
> > +			reg = <2>;
> > +			csi2a_ep: endpoint {
> > +				remote-endpoint = <&smia_1_1>;
> > +				clock-lanes = <2>;
> > +				data-lanes = <3 1>;
> > +				crc = <1>;
> > +				lane-polarity = <1 1 1>;
> > +			};
> > +		};
> > +	};
> > +};
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
