Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26716 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbbD3MxH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 08:53:07 -0400
Message-id: <554225AF.9040900@samsung.com>
Date: Thu, 30 Apr 2015 14:53:03 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net
Subject: Re: [PATCH v1 09/11] DT: Add documentation for exynos4-is 'flashes'
 property
References: <1426863811-12516-1-git-send-email-j.anaszewski@samsung.com>
 <1426863811-12516-10-git-send-email-j.anaszewski@samsung.com>
 <20150325010641.GI18321@valkosipuli.retiisi.org.uk>
 <55127732.7020004@samsung.com> <551E711C.2080802@samsung.com>
In-reply-to: <551E711C.2080802@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari and Sylwester,

On 04/03/2015 12:53 PM, Sylwester Nawrocki wrote:
> Hello,
>
> On 25/03/15 09:52, Jacek Anaszewski wrote:
>> On 03/25/2015 02:06 AM, Sakari Ailus wrote:
>>> On Fri, Mar 20, 2015 at 04:03:29PM +0100, Jacek Anaszewski wrote:
>>>> This patch adds a description of 'flashes' property
>>>> to the samsung-fimc.txt.
>>>>
>>>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>>> ---
>>>>    .../devicetree/bindings/media/samsung-fimc.txt     |    8 ++++++++
>>>>    1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
>>>> index 922d6f8..cb0e263 100644
>>>> --- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
>>>> +++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
>>>> @@ -40,6 +40,13 @@ should be inactive. For the "active-a" state the camera port A must be activated
>>>>    and the port B deactivated and for the state "active-b" it should be the other
>>>>    way around.
>>>>
>>>> +Optional properties:
>>>> +
>>>> +- flashes - Array of phandles to the flash LEDs that can be controlled by the
>>>> +	    sub-devices contained in this media device. Flash LED is
>>>> +	    represented by a child node of a flash LED device
>>>
>>> This should be in
>>> Documentation/devicetree/bindings/media/video-interfaces.txt.

This file documents DT nodes starting from the level one below
the camera node aggregating all the devices belonging to the media
device (I am referring to the 'camera' node from the file
arch/arm/boot/dts/exynos4412-trats2.dts). Should 'leds' property be
put there, the aggregating node would have to be described there at
first. I am wondering whether video-interfaces is a suitable place
for documenting illuminators, though.

>>> Should flash devices be associated with sensors somehow rather than ISPs?
>>> That's how they commonly are arranged, however that doesn't limit placing
>>> them in silly places.
>>>
>>> I'm not necessarily saying the flashes-property should be present in
>>> sensor's DT nodes, but it'd be good to be able to make the association if
>>> it's there.
>
> IMHO 'flashes' is a misleading name, these are simply high brightness LEDs
> which can work as camera flash or auxiliary light for camcording, in context of
> a camera device.
>
> The led DT nodes which the entries of above flashes property is pointing to
> have a text label, which presumably could be used to associate a LED device
> with an image sensor. That said, I think we should allow a property as above
> 'flashes' be placed in aggregate camera node and also in sensor device node.
> I think it should be left to the bridge/ISP binding to choose one option or
> the other.

I agree.

> For now I would propose to rename the "flashes" property to "samsung,leds" or
> "leds" and leave it in "camera" node.

How about flash-leds?

>> I know of a SoC, which drives the flash from its on-chip ISP. The GPIO
>> connected to the flash controller's external strobe pin can be
>> configured so that the signal is routed to it from the ISP or from
>> CPU (for software strobe mode).
>>
>> I think that Sylwester could say more in this subject.
>>
>>
>>>> +	    (see Documentation/devicetree/bindings/leds/common.txt).
>>>> +
>>>>    The 'camera' node must include at least one 'fimc' child node.
>>>>
>>>>
>>>> @@ -166,6 +173,7 @@ Example:
>>>>    		clock-output-names = "cam_a_clkout", "cam_b_clkout";
>>>>    		pinctrl-names = "default";
>>>>    		pinctrl-0 = <&cam_port_a_clk_active>;
>>>> +		flashes = <&camera_flash>, <&system_torch>;
>>>>    		status = "okay";
>>>>    		#address-cells = <1>;
>>>>    		#size-cells = <1>;
>>>
>>> There will be other kind of devices that have somewhat similar relationship.
>>> They just haven't been defined yet. Lens controllers or EEPROM for instance.
>>> The two are an integral part of a module, something which is not modelled in
>>> DT in any way, but perhaps should be.
>
> Indeed, I'd say it belongs to a particular image sensor (camera module) binding
> to describe each its physical subdevices, i.e. if a pointer to lens or EEPROM
> is needed in the main module DT node.
>
>> Do you suggest using more generic name than 'flashes'?
>
>


-- 
Best Regards,
Jacek Anaszewski
