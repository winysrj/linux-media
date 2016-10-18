Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59951 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936005AbcJRPts (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 11:49:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: horms@verge.net.au, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
        hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se,
        geert@linux-m68k.org, sergei.shtylyov@cogentembedded.com,
        devicetree@kernel.org
Subject: Re: [PATCH v2 3/3] ARM: dts: gose: add composite video input
Date: Tue, 18 Oct 2016 18:49:44 +0300
Message-ID: <2915584.0t40ytsv7y@avalon>
In-Reply-To: <1476802943-5189-4-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1476802943-5189-1-git-send-email-ulrich.hecht+renesas@gmail.com> <1476802943-5189-4-git-send-email-ulrich.hecht+renesas@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

(CC'ing the device tree mailing list)

Thank you for the patch.

On Tuesday 18 Oct 2016 17:02:23 Ulrich Hecht wrote:
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> ---
>  arch/arm/boot/dts/r8a7793-gose.dts | 36 ++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/r8a7793-gose.dts
> b/arch/arm/boot/dts/r8a7793-gose.dts index a47ea4b..2606021 100644
> --- a/arch/arm/boot/dts/r8a7793-gose.dts
> +++ b/arch/arm/boot/dts/r8a7793-gose.dts
> @@ -390,6 +390,11 @@
>  		groups = "vin0_data24", "vin0_sync", "vin0_clkenb", 
"vin0_clk";
>  		function = "vin0";
>  	};
> +
> +	vin1_pins: vin1 {
> +		groups = "vin1_data8", "vin1_clk";
> +		function = "vin1";
> +	};
>  };
> 
>  &ether {
> @@ -515,6 +520,19 @@
>  		reg = <0x12>;
>  	};
> 
> +	composite-in@20 {
> +		compatible = "adi,adv7180";
> +		reg = <0x20>;
> +		remote = <&vin1>;
> +
> +		port {
> +			adv7180: endpoint {
> +				bus-width = <8>;
> +				remote-endpoint = <&vin1ep>;
> +			};
> +		};

As explained before, you need to update the ADV7180 DT bindings first to 
document ports. I've discussed this with Hans last week, and we agreed that DT 
should model physical ports. Unfortunately the ADV7180 comes in four different 
packages with different feature sets that affect ports.

ADV7180  K CP32 Z               32-Lead Lead Frame Chip Scale Package
ADV7180  B CP32 Z               32-Lead Lead Frame Chip Scale Package
ADV7180 WB CP32 Z               32-Lead Lead Frame Chip Scale Package

ADV7180  B CP   Z               40-Lead Lead Frame Chip Scale Package
ADV7180 WB CP   Z               40-Lead Lead Frame Chip Scale Package

ADV7180  K ST48 Z               48-Lead Low Profile Quad Flat Package
ADV7180  B ST48 Z               48-Lead Low Profile Quad Flat Package
ADV7180 WB ST48 Z               48-Lead Low Profile Quad Flat Package

ADV7180  B ST   Z               64-Lead Low Profile Quad Flat Package
ADV7180 WB ST   Z               64-Lead Low Profile Quad Flat Package

W tells whether the part is qualified for automotive applications. It has no 
impact from a software point of view. K and B indicate the temperature range, 
and also have no software impact. The Z suffix indicates that the part is RoHS 
compliant (they all are) and also has no impact.

Unfortunately the W and K/B qualifiers come before the package qualifier. I'm 
not sure whether we could simply drop W, K/B and W and specify the following 
compatible strings

- adv7180cp32
- adv7180cp
- adv7180st48
- adv7180st

or if we need more compatible strings that would match the full chip name. 
Feedback on that from the device tree maintainers would be appreciated.

Regardless of what compatible strings end up being used, the bindings should 
document 3 or 6 input ports depending on the model, and one output port. You 
can number the input ports from 0 to 2 or 0 to 5 depending on the model and 
the output port 3 or 6. Another option would be to number the output port 0 
and the input ports 1 to 3 or 1 to 6 depending on the model. That would give a 
fixed number for the output port across all models, but might be a bit 
consuming as most bindings number input ports before output ports.

For the Gose board you should then add one composite connector to the device 
tree ("composite-video-connector") and connect it to port 0 of the 
ADV7180WBCP32.

> +	};
> +
>  	hdmi@39 {
>  		compatible = "adi,adv7511w";
>  		reg = <0x39>;
> @@ -622,3 +640,21 @@
>  		};
>  	};
>  };
> +
> +/* composite video input */
> +&vin1 {
> +	pinctrl-0 = <&vin1_pins>;
> +	pinctrl-names = "default";
> +
> +	status = "okay";
> +
> +	port {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		vin1ep: endpoint {
> +			remote-endpoint = <&adv7180>;
> +			bus-width = <8>;
> +		};
> +	};
> +};

-- 
Regards,

Laurent Pinchart

