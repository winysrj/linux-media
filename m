Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43100 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbeKNJNj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 04:13:39 -0500
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v4 1/4] dt-bindings: media: i2c: Add bindings for Maxim
 Integrated MAX9286
To: Luca Ceresoli <luca@lucaceresoli.net>,
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
 <b3ef6780-a1a7-e86c-0dba-916d9398c1ef@lucaceresoli.net>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <66239f2a-0159-8120-6dbb-8af0ce8b132a@ideasonboard.com>
Date: Tue, 13 Nov 2018 15:12:55 -0800
MIME-Version: 1.0
In-Reply-To: <b3ef6780-a1a7-e86c-0dba-916d9398c1ef@lucaceresoli.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luca,

On 13/11/2018 14:42, Luca Ceresoli wrote:
> Hi Kieran, All,
> 
> sorry for joining this late... See below my considerations.

I'd say you're on time - not late,

Thanks for joining :)

> 
> On 02/11/18 16:47, Kieran Bingham wrote:
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
>>
>> v4:
>>  - Define the use of a CSI2 D-PHY
>>  - Rename pwdn-gpios to enable-gpios (with inverted polarity)
>>  - Remove clock-lanes mapping support
>>  - rewrap text blocks
>>  - Fix typos
>> ---
>>  .../bindings/media/i2c/maxim,max9286.txt      | 182 ++++++++++++++++++
>>  1 file changed, 182 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
>> new file mode 100644
>> index 000000000000..672f6a4d417d
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
>> @@ -0,0 +1,182 @@
>> +Maxim Integrated Quad GMSL Deserializer
>> +---------------------------------------
>> +
>> +The MAX9286 deserializer receives video data on up to 4 Gigabit Multimedia
>> +Serial Links (GMSL) and outputs them on a CSI-2 D-PHY port using up to 4 data
>> +lanes.
>> +
>> +In addition to video data, the GMSL links carry a bidirectional control channel
>> +that encapsulates I2C messages. The MAX9286 forwards all I2C traffic not
>> +addressed to itself to the other side of the links, where a GMSL serializer
>> +will output it on a local I2C bus. In the other direction all I2C traffic
>> +received over GMSL by the MAX9286 is output on the local I2C bus.
>> +
>> +Required Properties:
>> +
>> +- compatible: Shall be "maxim,max9286"
>> +- reg: I2C device address
>> +
>> +Optional Properties:
>> +
>> +- poc-supply: Regulator providing Power over Coax to the cameras
>> +- enable-gpios: GPIO connected to the #PWDN pin with inverted polarity
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
>> +Optional Endpoint Properties for GMSL Input Ports (Port [0-3]):
>> +
>> +- remote-endpoint: phandle to the remote GMSL source endpoint subnode in the
>> +  remote node port.
>> +
>> +Required Endpoint Properties for CSI-2 Output Port (Port 4):
>> +
>> +- remote-endpoint: phandle to the remote CSI-2 sink endpoint node.
>> +- data-lanes: array of physical CSI-2 data lane indexes.
>> +
>> +Required i2c-mux nodes:
>> +----------------------
>> +
>> +Each GMSL link is modeled as a child bus of an i2c bus multiplexer/switch, in
>> +accordance with bindings described in
>> +Documentation/devicetree/bindings/i2c/i2c-mux.txt. The serializer device on the
>> +remote end of the GMSL link shall be modelled as a child node of the
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
>> +		compatible = "maxim,max9286";Not at all late - Just on time 
>> +		reg = <0x2c>;
>> +		poc-supply = <&camera_poc_12v>;
>> +		enable-gpios = <&gpio 13 GPIO_ACTIVE_LOW>;
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
> I find this kind of address mapping is the weak point in this patchset.
> 
> The ser-deser chipset splits the world in "local" and "remote" side. The
> camera node belongs to the remote side, but the 0x51 and 0x61 addresses
> belong to the local side.

Well, in our use case - in fact the camera has a set of fixed addresses
(0x30,0x40,0x50) for each camera - and these are the addresses we are
requesting the camera to be updated to. Once the camera is communicated
with - the first step is to reprogram the device to respond to the
addresses specified here.


> Think about supporting N different main boards
> and M remote boards. 0x51 might be available on some main boards but not
> all. IMO under the camera@51 (even the i2c@0) node there should be only
> remote hardware description. To support the N*M possible combinations,
> there should be:

Of course - well in fact all of our I2C addresses across our two max9286
instances, and 8 camera devices share the same bus 'address space'.

It's crucial to provide this address on a per board level, which is why
it is specified in the DT.

I wonder if perhaps it was a mistake to include the camera description
in this part of the example, as it's not related to the max9286
specifically.

Rob has already suggested moving these to a lower 'i2c-node' level which
I like the sound of, and might make this separation more clear.


>  * a DT for the main board mentioning only addresses for the
>    local i2c bus, down to the i2c@0 with address-cells, size-cells and
>    reg properties
>  * a DT overlay for each remote board, mentioning the remote i2c
>    chips with their physical addresses, but no local addresses
> 
> The only way I could devise to be generic is to bind each physical
> remote address to a local address at runtime.
> 
> Also, to be implemented reliably, an address translation feature is
> required on the local (de)ser chip.
> 
> So the question is: can the max9286 chip do i2c address translation?
> 

Yes, The max9286 (deser) can do i2c address translation - but so too can
the max9271 (serialiser)

We do our address translation on the camera (serialiser) side.

The cameras *all* boot with the same i2c address (and thus all conflict)
 - We disable all links
 - We enable /one/ link
 - We initialise and reprogram the address of that camera to the address
   specified in the camera node. - Then we move to the next camera.

The reality is we 'just need' a spare address on the I2C bus - but as
yet - there is no mechanism in I2C core to request a spare address.

Thus it is the responsibility of the DT node to ensure there is no conflict.

For an example, here is our DT overlay file for our max9286 expansion board:

https://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git/commit/?h=gmsl/v5&id=6f2ec549e128b3ca36e9cae59256723cc39df2b1


> Thanks,
> 

-- 
Regards
--
Kieran
