Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:53082 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbeKNIn3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 03:43:29 -0500
From: Luca Ceresoli <luca@lucaceresoli.net>
Subject: Re: [PATCH v4 1/4] dt-bindings: media: i2c: Add bindings for Maxim
 Integrated MAX9286
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, sakari.ailus@iki.fi
Cc: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
References: <20181102154723.23662-1-kieran.bingham@ideasonboard.com>
 <20181102154723.23662-2-kieran.bingham@ideasonboard.com>
Message-ID: <b3ef6780-a1a7-e86c-0dba-916d9398c1ef@lucaceresoli.net>
Date: Tue, 13 Nov 2018 23:42:56 +0100
MIME-Version: 1.0
In-Reply-To: <20181102154723.23662-2-kieran.bingham@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran, All,

sorry for joining this late... See below my considerations.

On 02/11/18 16:47, Kieran Bingham wrote:
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
> +			port@0 {
> +				reg = <0>;
> +				max9286_in0: endpoint {
> +					remote-endpoint = <&rdacm20_out0>;
> +				};
> +			};
> +
> +			port@1 {
> +				reg = <1>;
> +				max9286_in1: endpoint {
> +					remote-endpoint = <&rdacm20_out1>;
> +				};
> +			};
> +
> +			port@2 {
> +				reg = <2>;
> +				max9286_in2: endpoint {
> +					remote-endpoint = <&rdacm20_out2>;
> +				};
> +			};
> +
> +			port@3 {
> +				reg = <3>;
> +				max9286_in3: endpoint {
> +					remote-endpoint = <&rdacm20_out3>;
> +				};
> +			};
> +
> +			port@4 {
> +				reg = <4>;
> +				max9286_out: endpoint {
> +					data-lanes = <1 2 3 4>;
> +					remote-endpoint = <&csi40_in>;
> +				};
> +			};
> +		};
> +
> +		i2c@0 {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			reg = <0>;
> +
> +			camera@51 {
> +				compatible = "imi,rdacm20";
> +				reg = <0x51 0x61>;

I find this kind of address mapping is the weak point in this patchset.

The ser-deser chipset splits the world in "local" and "remote" side. The
camera node belongs to the remote side, but the 0x51 and 0x61 addresses
belong to the local side. Think about supporting N different main boards
and M remote boards. 0x51 might be available on some main boards but not
all. IMO under the camera@51 (even the i2c@0) node there should be only
remote hardware description. To support the N*M possible combinations,
there should be:

 * a DT for the main board mentioning only addresses for the
   local i2c bus, down to the i2c@0 with address-cells, size-cells and
   reg properties
 * a DT overlay for each remote board, mentioning the remote i2c
   chips with their physical addresses, but no local addresses

The only way I could devise to be generic is to bind each physical
remote address to a local address at runtime.

Also, to be implemented reliably, an address translation feature is
required on the local (de)ser chip.

So the question is: can the max9286 chip do i2c address translation?

Thanks,
-- 
Luca
