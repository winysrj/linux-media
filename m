Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52448 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753001AbbDHKoW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2015 06:44:22 -0400
Date: Wed, 8 Apr 2015 13:44:17 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, s.nawrocki@samsung.com,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v4 01/12] DT: leds: Improve description of flash LEDs
 related properties
Message-ID: <20150408104417.GU20756@valkosipuli.retiisi.org.uk>
References: <1427809965-25540-1-git-send-email-j.anaszewski@samsung.com>
 <1427809965-25540-2-git-send-email-j.anaszewski@samsung.com>
 <20150403120910.GL20756@valkosipuli.retiisi.org.uk>
 <5524ECDC.1070609@samsung.com>
 <20150408091129.GT20756@valkosipuli.retiisi.org.uk>
 <5525019B.8050104@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5525019B.8050104@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Wed, Apr 08, 2015 at 12:23:23PM +0200, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> On 04/08/2015 11:11 AM, Sakari Ailus wrote:
> >Hi Jacek,
> >
> >On Wed, Apr 08, 2015 at 10:54:52AM +0200, Jacek Anaszewski wrote:
> >>Hi Sakari,
> >>
> >>On 04/03/2015 02:09 PM, Sakari Ailus wrote:
> >>>Hi Jacek,
> >>>
> >>>On Tue, Mar 31, 2015 at 03:52:37PM +0200, Jacek Anaszewski wrote:
> >>>>Description of flash LEDs related properties was not precise regarding
> >>>>the state of corresponding settings in case a property is missing.
> >>>>Add relevant statements.
> >>>>Removed is also the requirement making the flash-max-microamp
> >>>>property obligatory for flash LEDs. It was inconsistent as the property
> >>>>is defined as optional. Devices which require the property will have
> >>>>to assert this in their DT bindings.
> >>>>
> >>>>Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>>>Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>>>Cc: Bryan Wu <cooloney@gmail.com>
> >>>>Cc: Richard Purdie <rpurdie@rpsys.net>
> >>>>Cc: Pavel Machek <pavel@ucw.cz>
> >>>>Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> >>>>Cc: devicetree@vger.kernel.org
> >>>>---
> >>>>  Documentation/devicetree/bindings/leds/common.txt |   16 +++++++++-------
> >>>>  1 file changed, 9 insertions(+), 7 deletions(-)
> >>>>
> >>>>diff --git a/Documentation/devicetree/bindings/leds/common.txt b/Documentation/devicetree/bindings/leds/common.txt
> >>>>index 747c538..21a25e4 100644
> >>>>--- a/Documentation/devicetree/bindings/leds/common.txt
> >>>>+++ b/Documentation/devicetree/bindings/leds/common.txt
> >>>>@@ -29,13 +29,15 @@ Optional properties for child nodes:
> >>>>       "ide-disk" - LED indicates disk activity
> >>>>       "timer" - LED flashes at a fixed, configurable rate
> >>>>
> >>>>-- max-microamp : maximum intensity in microamperes of the LED
> >>>>-		 (torch LED for flash devices)
> >>>>-- flash-max-microamp : maximum intensity in microamperes of the
> >>>>-                       flash LED; it is mandatory if the LED should
> >>>>-		       support the flash mode
> >>>>-- flash-timeout-us : timeout in microseconds after which the flash
> >>>>-                     LED is turned off
> >>>>+- max-microamp : Maximum intensity in microamperes of the LED
> >>>>+		 (torch LED for flash devices). If omitted this will default
> >>>>+		 to the maximum current allowed by the device.
> >>>>+- flash-max-microamp : Maximum intensity in microamperes of the flash LED.
> >>>>+		       If omitted this will default to the maximum
> >>>>+		       current allowed by the device.
> >>>>+- flash-timeout-us : Timeout in microseconds after which the flash
> >>>>+                     LED is turned off. If omitted this will default to the
> >>>>+		     maximum timeout allowed by the device.
> >>>>
> >>>>
> >>>>  Examples:
> >>>
> >>>Pavel pointed out that the brightness between maximum current and the
> >>>maximum *allowed* another current might not be noticeable, leading a
> >>>potential spelling error to cause the LED being run at too high current.
> >>
> >>I think that a board designed so that it can be damaged because of
> >>software bugs should be considered not eligible for commercial use.
> >>Any self-esteeming manufacturer will not connect a LED to the output
> >>that can produce the current greater than the LED's absolute maximum
> >>current.
> >
> >The maximum current *is* used to prevent potential hardware damage.
> 
> What hardware are we talking about - LED controller or the discrete
> LED component attached to the LED controller's current output?

Generally the LED itself, not the controller. Most controllers have
overheating protection while the LEDs do not.

> 
> The maximum current the LED controller can produce is fixed or depends
> on external components like resistors.

On some controllers perhaps, but not on most of them.

> 
> This is at least the case for max77693 and aat1290 device I've been
> working with. If a LED is rated to max 1A and it will be connected
> to the output capable of producing 1.2A then it is likely that it
> will be damaged. I was thinking about this kind of hardware damage.

This is the very reason why the maximum current limit is there: to prevent
hardware damage. If the LED could safely be used at the controller's maximum
current, there would be no need for the maximum current property
(torch/flash).

> 
> How vendors can protect from it if they connect incompatible LED
> to the current output?
> 
> There might be boards that provide sockets for connecting external
> LEDs though. Such arrangements indeed justify the need for making the
> properties required.

Pluggable hardware is a completely different matter. If used with DT
overlays, the overlay should contain the limits as well.

> 
> >This is
> >how mobile phones typically are, probably also the one you're using. :-) I
> >don't believe there's really a difference between vendors in this respect.
> >
> >We still lack a proper way to model the temperature of the flash LED, so
> >what we have now is a bit incomplete, but at least it prevents causing
> >damage unintentionally.
> 
> Are you thinking about flash faults?

The question is: when if it safe to strobe again after a strobe has ended?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
