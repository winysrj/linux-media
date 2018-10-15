Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:49426 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbeJPBYA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Oct 2018 21:24:00 -0400
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH v3 1/4] dt-bindings: media: i2c: Add bindings for Maxim
 Integrated MAX9286
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Jacopo Mondi <jacopo@jmondi.org>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
References: <20181009205726.7664-1-kieran.bingham@ideasonboard.com>
 <20181009205726.7664-2-kieran.bingham@ideasonboard.com>
 <20181015164524.kazxgbxwsc3abxok@valkosipuli.retiisi.org.uk>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <71c30ead-66cd-2c84-3349-0dd393f66300@ideasonboard.com>
Date: Mon, 15 Oct 2018 18:37:40 +0100
MIME-Version: 1.0
In-Reply-To: <20181015164524.kazxgbxwsc3abxok@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the review,

On 15/10/18 17:45, Sakari Ailus wrote:
> Hi Kieran,
> 
> Could you cc the devicetree list for the next version, please?

Argh - looks like I've missed the DT list on all three postings.

No wonder the responses have been quiet :-)

I'll do a v4 post after I've gone through some of your comments, and
make sure I remember the DT guys this time :)


> On Tue, Oct 09, 2018 at 09:57:23PM +0100, Kieran Bingham wrote:
>> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>>
>> The MAX9286 deserializes video data received on up to 4 Gigabit
>> Multimedia Serial Links (GMSL) and outputs them on a CSI-2 port using up
>> to 4 data lanes.
>>
>> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> ---
>> v3:
>>  - Update binding descriptions
>> ---
>>  .../bindings/media/i2c/maxim,max9286.txt      | 182 ++++++++++++++++++
>>  1 file changed, 182 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
>> new file mode 100644
>> index 000000000000..a73e3c0dc31b
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
>> @@ -0,0 +1,182 @@
>> +Maxim Integrated Quad GMSL Deserializer
>> +---------------------------------------
>> +
>> +The MAX9286 deserializer receives video data on up to 4 Gigabit Multimedia
>> +Serial Links (GMSL) and outputs them on a CSI-2 port using up to 4 data lanes.
> 
> CSI-2 D-PHY I presume?

Yes, that's how I've adapted the driver based on the latest bus changes.

Niklas - Could you confirm that everything in VIN/CSI2 is configured to
use D-PHY and not C-PHY at all ?


>> +
>> +In addition to video data, the GMSL links carry a bidirectional control
>> +channel that encapsulates I2C messages. The MAX9286 forwards all I2C traffic
>> +not addressed to itself to the other side of the links, where a GMSL
>> +serializer will output it on a local I2C bus. In the other direction all I2C
>> +traffic received over GMSL by the MAX9286 is output on the local I2C bus.
>> +
>> +Required Properties:
>> +
>> +- compatible: Shall be "maxim,max9286"
>> +- reg: I2C device address
>> +
>> +Optional Properties:
>> +
>> +- poc-supply: Regulator providing Power over Coax to the cameras
>> +- pwdn-gpios: GPIO connected to the #PWDN pin
> 
> If this is basically a hardware reset pin, then you could call it e.g.
> enable-gpios or reset-gpios. There was recently a similar discussion
> related to ad5820 DT bindings.

Ah yes ... now which polarity ;-)


>> +
>> +Required endpoint nodes:
>> +-----------------------
>> +
>> +The connections to the MAX9286 GMSL and its endpoint nodes are modeled using
>> +the OF graph bindings in accordance with the video interface bindings defined
>> +in Documentation/devicetree/bindings/media/video-interfaces.txt.
>> +
>> +The following table lists the port number corresponding to each device port.
>> +
>> +        Port            Description
>> +        ----------------------------------------
>> +        Port 0          GMSL Input 0
>> +        Port 1          GMSL Input 1
>> +        Port 2          GMSL Input 2
>> +        Port 3          GMSL Input 3
>> +        Port 4          CSI-2 Output
>> +
>> +Optional Endpoint Properties for GSML Input Ports (Port [0-3]):
> 
> Isn't port 4 included?

Hrm ... yes well I guess these are mandatory for port 4. I'll look at
the wording here.

> 
>> +
>> +- remote-endpoint: phandle to the remote GMSL source endpoint subnode in the
>> +  remote node port.
>> +
>> +Required Endpoint Properties for CSI-2 Output Port (Port 4):
>> +
>> +- data-lanes: array of physical CSI-2 data lane indexes.
>> +- clock-lanes: index of CSI-2 clock lane.
> 
> Is any number of lanes supported? How about lane remapping? If you do not
> have lane remapping, the clock-lanes property is redundant.


