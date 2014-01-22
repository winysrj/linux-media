Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45771 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaAVW1r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 17:27:47 -0500
Message-ID: <52E045DE.10706@gmail.com>
Date: Wed, 22 Jan 2014 23:27:42 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sebastian Reichel <sre@debian.org>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [RFCv2] Device Tree bindings for OMAP3 Camera System
References: <20131103220315.GA11659@earth.universe> <20140115194127.GA30988@earth.universe> <20140120041904.GH9997@valkosipuli.retiisi.org.uk> <52DDA04B.90809@gmail.com> <20140120232719.GA30894@earth.universe>
In-Reply-To: <20140120232719.GA30894@earth.universe>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/21/2014 12:27 AM, Sebastian Reichel wrote:
> On Mon, Jan 20, 2014 at 11:16:43PM +0100, Sylwester Nawrocki wrote:
>> On 01/20/2014 05:19 AM, Sakari Ailus wrote:
[...]
>>>> - #address-cells: Should be set to<1>.
>>>> - #size-cells   : Should be set to<0>.
>>>
>>> The ISP also exports clocks. Shouldn't you add
>>>
>>> #clock-cells =<1>;
>
> Ok. I already though about that possibility, but wasn't sure which
> way is the cleaner one. Thanks for clarifying.
>
>> [...]
>>
>> This doesn't seem to follow the common clock bindings.
>
> I think it does follow common clock bindings at least. Clocks can
> referenced with the following statement:
>
> camera-sensor-0 {
>      clocks =<&isp_xclk1>;
>      clock-names = ...
> };

Yes, sorry, I think you're right. I guess it was just #clock-cells not
being used optimally.

>> Instead, you could define value of #clock-cells to be 1 and allow clocks
>> consumers to reference the provider node in a standard way, e.g.:
>
> This also works and probably better. I will merge clock provider
> into the main omap3isp node.
>
>> [...]
>>>> endpoint subnode for serial interfaces
>>>> --------------------------------------
>>>>
>>>> Required properties:
>>>>   - ti,isp-interface-type    : should be one of the following values
>>>
>>> I think the interface type should be standardised at V4L2 level. We
>>> currently do not do that, but instead do a little bit of guessing.
>>
>> I'm all for such a standard property. It seems much more clear to use such
>> a property. And I already run into issues with deriving the bus interface
>> type from existing properties, please see https://linuxtv.org/patch/19937
>>
>> I assume it would be fine to add a string type property like
>> "interface-type"
>> or "bus-type".
>>
>>>>    *<0>   to use the phy in CSI mode
>>>>    *<1>   to use the phy in CCP mode
>>>>    *<2>   to use the phy in CCP mode, but configured for MIPI CSI2
>
> mh... from what I understand a port can be configured to be either
> CSI2 or CPP2 type. If CCP2 type is chosen the port can be configured
> to be CSI1 mode instead of actually being CPP2. See
>
> see "struct isp_ccp2_platform_data" in include/media/omap3isp.h.
>
> But actually I made a typo above. This is what I meant:
>
> *<0>   to use the phy in MIPI CSI2 mode
> *<1>   to use the phy in SMIA CCP2 mode
> *<2>   to use the phy in SMIA CCP2 mode, but configured for MIPI CSI1
>
> I'm not sure if this can be properly be described in a standardized
> type property.

Hmm, are there any other combinations involving MIPI CSI1 ?

Couldn't we just say that there are: MIPI CSI2, SMIA CCP2 and MIPI CSI1
protocols/bus types used ?

[...]
>>>> - data-lanes: an array of physical data lane indexes. Position of an entry
>>>>    determines the logical lane number, while the value of an entry indicates
>>>>    physical lane, e.g. for 2-lane MIPI CSI-2 bus we could have
>>>>    "data-lanes =<1 2>;", assuming the clock lane is on hardware lane 0.
>>>>    This property is valid for serial busses only (e.g. MIPI CSI-2).
>>>> - clock-lanes: an array of physical clock lane indexes. Position of an entry
>>>>    determines the logical lane number, while the value of an entry indicates
>>>>    physical lane, e.g. for a MIPI CSI-2 bus we could have "clock-lanes =<0>;",
>>>>    which places the clock lane on hardware lane 0. This property is valid for
>>>>    serial busses only (e.g. MIPI CSI-2). Note that for the MIPI CSI-2 bus this
>>>>    array contains only one entry.
>>>
>>> I'd rather refer to
>>> Documentation/devicetree/bindings/media/video-interfaces.txt than copy from
>>> it. It's important that there's a single definition for the standard
>>> properties. Just mentioning the property by name should be enough. What do
>>> you think?
>>
>> +1
>
> sounds fine to me. Something like this?
>
> - data-lanes: see [0]
> - clock-lanes: see [0]
>
> [0] Documentation/devicetree/bindings/media/video-interfaces.txt

