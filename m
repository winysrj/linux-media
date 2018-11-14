Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:58938 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732765AbeKNUG7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 15:06:59 -0500
Subject: Re: [PATCH v4 1/4] dt-bindings: media: i2c: Add bindings for Maxim
 Integrated MAX9286
To: kieran.bingham@ideasonboard.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        sakari.ailus@iki.fi
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
 <66239f2a-0159-8120-6dbb-8af0ce8b132a@ideasonboard.com>
From: Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <d699e133-1459-7ce8-18e4-47bad5f66314@lucaceresoli.net>
Date: Wed, 14 Nov 2018 11:04:09 +0100
MIME-Version: 1.0
In-Reply-To: <66239f2a-0159-8120-6dbb-8af0ce8b132a@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On 14/11/18 00:12, Kieran Bingham wrote:
> Hi Luca,
> 
> On 13/11/2018 14:42, Luca Ceresoli wrote:
>> Hi Kieran, All,
>>
>> sorry for joining this late... See below my considerations.
> 
> I'd say you're on time - not late,
> 
> Thanks for joining :)
> 
>>
>> On 02/11/18 16:47, Kieran Bingham wrote:
>>> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>>>
>>> The MAX9286 deserializes video data received on up to 4 Gigabit
>>> Multimedia Serial Links (GMSL) and outputs them on a CSI-2 port using up
>>> to 4 data lanes.
>>>
>>> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>>
>>> ---
>>> v3:
>>>  - Update binding descriptions
>>>
>>> v4:
>>>  - Define the use of a CSI2 D-PHY
>>>  - Rename pwdn-gpios to enable-gpios (with inverted polarity)
>>>  - Remove clock-lanes mapping support
>>>  - rewrap text blocks
>>>  - Fix typos
>>> ---
>>>  .../bindings/media/i2c/maxim,max9286.txt      | 182 ++++++++++++++++++
>>>  1 file changed, 182 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
>>> new file mode 100644
>>> index 000000000000..672f6a4d417d
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
>>> @@ -0,0 +1,182 @@
>>> +Maxim Integrated Quad GMSL Deserializer
>>> +---------------------------------------
>>> +
>>> +The MAX9286 deserializer receives video data on up to 4 Gigabit Multimedia
>>> +Serial Links (GMSL) and outputs them on a CSI-2 D-PHY port using up to 4 data
>>> +lanes.
>>> +
>>> +In addition to video data, the GMSL links carry a bidirectional control channel
>>> +that encapsulates I2C messages. The MAX9286 forwards all I2C traffic not
>>> +addressed to itself to the other side of the links, where a GMSL serializer
>>> +will output it on a local I2C bus. In the other direction all I2C traffic
>>> +received over GMSL by the MAX9286 is output on the local I2C bus.
>>> +
>>> +Required Properties:
>>> +
>>> +- compatible: Shall be "maxim,max9286"
>>> +- reg: I2C device address
>>> +
>>> +Optional Properties:
>>> +
>>> +- poc-supply: Regulator providing Power over Coax to the cameras
>>> +- enable-gpios: GPIO connected to the #PWDN pin with inverted polarity
>>> +
>>> +Required endpoint nodes:
>>> +-----------------------
>>> +
>>> +The connections to the MAX9286 GMSL and its endpoint nodes are modeled using
>>> +the OF graph bindings in accordance with the video interface bindings defined
>>> +in Documentation/devicetree/bindings/media/video-interfaces.txt.
>>> +
>>> +The following table lists the port number corresponding to each device port.
>>> +
>>> +        Port            Description
>>> +        ----------------------------------------
>>> +        Port 0          GMSL Input 0
>>> +        Port 1          GMSL Input 1
>>> +        Port 2          GMSL Input 2
>>> +        Port 3          GMSL Input 3
>>> +        Port 4          CSI-2 Output
>>> +
>>> +Optional Endpoint Properties for GMSL Input Ports (Port [0-3]):
>>> +
>>> +- remote-endpoint: phandle to the remote GMSL source endpoint subnode in the
>>> +  remote node port.
>>> +
>>> +Required Endpoint Properties for CSI-2 Output Port (Port 4):
>>> +
>>> +- remote-endpoint: phandle to the remote CSI-2 sink endpoint node.
>>> +- data-lanes: array of physical CSI-2 data lane indexes.
>>> +
>>> +Required i2c-mux nodes:
>>> +----------------------
>>> +
>>> +Each GMSL link is modeled as a child bus of an i2c bus multiplexer/switch, in
>>> +accordance with bindings described in
>>> +Documentation/devicetree/bindings/i2c/i2c-mux.txt. The serializer device on the
>>> +remote end of the GMSL link shall be modelled as a child node of the
>>> +corresponding I2C bus.
>>> +
>>> +Required i2c child bus properties:
>>> +- all properties described as required i2c child bus nodes properties in
>>> +  Documentation/devicetree/bindings/i2c/i2c-mux.txt.
>>> +
>>> +Example:
>>> +-------
>>> +
>>> +	gmsl-deserializer@2c {
>>> +		compatible = "maxim,max9286";Not at all late - Just on time 
>>> +		reg = <0x2c>;
>>> +		poc-supply = <&camera_poc_12v>;
>>> +		enable-gpios = <&gpio 13 GPIO_ACTIVE_LOW>;
>>> +
>>> +		#address-cells = <1>;
>>> +		#size-cells = <0>;
>>> +
>>> +		ports {
>>> +			#address-cells = <1>;
>>> +			#size-cells = <0>;
>>> +
>>> +			port@0 {
>>> +				reg = <0>;
>>> +				max9286_in0: endpoint {
>>> +					remote-endpoint = <&rdacm20_out0>;
>>> +				};
>>> +			};
>>> +
>>> +			port@1 {
>>> +				reg = <1>;
>>> +				max9286_in1: endpoint {
>>> +					remote-endpoint = <&rdacm20_out1>;
>>> +				};
>>> +			};
>>> +
>>> +			port@2 {
>>> +				reg = <2>;
>>> +				max9286_in2: endpoint {
>>> +					remote-endpoint = <&rdacm20_out2>;
>>> +				};
>>> +			};
>>> +
>>> +			port@3 {
>>> +				reg = <3>;
>>> +				max9286_in3: endpoint {
>>> +					remote-endpoint = <&rdacm20_out3>;
>>> +				};
>>> +			};
>>> +
>>> +			port@4 {
>>> +				reg = <4>;
>>> +				max9286_out: endpoint {
>>> +					data-lanes = <1 2 3 4>;
>>> +					remote-endpoint = <&csi40_in>;
>>> +				};
>>> +			};
>>> +		};
>>> +
>>> +		i2c@0 {
>>> +			#address-cells = <1>;
>>> +			#size-cells = <0>;
>>> +			reg = <0>;
>>> +
>>> +			camera@51 {
>>> +				compatible = "imi,rdacm20";
>>> +				reg = <0x51 0x61>;
>>
>> I find this kind of address mapping is the weak point in this patchset.
>>
>> The ser-deser chipset splits the world in "local" and "remote" side. The
>> camera node belongs to the remote side, but the 0x51 and 0x61 addresses
>> belong to the local side.
> 
> Well, in our use case - in fact the camera has a set of fixed addresses
> (0x30,0x40,0x50) for each camera - and these are the addresses we are
> requesting the camera to be updated to. Once the camera is communicated
> with - the first step is to reprogram the device to respond to the
> addresses specified here.

Yes, the way it works is clear.

>> Think about supporting N different main boards
>> and M remote boards. 0x51 might be available on some main boards but not
>> all. IMO under the camera@51 (even the i2c@0) node there should be only
>> remote hardware description. To support the N*M possible combinations,
>> there should be:
> 
> Of course - well in fact all of our I2C addresses across our two max9286
> instances, and 8 camera devices share the same bus 'address space'.
> 
> It's crucial to provide this address on a per board level, which is why
> it is specified in the DT.
> 
> I wonder if perhaps it was a mistake to include the camera description
> in this part of the example, as it's not related to the max9286
> specifically.

Interesting point. In my case I'm thinking DT overlays, they help me a
lot in finding a proper generalization. With some generalization, camera
modules [the same would happen with display modules] are similar to
beaglebone capes or rpi hats:

 1. there can be different camera modules being designed over time
 2. there can be different base boards being designed over time
 3. there is a standard interconnection between them (mechanical,
    electrical, communication bus)
 4. camera modules and base boards are designed and sold independently
    (thanks to point 3)

Overlays are a natural choice in this case. Even bootloader-time
overlays will suffice for my reasoning, let's remove the hotplug mess
from this discussion.

Now, in this patch you are modeling the remote camera as if it were a
"normal" I2C device, except:

 a) it has 2 slave addresses (no problem with this)
 b) the 2 slave addresses in DT are not the physical ones

With this model it seems natural to write "camera@51/reg = <0x51 0x61>"
in the camera DT overlay. Except 0x51 and 0x61 do not exist on the
camera module, those numbers come from the base board, since you know
those two addresses are not used on the bus where gmsl-deserializer@2c
is. But it works.

Then one year later a random SBC vendor starts selling a new base board
that has on the same i2c bus a GMSL deser and a random i2c chip,
unrelated to cameras, at address 0x51. Bang, the camera sensor does not
work anymore, but there is no hardware reason for it not to work. Well,
easy to fix, find an address that is unused on all known base boards and
replace, say, 0x51->0x71 in the camera overlay. (OK, I violated the "DT
as a stable ABI" principle)

But then other boards appear and, taking this to an extreme, you can get
to a situation where every i2c address is used on at least one board.
How do you fix that?

Maybe this scenario is a bit too apocalyptic, and maybe too much for
current automotive uses, but I think it illustrates how the current
model is not generic enough. Since there is no existing code in the
kernel yet, I think we should strive to do better in order to minimize
future problems.


My approach is instead to clearly split the local and remote domain. The
latter is what could be moved to an overlay. For example:

&i2c0 {
    serializer@3d {
        reg = <0x3d>;
        ...

        /* Guaranteed not physically present on i2c0 */
        i2c-alias-pool = /bits/ 16 <0x20 0x21 0x22 0x23 0x24 0x25>;

        i2c-mux {
            #address-cells = <1>;
            #size-cells = <0>;

	    i2c@0 {
                reg = <0>;
                #address-cells = <1>;
                #size-cells = <0>;

                // ------8<------ this could be moved to an overlay
                sensor@50 {
                    reg = <0x50>;
                    ...
                    endpoint {...};
                };
                eeprom@51 {
                    reg = <0x51>;
                    ...
                };
                // ------8<------
            };

	    i2c@1 {
                reg = <1>;
                #address-cells = <1>;
                #size-cells = <0>;

                // ------8<------
                sensor@50 {
                    reg = <0x50>;
                    ...
                    endpoint {...};
                };
                eeprom@51 {
                    reg = <0x51>;
                    ...
                };
                // ------8<------
            };
        };
    };
};

The core difference is that I split the camera@51/reg property in two:

 * sensor@50/reg: the remote side (camera overlay);
   carries the physical i2c address (note both sensors are at 0x50)
 * serializer@3d/i2c-alias-pool: the local side (base board);
   lists a pool of addresses that are not used on the i2c bus

See how there is no mixing between local and remote. The pool will
differ from one base board to another.

To implement this, I developed an "i2c address translator" that maps
physical remote addresses to local addresses from the pool at runtime.
It still needs some work, but address translation it is working.

>>  * a DT for the main board mentioning only addresses for the
>>    local i2c bus, down to the i2c@0 with address-cells, size-cells and
>>    reg properties
>>  * a DT overlay for each remote board, mentioning the remote i2c
>>    chips with their physical addresses, but no local addresses
>>
>> The only way I could devise to be generic is to bind each physical
>> remote address to a local address at runtime.
>>
>> Also, to be implemented reliably, an address translation feature is
>> required on the local (de)ser chip.
>>
>> So the question is: can the max9286 chip do i2c address translation?
>>
> 
> Yes, The max9286 (deser) can do i2c address translation - but so too can
> the max9271 (serialiser)

Good!

> We do our address translation on the camera (serialiser) side.

By "address translation" I mean the i2c address is changed by some
device in the middle between the i2c master and the slave. In this sense
you are not doing address translation, you are rather modifying the chip
addresses. Then transactions happen with the new (0x51/0x61) address,
which does not get modified during subsequent transactions.

> The cameras *all* boot with the same i2c address (and thus all conflict)
>  - We disable all links
>  - We enable /one/ link
>  - We initialise and reprogram the address of that camera to the address
>    specified in the camera node. - Then we move to the next camera.
> 
> The reality is we 'just need' a spare address on the I2C bus - but as
> yet - there is no mechanism in I2C core to request a spare address.

Not a reliable one, definitely, since there could be i2c devices unknown
to the software. This is why I had to introduce the alias pool: the DT
writer is required to know which addresses are available and list them
in DT.

-- 
Luca
