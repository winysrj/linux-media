Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51625 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751177AbbDHJLh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2015 05:11:37 -0400
Date: Wed, 8 Apr 2015 12:11:29 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, s.nawrocki@samsung.com,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v4 01/12] DT: leds: Improve description of flash LEDs
 related properties
Message-ID: <20150408091129.GT20756@valkosipuli.retiisi.org.uk>
References: <1427809965-25540-1-git-send-email-j.anaszewski@samsung.com>
 <1427809965-25540-2-git-send-email-j.anaszewski@samsung.com>
 <20150403120910.GL20756@valkosipuli.retiisi.org.uk>
 <5524ECDC.1070609@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5524ECDC.1070609@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Wed, Apr 08, 2015 at 10:54:52AM +0200, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> On 04/03/2015 02:09 PM, Sakari Ailus wrote:
> >Hi Jacek,
> >
> >On Tue, Mar 31, 2015 at 03:52:37PM +0200, Jacek Anaszewski wrote:
> >>Description of flash LEDs related properties was not precise regarding
> >>the state of corresponding settings in case a property is missing.
> >>Add relevant statements.
> >>Removed is also the requirement making the flash-max-microamp
> >>property obligatory for flash LEDs. It was inconsistent as the property
> >>is defined as optional. Devices which require the property will have
> >>to assert this in their DT bindings.
> >>
> >>Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>Cc: Bryan Wu <cooloney@gmail.com>
> >>Cc: Richard Purdie <rpurdie@rpsys.net>
> >>Cc: Pavel Machek <pavel@ucw.cz>
> >>Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> >>Cc: devicetree@vger.kernel.org
> >>---
> >>  Documentation/devicetree/bindings/leds/common.txt |   16 +++++++++-------
> >>  1 file changed, 9 insertions(+), 7 deletions(-)
> >>
> >>diff --git a/Documentation/devicetree/bindings/leds/common.txt b/Documentation/devicetree/bindings/leds/common.txt
> >>index 747c538..21a25e4 100644
> >>--- a/Documentation/devicetree/bindings/leds/common.txt
> >>+++ b/Documentation/devicetree/bindings/leds/common.txt
> >>@@ -29,13 +29,15 @@ Optional properties for child nodes:
> >>       "ide-disk" - LED indicates disk activity
> >>       "timer" - LED flashes at a fixed, configurable rate
> >>
> >>-- max-microamp : maximum intensity in microamperes of the LED
> >>-		 (torch LED for flash devices)
> >>-- flash-max-microamp : maximum intensity in microamperes of the
> >>-                       flash LED; it is mandatory if the LED should
> >>-		       support the flash mode
> >>-- flash-timeout-us : timeout in microseconds after which the flash
> >>-                     LED is turned off
> >>+- max-microamp : Maximum intensity in microamperes of the LED
> >>+		 (torch LED for flash devices). If omitted this will default
> >>+		 to the maximum current allowed by the device.
> >>+- flash-max-microamp : Maximum intensity in microamperes of the flash LED.
> >>+		       If omitted this will default to the maximum
> >>+		       current allowed by the device.
> >>+- flash-timeout-us : Timeout in microseconds after which the flash
> >>+                     LED is turned off. If omitted this will default to the
> >>+		     maximum timeout allowed by the device.
> >>
> >>
> >>  Examples:
> >
> >Pavel pointed out that the brightness between maximum current and the
> >maximum *allowed* another current might not be noticeable, leading a
> >potential spelling error to cause the LED being run at too high current.
> 
> I think that a board designed so that it can be damaged because of
> software bugs should be considered not eligible for commercial use.
> Any self-esteeming manufacturer will not connect a LED to the output
> that can produce the current greater than the LED's absolute maximum
> current.

The maximum current *is* used to prevent potential hardware damage. This is
how mobile phones typically are, probably also the one you're using. :-) I
don't believe there's really a difference between vendors in this respect.

We still lack a proper way to model the temperature of the flash LED, so
what we have now is a bit incomplete, but at least it prevents causing
damage unintentionally.

> The DT properties could be useful for devices like aat1290 device I was
> writing a driver for, which has the maximum current and timeout values
> depending on corresponding capacitor and resistor values respectively.
> Such devices should make the properties required in their bindings.
> 
> >The three drivers I've looked also require these properties, which I think
> >is in the line with the above.
> >
> >How about either dropping the patch, or changing maximum to minimum and
> >will to should? The drivers could also behave this way instead of requiring
> >the properties, but I don't think there's anything wrong with requiring the
> >properties either.
> 
> As I mentioned in the previous message in this subject, the max-microamp
> property refers also to non-flash LEDs. Since existing LED class devices
> does not require them, then it should be left optional and default to
> max. It would however be inconsistent with flash LEDs related
> properties.

I do agree with Pavel here, these should be mandatory (at least for new
drivers) OR default to minimum.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
