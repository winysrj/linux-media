Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030676Ab0B0TLV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 14:11:21 -0500
Message-ID: <4B896E85.5040301@redhat.com>
Date: Sat, 27 Feb 2010 20:12:05 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Richard Purdie <rpurdie@rpsys.net>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] gspca pac7302: allow controlling LED separately
References: <4B84CC9E.4030600@freemail.hu>	<20100224082238.53c8f6f8@tele>	<4B886566.8000600@freemail.hu>	<4B88CF6C.2070703@redhat.com> <20100227100400.05fede81@tele> <4B893BBD.9030600@freemail.hu>
In-Reply-To: <4B893BBD.9030600@freemail.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 02/27/2010 04:35 PM, Németh Márton wrote:
> Hi,
> Jean-Francois Moine wrote:
>> On Sat, 27 Feb 2010 08:53:16 +0100
>> Hans de Goede<hdegoede@redhat.com>  wrote:
>>
>>> This is true for a lot of cameras, so if we are going to add a way to
>>> support control of the LED separate of the streaming state, we
>>> should do that at the gspca_main level, and let sub drivers which
>>> support this export a set_led callback function.
>>>
>>> I must say I personally don't see much of a use case for this feature,
>>> but I believe JF Moine does, so I'll leave further comments and
>>> review of this to JF. I do believe it is important that if we go this
>>> way we do so add the gspca_main level.
>>
>> Hi,
>>
>> I don't like this mechanism to switch on or off the webcam LEDs. Here
>> are some arguments (some of them were sent last year to the list):
>
> I could accept both the V4L2 control solution or the LED subclass solution
> for handling the camera LED. I miss a little the positive side of using
> the LED subclass from the list, so I try take the role of that side and
> add them.
>

I have to side with JF here, I see very little use in the led class interface
for webcams. Another important reason to choose for a simple v4l2 menu control
solution here is consistency certain logitech uvc cameras already offer Led control
through a vendor extension control unit, which (when using uvcdynctrl to enable
vendor extension control units), currently shows up as a v4l2 control.

So for consistency with existing practices a v4l2 control seems better suited.

Also I must say that the led class seems overkill.

I would like to note that even if we go the v4l2 control way it still makes sense
to handle this in gspca_main, rather then implementing it separately in every
sub driver.

>> 1) End users.
>>
>> Many Linux users don't know the kernel internals, nor which of the too
>> many applications they should use to make their devices work.
>>
>> Actually, there are a few X11 programs in common Linux distros which can
>> handle the webcam parameters: I just know about vlc and v4l2ucp, and
>> they don't even handle the VIDIOC_G_JPEGCOMP and VIDIOC_S_JPEGCOMP
>> ioctls which are part of the v4l2 API.
>>
>> The LED interface uses the /sys file system. Will the webcam programs
>> offer access to this interface? I don't believe it. So, the users will
>> have to search how they can switch on or off the LEDs of their webcams,
>> and then, when found, they should start a X terminal and run a command
>> to do the job!
>
> The programs like v4l2ucp can be extended to handle the /sys/class/leds
> interface. This is work but the user will not recognise the difference
> as long as the GUI supports it.
>

Erm, no currently almost no v4l programs uses v4l2 controls properly, and
I certainly see none supporting the led sysfs interface. I say this as
someone who has done actual development on v4l2ucp, and  who is currnetly
involved in writing a GTK v4l2 control panel application.

Regards,

Hans
