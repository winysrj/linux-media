Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1952 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbZDPMkZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 08:40:25 -0400
Message-ID: <31771.62.70.2.252.1239885621.squirrel@webmail.xs4all.nl>
Date: Thu, 16 Apr 2009 14:40:21 +0200 (CEST)
Subject: Re: [PATCH 5/5] soc-camera: Convert to a platform driver
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Robert Jarzmik" <robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Thu, 16 Apr 2009, Dongsoo, Nathaniel Kim wrote:
>
>> My concern is all about the logical thing. "Why can't we open device
>> node even if it is not opened from any other process."
>
> The answer is of course "because the other node is currently active," but
> I can understand the sort of "confusion" that the user might have: we have
> two "independent" device nodes, but only one of them can be active at any
> given time. So, in a way you're right, this might not be very intuitive.
>
>> I have been working on dual camera with Linux for few years, and
>> everybody who I'm working with wants not to fail opening camera device
>> node in the first place. Actually I'm mobile phone developer and I've
>> been seeing so many exceptional cases in field with dual camera
>> applications. With all my experiences, I got my conclusion which is
>> "Don't make user get confused with device opening failure". I want you
>> to know that no offence but just want to make it better.
>
> Sure, I appreciate your opinion and respect your experience, but let's
> have a look at the current concept:
>
> 1. the platform has N cameras on camera interface X
> 2. soc_camera.c finds the matching interface X and creates M (<= N) nodes
> for all successfully probed devices.
> 3. in the beginning, as long as no device is open, all cameras are powered
> down / inactive.
> 4. you then open() one of them, it gets powered on / activated, the others
> become unaccessible as long as one is used.
> 5. this way switching is easy - you're sure, that when no device is open,
> all cameras are powered down, so, you can safely select any of them.
> 6. module reference-counting is easy too - every open() of a device-node
> increments the use-count
>
> With your proposed approach:
>
> 1. the platform has N cameras on camera interface X.
> 2. as long as at least one camera probed successfully for interface X, you
> create a videoX device and count inputs for it - successfully probed
> cameras.
> 3. you open videoX, one "default" camera gets activated immediately - not
> all applications issue S_INPUT, so, there has to be a default.
> 4. if an S_INPUT is issued, you have to verify, whether any camera is
> currently active / capturing, if none - switch to the requested one, if
> one is active - return -EBUSY.
> 5. reference-counting and guaranteeing consistency is more difficult, as
> well as handling camera driver loading / unloading.
>
> So, I would say, your approach adds complexity and asymmetry. Can it be
> that one camera client has several inputs itself? E.g., a decoder? In any
> case, I wouldn't do this now, if we do decide in favour of your approach,
> then only after the v4l2-device transition, please.

If you have mutually exclusive sources, then those should be implemented
as one device with multiple inputs. There is really no difference between
a TV capture driver that selects between a tuner and S-Video input, and a
camera driver that selects between multiple cameras.

A completely different question is whether soc-camera should be used at
all for this. The RFC Nate posted today said that this implementation was
based around the S3C64XX SoC. The limitation of allowing only one camera
at a time is a limitation of the hardware implementation, not of the SoC
as far as I could tell.

Given the fact that the SoC also supports codecs and other fun stuff, I
really wonder whether there shouldn't be a proper driver for that SoC that
supports all those features. Similar to what TI is doing for their davinci
platform. It is my understanding that soc-camera is really meant as a
simple framework around a sensor device, and not as a full-featured
implementation for codecs, previews, etc. Please correct me if I'm wrong.

Regards,

          Hans

>> But the mt9v022 case, I should need some research.
>
> Ok.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

