Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35959 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbcBHSXc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2016 13:23:32 -0500
Subject: Re: [PATCH 7/8] [media] tvp5150: document input connectors DT
 bindings
To: linux-kernel@vger.kernel.org
References: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
 <1454699398-8581-8-git-send-email-javier@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56B8DD18.3060802@osg.samsung.com>
Date: Mon, 8 Feb 2016 15:23:20 -0300
MIME-Version: 1.0
In-Reply-To: <1454699398-8581-8-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I noticed that I missed the DT folks in the cc list so I'm adding
them now, sorry for the noise...

On 02/05/2016 04:09 PM, Javier Martinez Canillas wrote:
> The tvp5150 decoder has different input connectors so extend the device
> tree binding to allow device tree source files to define the connectors
> that are available on a given board.
>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> ---
>
>   .../devicetree/bindings/media/i2c/tvp5150.txt      | 43 ++++++++++++++++++++++
>   1 file changed, 43 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> index 8c0fc1a26bf0..daa20e43a8e3 100644
> --- a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> @@ -12,6 +12,32 @@ Optional Properties:
>   - pdn-gpios: phandle for the GPIO connected to the PDN pin, if any.
>   - reset-gpios: phandle for the GPIO connected to the RESETB pin, if any.
>
> +Optional nodes:
> +- connectors: The input connectors of tvp5150 have to be defined under
> +  a subnode name "connectors" using the following format:
> +
> +	input-connector-name {
> +		input connector properties
> +	};
> +
> +Each input connector must contain the following properties:
> +
> +	- label: a name for the connector.
> +	- input: the input connector.
> +
> +The possible values for the "input" property are:
> +	0: Composite0
> +	1: Composite1
> +	2: S-Video
> +
> +and on a tvp5150am1 and tvp5151 there is another:
> +	4: Signal generator
> +
> +The list of valid input connectors are defined in dt-bindings/media/tvp5150.h
> +header file and can be included by device tree source files.
> +
> +Each input connector can be defined only once.
> +
>   The device node must contain one 'port' child node for its digital output
>   video port, in accordance with the video interface bindings defined in
>   Documentation/devicetree/bindings/media/video-interfaces.txt.
> @@ -36,6 +62,23 @@ Example:
>   		pdn-gpios = <&gpio4 30 GPIO_ACTIVE_LOW>;
>   		reset-gpios = <&gpio6 7 GPIO_ACTIVE_LOW>;
>
> +		connectors {
> +			composite0 {
> +				label = "Composite0";
> +				input = <TVP5150_COMPOSITE0>;
> +			};
> +
> +			composite1 {
> +				label = "Composite1";
> +				input = <TVP5150_COMPOSITE1>;
> +			};
> +
> +			s-video {
> +				label = "S-Video";
> +				input = <TVP5150_SVIDEO>;
> +			};
> +		};
> +
>   		port {
>   			tvp5150_1: endpoint {
>   				remote-endpoint = <&ccdc_ep>;
>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
