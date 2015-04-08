Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23190 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbbDHKDc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2015 06:03:32 -0400
Message-id: <5524FCEF.7060901@samsung.com>
Date: Wed, 08 Apr 2015 12:03:27 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>, pavel@ucw.cz,
	sakari.ailus@iki.fi, Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v4 01/12] DT: leds: Improve description of flash LEDs
 related properties
References: <1427809965-25540-1-git-send-email-j.anaszewski@samsung.com>
 <1427809965-25540-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1427809965-25540-2-git-send-email-j.anaszewski@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 31/03/15 15:52, Jacek Anaszewski wrote:
> Description of flash LEDs related properties was not precise regarding
> the state of corresponding settings in case a property is missing.
> Add relevant statements.
> Removed is also the requirement making the flash-max-microamp
> property obligatory for flash LEDs. It was inconsistent as the property
> is defined as optional. Devices which require the property will have
> to assert this in their DT bindings.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: devicetree@vger.kernel.org
> ---
>  Documentation/devicetree/bindings/leds/common.txt |   16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/leds/common.txt b/Documentation/devicetree/bindings/leds/common.txt
> index 747c538..21a25e4 100644
> --- a/Documentation/devicetree/bindings/leds/common.txt
> +++ b/Documentation/devicetree/bindings/leds/common.txt
> @@ -29,13 +29,15 @@ Optional properties for child nodes:
>       "ide-disk" - LED indicates disk activity
>       "timer" - LED flashes at a fixed, configurable rate
>  
> -- max-microamp : maximum intensity in microamperes of the LED
> -		 (torch LED for flash devices)
> -- flash-max-microamp : maximum intensity in microamperes of the
> -                       flash LED; it is mandatory if the LED should
> -		       support the flash mode
> -- flash-timeout-us : timeout in microseconds after which the flash
> -                     LED is turned off
> +- max-microamp : Maximum intensity in microamperes of the LED
> +		 (torch LED for flash devices). If omitted this will default
> +		 to the maximum current allowed by the device.
> +- flash-max-microamp : Maximum intensity in microamperes of the flash LED.
> +		       If omitted this will default to the maximum
> +		       current allowed by the device.
> +- flash-timeout-us : Timeout in microseconds after which the flash
> +                     LED is turned off. If omitted this will default to the
> +		     maximum timeout allowed by the device.

Sorry about late comments on that, but since we can still change these
properties and it seems we're going to do that, I'd like throw in my
few preferences on the colour of this bike...

IMO "max-microamp" is a poor property name, how about:

s/max-microamp/led-max-current-ua,
s/flash-max-microamp/flash-max-current-ua,

so we have more consistent set of properties like:

led-max-current-ua
flash-max-current-ua
flash-timeout-us

Also expressing light intensity in micro-amperes seems technically wrong.
I would propose to substitute word "intensity in microamperes" with "LED
supply current in microamperes".

I also think we should require the maximum current properties and
the driver should warn if they are missing and limit current to some
potentially safe value, e.g. small fraction of the maximum current.

Also from the description it should be clear whether the current
limits refer to capabilities of a LED or the desired settings we want
to be applied at the LED driver device.
We could, for example, add a sentence after the above 3 properties:

"Required properties for Flash LEDs:

 - led-max-current-ua
 - flash-max-current-ua
 - flash-timeout-us

These properties determine a LED driver IC settings required for
safe operation."

Or something along these lines.

-- 
Regards,
Sylwester
