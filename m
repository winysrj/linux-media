Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:48859 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbbDHHsb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2015 03:48:31 -0400
Message-ID: <5524DD4B.6040607@linux.intel.com>
Date: Wed, 08 Apr 2015 10:48:27 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Bryan Wu <cooloney@gmail.com>, Pavel Machek <pavel@ucw.cz>
CC: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"rpurdie@rpsys.net" <rpurdie@rpsys.net>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 01/12] DT: leds: Improve description of flash
 LEDs related properties
References: <1427809965-25540-1-git-send-email-j.anaszewski@samsung.com> <1427809965-25540-2-git-send-email-j.anaszewski@samsung.com> <20150403120910.GL20756@valkosipuli.retiisi.org.uk> <551E8DEA.5070205@samsung.com> <20150403203730.GA13009@amd> <CAK5ve-KR81cNrJnPj_XUkNvctsEYLDGb58qTVaOOAYJnoZTGXg@mail.gmail.com>
In-Reply-To: <CAK5ve-KR81cNrJnPj_XUkNvctsEYLDGb58qTVaOOAYJnoZTGXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bryan,

Bryan Wu wrote:
> On Fri, Apr 3, 2015 at 1:37 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> Hi!
>>
>>>>> +- flash-timeout-us : Timeout in microseconds after which the flash
>>>>> +                     LED is turned off. If omitted this will default to the
>>>>> +                maximum timeout allowed by the device.
>>>>>
>>>>>
>>>>>  Examples:
>>>>
>>>> Pavel pointed out that the brightness between maximum current and the
>>>> maximum *allowed* another current might not be noticeable,leading a
>>>> potential spelling error to cause the LED being run at too high current.
>>>
>>> Where did he point this out? Do you think about the current version
>>> of the leds/common.txt documentation or there was some other message,
>>> that I don't see?
>>
>> Date: Thu, 2 Apr 2015 22:30:44 +0200
>> From: Pavel Machek <pavel@ucw.cz>
>> To: Sakari Ailus <sakari.ailus@iki.fi>
>> Subject: Re: [PATCHv3] media: i2c/adp1653: devicetree support for adp1653
>>
>>> Besides, I can't understand your point. Could you express it in other
>>> words, please?
>>
>> Typo in device tree would cause hardware damage. But idea. Make the
>> properties mandatory.
>>                                                                 Pavel
> 
> I don't quite follow there. I think Pavel acked this patch right? So
> what's left to hold here?

LED flash controllers are capable of providing more current than the
LEDs attached to them can withstand without hardware damage. This is the
reason the maximum current limits lower than the LED controller maximums
are there.

Pavel, quite rightly so in my opinion, is suggesting these properties
are made mandatory. A typo in the DT source could cause the controller
maximum current used instead of LED maximum which is often lower. That
kind of a problem would easily go unnoticed since there isn't
necessarily any perceivable change in the functionality of the board.

You'd only notice later on, when the LEDs stop working.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
