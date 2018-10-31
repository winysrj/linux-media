Return-path: <linux-media-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:48272 "EHLO mail.mleia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbeKAFMa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Nov 2018 01:12:30 -0400
Subject: Re: [PATCH 2/7] dt-bindings: mfd: ds90ux9xx: add description of TI
 DS90Ux9xx I2C bridge
To: Luca Ceresoli <luca@lucaceresoli.net>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
References: <20181008211205.2900-1-vz@mleia.com>
 <20181008211205.2900-3-vz@mleia.com>
 <b9a617da-1712-2d28-d25c-e3c413a4e9f0@lucaceresoli.net>
From: Vladimir Zapolskiy <vz@mleia.com>
Message-ID: <2c90affe-0972-751d-8312-3d15d130c3fb@mleia.com>
Date: Wed, 31 Oct 2018 22:12:37 +0200
MIME-Version: 1.0
In-Reply-To: <b9a617da-1712-2d28-d25c-e3c413a4e9f0@lucaceresoli.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luca,

thank you for review.

On 10/30/2018 06:43 PM, Luca Ceresoli wrote:
> Hi Vladimir,
> 
> On 08/10/18 23:12, Vladimir Zapolskiy wrote:
>> From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
>>
>> TI DS90Ux9xx de-/serializers are capable to route I2C messages to
>> I2C slave devices connected to a remote de-/serializer in a pair,
>> the change adds description of device tree bindings of the subcontroller
>> to configure and enable this functionality.
>>
>> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
>> ---
>>  .../bindings/mfd/ti,ds90ux9xx-i2c-bridge.txt  | 61 +++++++++++++++++++
>>  1 file changed, 61 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/mfd/ti,ds90ux9xx-i2c-bridge.txt
>>
>> diff --git a/Documentation/devicetree/bindings/mfd/ti,ds90ux9xx-i2c-bridge.txt b/Documentation/devicetree/bindings/mfd/ti,ds90ux9xx-i2c-bridge.txt
>> new file mode 100644
>> index 000000000000..4169e382073a
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mfd/ti,ds90ux9xx-i2c-bridge.txt
>> @@ -0,0 +1,61 @@
>> +TI DS90Ux9xx de-/serializer I2C bridge subcontroller
>> +
>> +Required properties:
>> +- compatible: Must contain a generic "ti,ds90ux9xx-i2c-bridge" value and
>> +	may contain one more specific value from the list:
>> +	"ti,ds90ux925-i2c-bridge",
>> +	"ti,ds90ux926-i2c-bridge",
>> +	"ti,ds90ux927-i2c-bridge",
>> +	"ti,ds90ux928-i2c-bridge",
>> +	"ti,ds90ux940-i2c-bridge".
>> +
>> +Required properties of a de-/serializer device connected to a local I2C bus:
>> +- ti,i2c-bridges: List of phandles to remote de-/serializer devices with
>> +	two arguments: id of a local de-/serializer FPD link and an assigned
>> +	I2C address of a remote de-/serializer to be accessed on a local
>> +	I2C bus.
>> +
>> +Optional properties of a de-/serializer device connected to a local I2C bus:
>> +- ti,i2c-bridge-maps: List of 3-cell values:
>> +	- the first argument is id of a local de-/serializer FPD link,
>> +	- the second argument is an I2C address of a device connected to
>> +	  a remote de-/serializer IC,
>> +	- the third argument is an I2C address of the remote I2C device
>> +	  for access on a local I2C bus.
> 
> BTW I usually use names "remove slave" address and "alias" for bullets 2
> and 3. These are the names from the datasheets, and are clearer IMO.
> 

Definitely you are correct, I find that verbose descriptions might be
more appropriate and self-explanatory for anyone, who is not closely familiar
with the IC series. I'll consider to add the names from the datasheets
as well.

> Now to the big stuff.
> 
> I find a static map in the "local" chip DT node is a limit. You might
> have to support multiple models of remote device, where you'll know the
> model only when after it gets connected. Think Beaglebone capes, but
> over FPD-Link 3. This scenario opens several issues, but specifically
> for I2C address mapping I addressed it by adding in the "local" chip's
> DT node a pool of I2C aliases it can use. The DT author is responsible
> to pick addresses that are not used on the same I2C bus, which cannot be
> done at runtime reliably.

