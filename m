Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f194.google.com ([209.85.167.194]:40352 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725735AbeKFFYA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 00:24:00 -0500
Date: Mon, 5 Nov 2018 14:02:38 -0600
From: Rob Herring <robh@kernel.org>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, sakari.ailus@iki.fi,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>, Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: Re: [PATCH v4 1/4] dt-bindings: media: i2c: Add bindings for Maxim
 Integrated MAX9286
Message-ID: <20181105200238.GA12435@bogus>
References: <20181102154723.23662-1-kieran.bingham@ideasonboard.com>
 <20181102154723.23662-2-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181102154723.23662-2-kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 02, 2018 at 03:47:20PM +0000, Kieran Bingham wrote:
> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> The MAX9286 deserializes video data received on up to 4 Gigabit
> Multimedia Serial Links (GMSL) and outputs them on a CSI-2 port using up
> to 4 data lanes.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> ---
> v3:
>  - Update binding descriptions
> 
> v4:
>  - Define the use of a CSI2 D-PHY
>  - Rename pwdn-gpios to enable-gpios (with inverted polarity)
>  - Remove clock-lanes mapping support
>  - rewrap text blocks
>  - Fix typos
> ---
>  .../bindings/media/i2c/maxim,max9286.txt      | 182 ++++++++++++++++++
>  1 file changed, 182 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
> new file mode 100644
> index 000000000000..672f6a4d417d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
> @@ -0,0 +1,182 @@
> +Maxim Integrated Quad GMSL Deserializer
> +---------------------------------------
> +
> +The MAX9286 deserializer receives video data on up to 4 Gigabit Multimedia
> +Serial Links (GMSL) and outputs them on a CSI-2 D-PHY port using up to 4 data
> +lanes.
> +
> +In addition to video data, the GMSL links carry a bidirectional control channel
> +that encapsulates I2C messages. The MAX9286 forwards all I2C traffic not
> +addressed to itself to the other side of the links, where a GMSL serializer
> +will output it on a local I2C bus. In the other direction all I2C traffic
> +received over GMSL by the MAX9286 is output on the local I2C bus.
> +
> +Required Properties:
> +
> +- compatible: Shall be "maxim,max9286"
> +- reg: I2C device address
> +
> +Optional Properties:
> +
> +- poc-supply: Regulator providing Power over Coax to the cameras
> +- enable-gpios: GPIO connected to the #PWDN pin with inverted polarity
> +
> +Required endpoint nodes:
> +-----------------------
> +
> +The connections to the MAX9286 GMSL and its endpoint nodes are modeled using
> +the OF graph bindings in accordance with the video interface bindings defined
> +in Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +The following table lists the port number corresponding to each device port.
> +
> +        Port            Description
> +        ----------------------------------------
> +        Port 0          GMSL Input 0
> +        Port 1          GMSL Input 1
> +        Port 2          GMSL Input 2
> +        Port 3          GMSL Input 3
> +        Port 4          CSI-2 Output
> +
> +Optional Endpoint Properties for GMSL Input Ports (Port [0-3]):
> +
> +- remote-endpoint: phandle to the remote GMSL source endpoint subnode in the
> +  remote node port.
> +
> +Required Endpoint Properties for CSI-2 Output Port (Port 4):
> +
> +- remote-endpoint: phandle to the remote CSI-2 sink endpoint node.
> +- data-lanes: array of physical CSI-2 data lane indexes.
> +
> +Required i2c-mux nodes:
> +----------------------
> +
> +Each GMSL link is modeled as a child bus of an i2c bus multiplexer/switch, in
> +accordance with bindings described in
> +Documentation/devicetree/bindings/i2c/i2c-mux.txt. The serializer device on the
> +remote end of the GMSL link shall be modelled as a child node of the
> +corresponding I2C bus.
> +
> +Required i2c child bus properties:
> +- all properties described as required i2c child bus nodes properties in
> +  Documentation/devicetree/bindings/i2c/i2c-mux.txt.
> +
> +Example:
> +-------
> +
> +	gmsl-deserializer@2c {
> +		compatible = "maxim,max9286";
> +		reg = <0x2c>;
> +		poc-supply = <&camera_poc_12v>;
> +		enable-gpios = <&gpio 13 GPIO_ACTIVE_LOW>;
> +
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		ports {
> +			#address-cells = <1>;
> +			#size-cells = <0>;

> +
> +		i2c@0 {
> +			#address-cells = <1>;
> +			#size-cells = <0>;

It's better to not have a mixture of nodes at a level with and without 
unit-addresses. So I'd move all the i2c nodes under an 'i2c-mux' node.

Rob