I guess it would be fine.

[...]
>>>> camera-switch {
>>>>      /*
>>>>       * TODO:
>>>>       *  - check if the switching code is generic enough to use a
>>>>       *    more generic name like "gpio-camera-switch".
>>>>       *  - document the camera-switch binding
>>>>       */
>>>>      compatible = "nokia,n900-camera-switch";
>>>
>>> Indeed. I don't think the hardware engineers realised what kind of a long
>>> standing issue they created for us when they chose that solution. ;)
>>>
>>> Writing a small driver for this that exports a sub-device would probably be
>>> the best option as this is hardly very generic. Should this be shown to the
>>> user space or not? Probably it'd be nice to avoid showing the related sub-device
>>> if there would be one.
>>
>> Probably we should avoid exposing such a hardware detail to user space.
>> OTOH it would be easy to handle as a media entity through the media
>> controller API.
>
> If this is exposed to the userspace, then a userspace application
> "knows", that it cannot use both cameras at the same time. Otherwise
> it can just react to error messages when it tries to use the second
> camera.

Indeed, that's a good argument, I forgot about it for a while.

>>> I'm still trying to get N9 support working first, the drivers are in a
>>> better shape and there are no such hardware hacks.
>>>
>>>>      gpios =<&gpio4 1>; /* 97 */
>>
>> I think the binding should be defining how state of the GPIO corresponds
>> to state of the mux.
>
> Obviously it should be mentioned in the n900-camera-switch binding
> Documentation. This document was just the proposal for the omap3isp
> node :)

Huh, I wasn't reading carefully enough! Then since it is just about the
OMAP3 ISP it might be a good idea to drop the switch from the example,
it seems unrelated.

>>>>      port@0 {
>>>>          switch_in: endpoint {
>>>>              remote-endpoint =<&csi1_ep>;
>>>>          };
>>>>
>>>>          switch_out1: endpoint {
>>>>              remote-endpoint =<&et8ek8>;
>>>>          };
>>>>
>>>>          switch_out2: endpoint {
>>>>              remote-endpoint =<&smiapp_dfl>;
>>>>          };
>>>>      };
>>
>> This won't work, since names of the nodes are identical they will be
>> combined by the dtc into a single 'endpoint' node with single
>> 'remote-endpoint' property
>> - might not be exactly something that you want.
>> So it could be rewritten like:
>
> right.
>
>> [...]
>> However, simplifying a bit, the 'endpoint' nodes are supposed to describe
>> the configuration of a bus interface (port) for a specific remote device.
>> Then what you need might be something like:
>>
>>   camera-switch {
>> 	compatible = "nokia,n900-camera-switch";
>>
>> 	#address-cells =<1>;
>> 	#size-cells =<0>;
>>
>> 	switch_in: port@0 {
>> 		reg =<0>;
>> 		endpoint {
>> 			remote-endpoint =<&csi1_ep>;
>> 		};
>> 	};
>>
>>          switch_out1: port@1 {
>> 		reg =<1>;
>> 		endpoint {
>> 			remote-endpoint =<&et8ek8>;
>> 		};
>> 	};
>>
>> 	switch_out2: port@2 {
>> 		endpoint {
>> 			reg =<2>;
>> 			remote-endpoint =<&smiapp_dfl>;
>> 		};
>> 	};
>>   };
>
> sounds fine to me.
>
>> I'm just wondering if we need to be describing this in DT in such
>> detail.
>
> Do you have an alternative suggestion for the N900's bus switch
> hack?

No, not really anything better at the moment.

--
Thanks,
Sylwester
