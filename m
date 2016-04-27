Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39194 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbcD0QQQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 12:16:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/2] [media] tvp5150: Add input connectors DT bindings
Date: Wed, 27 Apr 2016 17:29:27 +0300
Message-ID: <2355815.rhlvKGshE1@avalon>
In-Reply-To: <1460500973-9066-2-git-send-email-javier@osg.samsung.com>
References: <1460500973-9066-1-git-send-email-javier@osg.samsung.com> <1460500973-9066-2-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Thank you for the patch.

On Tuesday 12 Apr 2016 18:42:52 Javier Martinez Canillas wrote:
> The tvp5150 and tvp5151 decoders support different video input source
> connections to their AIP1A and AIP1B pins. Either two Composite or a
> S-Video input signals are supported.
> 
> The possible configurations are as follows:
> 
> - Analog Composite signal connected to AIP1A.
> - Analog Composite signal connected to AIP1B.
> - Analog S-Video Y (luminance) and C (chrominance)
>   signals connected to AIP1A and AIP1B respectively.
> 
> This patch extends the Device Tree binding documentation to describe
> how the input connectors for these devices should be defined in a DT.
> 
> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> ---
> Hello,
> 
> The DT binding assumes that there is a 1:1 map between physical connectors
> and connections, so there will be a connector described in the DT for each
> connection.
> 
> There is also the question about how the DT bindings will be extended to
> support other attributes (color/position/group) using the properties API.

I foresee lots of bikeshedding on that particular topic, but I don't think it 
will be a blocker. We need a volunteer to quickstart a discussion on the 
devicetree (or possible devicetree-spec) mailing list :-)

> But I believe that can be done as a follow-up, once the properties API is
> in mainline.
> 
> Best regards,
> Javier
> 
> Changes in v2:
> - Remove from the changelog a mention of devices that multiplex the
>   physical RCA connectors to be used for the S-Video Y and C signals
>   since it's a special case and it doesn't really work on the IGEPv2.
> 
>  .../devicetree/bindings/media/i2c/tvp5150.txt      | 59 +++++++++++++++++++
>  1 file changed, 59 insertions(+)
> :
> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt index
> 8c0fc1a26bf0..df555650b0b4 100644
> --- a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> @@ -26,8 +26,46 @@ Required Endpoint Properties for parallel
> synchronization: If none of hsync-active, vsync-active and
> field-even-active is specified, the endpoint is assumed to use embedded
> BT.656 synchronization.
> 
> +-Optional nodes:
> +- connectors: The list of tvp5150 input connectors available on a given
> +  board. The node should contain a child 'port' node for each connector.

I had understood this as meaning that connectors should be fully described in 
the connectors subnode, until I read through the whole patch and saw that 
dedicated DT nodes are needed for the connectors. I thus believe the paragraph 
should be reworded to avoid the ambiguity.

This being said, why do you need a connectors subnode ? Can't we just add the 
port nodes for the input ports directly in the tvp5150 node (or possibly in a 
ports subnode, as defined in the OF graph bindings).

> +  The tvp5150 has support for three possible connectors: 2 Composite and
> +  1 S-video. The "reg" property is used to specify which input connector
> +  is associated with each 'port', using the following possible values:
> +
> +  0: Composite0
> +  1: Composite1
> +  2: S-Video
> +
> +  The ports should have an endpoint subnode that is linked to a connector
> +  node defined in Documentation/devicetree/bindings/display/connector/.
> +  The linked connector compatible string should match the connector type.
> +
>  Example:
> 
> +composite0: connector@0 {
> +	compatible = "composite-video-connector";
> +	label = "Composite0";
> +
> +	port {
> +		comp0_out: endpoint {
> +			remote-endpoint = <&tvp5150_comp0_in>;
> +		};
> +	};
> +};
> +
> +svideo: connector@1 {
> +	compatible = "composite-video-connector";
> +	label = "S-Video";
> +
> +	port {
> +		svideo_out: endpoint {
> +			remote-endpoint = <&tvp5150_svideo_in>;
> +		};
> +	};
> +};
> +
>  &i2c2 {
>  	...
>  	tvp5150@5c {
> @@ -36,6 +74,27 @@ Example:
>  		pdn-gpios = <&gpio4 30 GPIO_ACTIVE_LOW>;
>  		reset-gpios = <&gpio6 7 GPIO_ACTIVE_LOW>;
> 
> +		connectors {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			/* Composite0 input */
> +			port@0 {
> +				reg = <0>;
> +				tvp5150_comp0_in: endpoint {
> +					remote-endpoint = <&comp0_out>;
> +				};
> +			};
> +
> +			/* S-Video input */
> +			port@2 {
> +				reg = <2>;
> +				tvp5150_svideo_in: endpoint {
> +					remote-endpoint = <&svideo_out>;
> +				};
> +			};
> +		};
> +
>  		port {
>  			tvp5150_1: endpoint {
>  				remote-endpoint = <&ccdc_ep>;

-- 
Regards,

Laurent Pinchart

