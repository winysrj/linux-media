Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34153 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbbDHBU2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2015 21:20:28 -0400
MIME-Version: 1.0
In-Reply-To: <20150403203730.GA13009@amd>
References: <1427809965-25540-1-git-send-email-j.anaszewski@samsung.com>
 <1427809965-25540-2-git-send-email-j.anaszewski@samsung.com>
 <20150403120910.GL20756@valkosipuli.retiisi.org.uk> <551E8DEA.5070205@samsung.com>
 <20150403203730.GA13009@amd>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 7 Apr 2015 18:20:08 -0700
Message-ID: <CAK5ve-KR81cNrJnPj_XUkNvctsEYLDGb58qTVaOOAYJnoZTGXg@mail.gmail.com>
Subject: Re: [PATCH v4 01/12] DT: leds: Improve description of flash LEDs
 related properties
To: Pavel Machek <pavel@ucw.cz>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"rpurdie@rpsys.net" <rpurdie@rpsys.net>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 3, 2015 at 1:37 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> >>+- flash-timeout-us : Timeout in microseconds after which the flash
>> >>+                     LED is turned off. If omitted this will default to the
>> >>+                maximum timeout allowed by the device.
>> >>
>> >>
>> >>  Examples:
>> >
>> >Pavel pointed out that the brightness between maximum current and the
>> >maximum *allowed* another current might not be noticeable,leading a
>> >potential spelling error to cause the LED being run at too high current.
>>
>> Where did he point this out? Do you think about the current version
>> of the leds/common.txt documentation or there was some other message,
>> that I don't see?
>
> Date: Thu, 2 Apr 2015 22:30:44 +0200
> From: Pavel Machek <pavel@ucw.cz>
> To: Sakari Ailus <sakari.ailus@iki.fi>
> Subject: Re: [PATCHv3] media: i2c/adp1653: devicetree support for adp1653
>
>> Besides, I can't understand your point. Could you express it in other
>> words, please?
>
> Typo in device tree would cause hardware damage. But idea. Make the
> properties mandatory.
>                                                                 Pavel

I don't quite follow there. I think Pavel acked this patch right? So
what's left to hold here?

Thanks,
-Bryan