Uhm ... Niklas?


> 
>> +
>> +Required i2c-mux nodes:
>> +----------------------
>> +
>> +Each GMSL link is modeled as a child bus of an i2c bus multiplexer/switch, in
>> +accordance with bindings described in
>> +Documentation/devicetree/bindings/i2c/i2c-mux.txt. The serializer device on
>> +the remote end of the GMSL link shall be modelled as a child node of the
>> +corresponding I2C bus.
>> +
>> +Required i2c child bus properties:
>> +- all properties described as required i2c child bus nodes properties in
>> +  Documentation/devicetree/bindings/i2c/i2c-mux.txt.
>> +
>> +Example:
>> +-------
>> +
>> +	gmsl-deserializer@2c {
>> +		compatible = "maxim,max9286";
>> +		reg = <0x2c>;
>> +		poc-supply = <&camera_poc_12v>;
>> +		pwdn-gpios = <&gpio 13 GPIO_ACTIVE_LOW>;
>> +
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +
>> +		ports {
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +
>> +			port@0 {
>> +				reg = <0>;
>> +				max9286_in0: endpoint {
>> +					remote-endpoint = <&rdacm20_out0>;
>> +				};
>> +			};
>> +
>> +			port@1 {
>> +				reg = <1>;
>> +				max9286_in1: endpoint {
>> +					remote-endpoint = <&rdacm20_out1>;
>> +				};
>> +			};
>> +
>> +			port@2 {
>> +				reg = <2>;
>> +				max9286_in2: endpoint {
>> +					remote-endpoint = <&rdacm20_out2>;
>> +				};
>> +			};
>> +
>> +			port@3 {
>> +				reg = <3>;
>> +				max9286_in3: endpoint {
>> +					remote-endpoint = <&rdacm20_out3>;
>> +				};
>> +			};
>> +
>> +			port@4 {
>> +				reg = <4>;
>> +				max9286_out: endpoint {
>> +					clock-lanes = <0>;
>> +					data-lanes = <1 2 3 4>;
>> +					remote-endpoint = <&csi40_in>;
>> +				};
>> +			};
>> +		};
>> +
>> +		i2c@0 {
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +			reg = <0>;
>> +
>> +			camera@51 {
>> +				compatible = "imi,rdacm20";
>> +				reg = <0x51 0x61>;
> 
> What's the second value for in the reg property? There's more of the same
> below.
> 

These are specific to the RDACM20:

>From the RDACM20 documentation:

- reg: Pair of I2C device addresses, the first to be assigned to the
serializer, the second to be assigned to the camera sensor.

Each RDACM20 camera boots up with the same I2C addresses. The driver
remaps them to the new values specified here.

But they are not relevant to the max9286 except for the example of
adding in the rdacm20.


>> +
>> +				port {
>> +					rdacm20_out0: endpoint {
>> +						remote-endpoint = <&max9286_in0>;
>> +					};
>> +				};
>> +
>> +			};
>> +		};
>> +
>> +		i2c@1 {
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +			reg = <1>;
>> +
>> +			camera@52 {
>> +				compatible = "imi,rdacm20";
>> +				reg = <0x52 0x62>;
>> +				port {
>> +					rdacm20_out1: endpoint {
>> +						remote-endpoint = <&max9286_in1>;
>> +					};
>> +				};
>> +			};
>> +		};
>> +
>> +		i2c@2 {
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +			reg = <2>;
>> +
>> +			camera@53 {
>> +				compatible = "imi,rdacm20";
>> +				reg = <0x53 0x63>;
>> +				port {
>> +					rdacm20_out2: endpoint {
>> +						remote-endpoint = <&max9286_in2>;
>> +					};
>> +				};
>> +			};
>> +		};
>> +
>> +		i2c@3 {
>> +			#address-cells = <1>;
>> +			#size-cells = <0>;
>> +			reg = <3>;
>> +
>> +			camera@54 {
>> +				compatible = "imi,rdacm20";
>> +				reg = <0x54 0x64>;
>> +				port {
>> +					rdacm20_out3: endpoint {
>> +						remote-endpoint = <&max9286_in3>;
>> +					};
>> +				};
>> +			};
>> +		};
>> +	};
> 