Here I see several important topics raised.

1) A static map in the "local" chip DT node is not a limit in sense that
   it is optional, so it would be a working model just to omit the property,
   however it may (or may not) require another handlers to bridge remote
   I2C devices, for instance 'ti,i2c-bridge-pass-all' property, or new
   UAPI.

2) About supporting multiple models of remote PCBs in the same dts file,
   it might be an excessive complication to predict a proper description
   of an unknown in advance complex device, so, a better solution should
   be to apply DT overlays in runtime, but at any time the hardware
   description and the mapping shall be precisely defined.

3) About a pool of vacant I2C addresses, I dislike the idea that there
   will be no definite or constant I2C address in runtime for a particular
   remote slave device. As I've mentioned above, it would be better to
   utilize DT overlays to handle "multiple models of remote device"
   dynamically in runtime, adding this feature could be done on top of
   the shown code.

> Here's my current draft on a dual/quad port deserializer:
> 
> &i2c0 {
>     serializer@3d {
>         reg = <0x3d>;
>         ...
> 
>         /* Guaranteed not physically present on i2c0 */
>         i2c-alias-pool = /bits/ 8 <0x20 0x21 0x22 0x23 0x24 0x25>;
> 
>         rxports {
>             #address-cells = <1>;
>             #size-cells = <0>;
> 
>             rxport@0 {
>                 reg = <0>;
>                 remote-i2c-bus { /* The proxied I2C bus on rxport 0 */
>                     #address-cells = <1>;
>                     #size-cells = <0>;
> 
>                     eeprom@51 {
>                         reg = <0x51>;
>                         compatible = "at,24c02";
>                     };
>                 };
> 
>             rxport@1 {
>                 reg = <1>;
>                 remote-i2c-bus { /* The proxied I2C bus on rxport 1 */
>                     #address-cells = <1>;
>                     #size-cells = <0>;
> 
>                     eeprom@51 {
>                         reg = <0x51>;
>                         compatible = "at,24c02";
>                     };
>                 };
>             };
>         };
>     };
> };
> 
> At probe time the serializer driver instantiates one new i2c_adapter for
> each rxport. Any remote device is added (removed) to that adapter, then
> the driver finds an available alias and maps (unmaps) it. The

I avoid using i2c_adapter object, because then you get a confusing access
to right the same device on two logical I2C buses. This is not the way
how I2C muxes operate or are expected to operate, commonly I2C muxes contain
a protocol to access muxed devices, which are "invisible" on a host bus,
and here a local IC behaves like an I2C device with multiple addresses.

Note, that following an advice from Wolfram I'm going to send the i2c-bridge
cell driver into inclusion under drivers/i2c/muxes/ , even if the device
driver does not register a mux.

> transactions are handled in a way similar to i2c-mux, i.e. the ds90*
> i2c_adapter has a master_xfer callback that changes the remote slave
> address to the corresponding alias, then calls parent->algo->master_xfer().
> 
> Note how both eeproms in the example have the same physical address.
> They will be given two different aliases.

The question is how to determine which runtime assigned address represents
which eeprom of two. The remote/alias scheme I propose makes it transparent.

>> +- ti,i2c-bridge-auto-ack: Enables AUTO ACK mode.
> 
> It this useful other than for debugging? And, as Laurent noted, this
> should not be in DT: it doesn't describe the hardware.
> 

I'll drop it, I've just checked that it is unused in any of production dts
files, which are accessible to me.

By "hardware description" I generally mean a hardware specific handle.
If IC supports a meaningful, one time programmable non-standard 1-bit field
configuration, then using a bool property in DT sounds reasonable to me.

>> +- ti,i2c-bridge-pass-all: Enables PASS ALL mode, remote I2C slave devices
>> +	are accessible on a local (host) I2C bus without I2C address
>> +	remappings.
> 
> It should be clear from the DT docs that either ti,i2c-bridge-pass-all
> is enabled or the alias map/pool is used, but not both.
> 

Sure, I'll add this information, thank you for pointing it out.

--
Best wishes,
Vladimir
