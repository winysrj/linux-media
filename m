Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44117 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbaHGIVN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Aug 2014 04:21:13 -0400
Message-id: <53E336FA.2050306@samsung.com>
Date: Thu, 07 Aug 2014 10:21:14 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kyungmin.park@samsung.com, b.zolnierkie@samsung.com
Subject: Re: [PATCH/RFC v4 00/21] LED / flash API integration
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
 <20140806065358.GC16460@valkosipuli.retiisi.org.uk>
In-reply-to: <20140806065358.GC16460@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 08/06/2014 08:53 AM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Fri, Jul 11, 2014 at 04:04:03PM +0200, Jacek Anaszewski wrote:
> ...
>> 1) Who should register V4L2 Flash sub-device?
>>
>> LED Flash Class devices, after introduction of the Flash Manager,
>> are not tightly coupled with any media controller. They are maintained
>> by the Flash Manager and made available for dynamic assignment to
>> any media system they are connected to through multiplexing devices.
>>
>> In the proposed rough solution, when support for V4L2 Flash sub-devices
>> is enabled, there is a v4l2_device created for them to register in.
>> This however implies that V4L2 Flash device will not be available
>> in any media controller, which calls its existence into question.
>>
>> Therefore I'd like to consult possible ways of solving this issue.
>> The option I see is implementing a mechanism for moving V4L2 Flash
>> sub-devices between media controllers. A V4L2 Flash sub-device
>> would initially be assigned to one media system in the relevant
>> device tree binding, but it could be dynamically reassigned to
>> the other one. However I'm not sure if media controller design
>> is prepared for dynamic modifications of its graph and how many
>> modifications in the existing drivers this solution would require.
>
> Do you have a use case where you would need to strobe a flash from multiple
> media devices at different times, or is this entirely theoretical? Typically
> flash controllers are connected to a single source of hardware strobe (if
> there's one) since the flash LEDs are in fact mounted next to a specific
> camera sensor.

I took into account such arrangements in response to your message [1], 
where you were considering configurations like "one flash but two
cameras", "one camera and two flashes". And you also called for 
proposing generic solution.

One flash and two (or more) cameras case is easily conceivable -
You even mentioned stereo cameras. One camera and many flashes
arrangement might be useful in case of some professional devices which
might be designed so that they would be able to apply different scene
lighting. I haven't heard about such devices, but as you said
such a configuration isn't unthinkable.

> If this is a real issue the way to solve it would be to have a single media
> device instead of many.

I was considering adding media device, that would be a representation
of a flash manager, gathering all the registered flashes. Nonetheless,
finally I came to conclusion that a v4l2-device alone should suffice,
just to provide a Flash Manager representation allowing for v4l2-flash 
sub-devices to register in.
All the features provided by the media device are useless in case
of a set of V4L2 Flash sub-devices. They couldn't have any linkage
in such a device. The only benefit from having media device gathering
V4L2 Flash devices would be possibility of listing them.

>> 2) Consequences of locking the Flash Manager during flash strobe
>>
>> In case a LED Flash Class device depends on muxes involved in
>> routing the other LED Flash Class device's strobe signals,
>> the Flash Manager must be locked for the time of strobing
>> to prevent reconfiguration of the strobe signal routing
>> by the other device.
>
> I wouldn't be concerned of this in particular. It's more important we do
> actully have V4L2 flash API supported by LED flash drivers and that they do
> implement the API correctly.
>
> It's at least debatable whether you should try to prevent user space from
> doing silly things or not. With complex devices it may relatively easily
> lead to wrecking havoc with actual use cases which we certainly do not want.
>
> In this case, if you just prevent changing the routing (do you have a use
> case for it?) while strobing, someone else could still change the routing
> just before you strobe.

Originally I started to implementing this so that strobe signal routing
was altered upon setting strobe source. With such an implementation the 
use case would be as follows:

1. Process 1 sets strobe source to external
2. Process 2 sets strobe source to software
3. Process 1 strobes the flash, unaware that strobe source setting has
    been changed

To avoid such problems I changed the implementation so that the
routing is set in the led_flash_manager_setup_strobe function called
from led_set_flash_strobe and led_set_external_strobe functions.
led_flash_manager_setup_strobe sets strobe signal routing
and strobes the flash under lock and holds it for the flash timeout
period, which prevents spurious reconfiguration.

Nonetheless, I agree that trying to handle this problem is troublesome,
and would affect current V4L2 Flash SPI semantics. If you don't share
my concerns I am happy to leave this locking solution out :)

Best Regards,
Jacek Anaszewski

[1] http://www.spinics.net/lists/linux-leds/msg01617.html
