Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40629 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbbDHOpd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2015 10:45:33 -0400
Message-id: <55253F08.3040409@samsung.com>
Date: Wed, 08 Apr 2015 16:45:28 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: pavel@ucw.cz, sakari.ailus@iki.fi,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v4 01/12] DT: leds: Improve description of flash LEDs
 related properties
References: <1427809965-25540-1-git-send-email-j.anaszewski@samsung.com>
 <1427809965-25540-2-git-send-email-j.anaszewski@samsung.com>
 <5524FCEF.7060901@samsung.com> <552517DD.2040905@samsung.com>
In-reply-to: <552517DD.2040905@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On 08/04/15 13:58, Jacek Anaszewski wrote:
>>> --- a/Documentation/devicetree/bindings/leds/common.txt
>>> >> +++ b/Documentation/devicetree/bindings/leds/common.txt
>>> >> @@ -29,13 +29,15 @@ Optional properties for child nodes:
>>> >>        "ide-disk" - LED indicates disk activity
>>> >>        "timer" - LED flashes at a fixed, configurable rate
>>> >>
>>> >> -- max-microamp : maximum intensity in microamperes of the LED
>>> >> -		 (torch LED for flash devices)
>>> >> -- flash-max-microamp : maximum intensity in microamperes of the
>>> >> -                       flash LED; it is mandatory if the LED should
>>> >> -		       support the flash mode
>>> >> -- flash-timeout-us : timeout in microseconds after which the flash
>>> >> -                     LED is turned off
>>> >> +- max-microamp : Maximum intensity in microamperes of the LED
>>> >> +		 (torch LED for flash devices). If omitted this will default
>>> >> +		 to the maximum current allowed by the device.
>>> >> +- flash-max-microamp : Maximum intensity in microamperes of the flash LED.
>>> >> +		       If omitted this will default to the maximum
>>> >> +		       current allowed by the device.
>>> >> +- flash-timeout-us : Timeout in microseconds after which the flash
>>> >> +                     LED is turned off. If omitted this will default to the
>>> >> +		     maximum timeout allowed by the device.
>> >
>> > Sorry about late comments on that, but since we can still change these
>> > properties and it seems we're going to do that, I'd like throw in my
>> > few preferences on the colour of this bike...
>> >
>> > IMO "max-microamp" is a poor property name, how about:
>> >
>> > s/max-microamp/led-max-current-ua,
>> > s/flash-max-microamp/flash-max-current-ua,
>> >
>> > so we have more consistent set of properties like:
>> >
>> > led-max-current-ua
>> > flash-max-current-ua
>> > flash-timeout-us
>
> The "-microamp' suffix is consistent with regulator bindings.
> Please refer to [1].

OK, in a perfect world we would have clean and consistent notation of
units. If it's acked let's leave it, I didn't know it was, sorry about
that.

When I read yesterday Documentation/devicetree/bindings/leds/common.txt
the set of new properties looked rather sloppy, especially "max-microamp"
looked incomplete to me, as if the subject was missing.

Anyway, I'll just get used to it, let's complete this whole Flash/LED
integration story.

-- 
Thanks,
Sylwester
