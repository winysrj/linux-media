Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab0EFSPK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 May 2010 14:15:10 -0400
Message-ID: <4BE3071F.3040206@redhat.com>
Date: Thu, 06 May 2010 15:14:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] add feedback LED control
References: <4B8A2158.6020701@freemail.hu>	<20100228202801.6986cb19@tele>	<4B8AC618.80200@freemail.hu> <20100301101806.7c7986be@tele>
In-Reply-To: <20100301101806.7c7986be@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois Moine wrote:
> On Sun, 28 Feb 2010 20:38:00 +0100
> Németh Márton <nm127@freemail.hu> wrote:
> 
>> With a bitfield on and off state can be specified. What about the
>> "auto" mode? Should two bits grouped together to have auto, on and
>> off state? Is there already a similar control?
>>
>> Is the brightness of the background light LEDs adjustable or are they
>> just on/off? If yes, then maybe the feedback LEDs and the background
>> light LEDs should be treated as different kind.
> 
> OK. My idea about switching the LEDs by v4l2 controls was not good. So,
> forget about it.
> 
> Instead, some job of the led class may be done in the gspca main,
> especially register/unregister.
> 
> I propose to add a LED description in the gspca structure (level
> 'struct cam'). There would be 'nleds' for the number of LEDS and
> 'leds', a pointer to an array of:
> 
> 	struct gspca_led {
> 		struct led_classdev led_cdev;
> 		char led_name[32];
> 		struct led_trigger led_trigger;
> 		char trigger_name[32];
> 	};
> 
> (this array should be in the subdriver structure - I don't show the
> #ifdef's)
> 
> Then, this would work as:
> 
> - on probe, in the 'config' function of the subdriver, this one
>   initializes the led and trigger fields. The 'led_cdev.name' and
>   'led_trigger.name' should point to a sprintf format with one
>   argument: the video device number (ex: "video%d::toplight").
> 
> - then, at the end of gspca_dev_probe(), the gspca main creates the real
>   names of the leds and triggers, and does the register job.
> 
> - all led/trigger events are treated by the subdriver, normally by a
>   workqueue. This one must not be the system workqueue.
> 
> - on disconnection, the gspca main unregisters the leds and triggers
>   without calling the subdriver. In the workqueue, the disconnection
>   can be simply handled testing the flag 'present' after each subsystem
>   call.
> 
> Cheers.
> 

The feedback LED patch series doesn't apply anymore.

patching file Documentation/DocBook/v4l/controls.xml
Hunk #1 succeeded at 324 (offset 13 lines).
patching file Documentation/DocBook/v4l/videodev2.h.xml
Hunk #1 succeeded at 1031 (offset 7 lines).
patching file drivers/media/video/v4l2-common.c
Hunk #1 succeeded at 358 (offset 9 lines).
Hunk #3 FAILED at 442.
Hunk #4 succeeded at 598 (offset 14 lines).
1 out of 4 hunks FAILED -- saving rejects to file drivers/media/video/v4l2-common.c.rej
patching file include/linux/videodev2.h
Hunk #1 FAILED at 1030.
1 out of 1 hunk FAILED -- saving rejects to file include/linux/videodev2.h.rej
>>> Patch patches/lmml_82773_1_3_add_feedback_led_control.patch doesn't apply

As the original approach weren't accepted, I'm dropping those patches from
my queue. Please re-submit after having some agreement about that.

-- 

Cheers,
Mauro
