Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.digicable.hu ([92.249.128.189]:46088 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967944Ab0B0IW2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 03:22:28 -0500
Message-ID: <4B88D642.3010907@freemail.hu>
Date: Sat, 27 Feb 2010 09:22:26 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Richard Purdie <rpurdie@rpsys.net>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] gspca pac7302: allow controlling LED separately
References: <4B84CC9E.4030600@freemail.hu> <20100224082238.53c8f6f8@tele> <4B886566.8000600@freemail.hu> <4B88CF6C.2070703@redhat.com>
In-Reply-To: <4B88CF6C.2070703@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Hans de Goede wrote:
> Hi,
> 
> On 02/27/2010 01:20 AM, Németh Márton wrote:
>> From: Márton Németh<nm127@freemail.hu>
>>
>> On Labtec Webcam 2200 there is a feedback LED which can be controlled
>> independent from the streaming.
> 
> This is true for a lot of cameras, so if we are going to add a way to
> support control of the LED separate of the streaming state, we
> should do that at the gspca_main level, and let sub drivers which
> support this export a set_led callback function.

If the code is moved to gspca_main level, what shall be the name of the
LED? According to Documentation/leds-class.txt, chapter "LED Device Naming"
my proposal for "devicename" would be:

 * /sys/class/leds/video-0::camera
 * /sys/class/leds/video-1::camera
 * /sys/class/leds/video-2::camera
 * ...

or

 * /sys/class/leds/video0::camera
 * /sys/class/leds/video1::camera
 * /sys/class/leds/video2::camera
 * ...

Which is the right one?

> I must say I personally don't see much of a use case for this feature,
> but I believe JF Moine does, so I'll leave further comments and
> review of this to JF. I do believe it is important that if we go this
> way we do so add the gspca_main level.
> 
> Regards,
> 
> Hans
