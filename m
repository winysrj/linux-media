Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:33490 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935069AbbCPT5U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 15:57:20 -0400
Message-ID: <55073598.9010803@xs4all.nl>
Date: Mon, 16 Mar 2015 20:57:12 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	=?UTF-8?B?QXVyw6lsaWU=?= =?UTF-8?B?biBaYW5lbGxp?=
	<aurelien.zanelli@parrot.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Dynamic video input/output list
References: <5507177A.8060200@parrot.com> <CAGoCfiyZt990gWqSPgaNE7L1fw=XN1DJiiQeDKvepO1Yz9cvaA@mail.gmail.com>
In-Reply-To: <CAGoCfiyZt990gWqSPgaNE7L1fw=XN1DJiiQeDKvepO1Yz9cvaA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/2015 07:01 PM, Devin Heitmueller wrote:
>> I'm looking to enhance video input/output enumeration support in
>> GStreamer using VIDIOC_ENUMINPUT/VIDIOC_ENUMOUTPUT ioctls and after some
>> discussions we wonder if the input/output list can change dynamically at
>> runtime or not.
>>
>> So, is v4l2 allow this input/output list to be dynamic ?
> 
> I sure how the spec allows it, because I've done it in the past.

Just because you can do something doesn't mean the spec allows it :-)
In this particular case nobody ever thought about whether this could
change dynamically so the spec never talks about it.

But at the moment it is definitely not allowed, even though the spec
doesn't explicitly forbid it. All applications expect that the list of
inputs/outputs is fixed.

The spec could be extended to allow this, but then there also should be
a new event introduced that the application can receive if the list changes
so it can update the list.

But frankly, I would prefer to always expose all possible inputs, including
those of an optional onboard header, and if nothing is connected just mark
those inputs as having status V4L2_IN_ST_NO_POWER.

Note however that it is perfectly fine if the driver detects the presence
of such an onboard header when it is loaded and then only exposes those
extra inputs if the header is present. It just can't change the list later
unless do you an rmmod and modprobe of the driver. It's probably what you
do anyway.

Regards,

	Hans

> I have cards which have an onboard header for external A/V inputs, and I
> am able to tell if the breakout cable is attached due to a dedicated
> pin tied to a GPIO.  Thus, I am able to dictate whether the card has
> the A/V breakout cable attached and thus whether to expose only the
> first input or all three inputs.
> 
> That said, in this case the inputs in the list never moved around
> because the optional entries were at the end of the list - the list
> just got longer if those inputs were available.  I'm not sure what
> would happen if you had a configuration where you needed to remove
> entries other than those at the end of the list.  For example, if you
> had a card with four possible inputs and you removed input 2, does the
> list stay the same length and input 2 is now marked as invalid, or
> does the length of the list become 3 and inputs 3 and 4 turn into
> inputs 2 and 3?
> 
> Devin
> 

