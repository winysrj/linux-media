Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4563 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679AbZKRJWN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 04:22:13 -0500
Message-ID: <a1d2e45aaaf1471c831534dec280a3c9.squirrel@webmail.xs4all.nl>
In-Reply-To: <20091118100518.08e147ee@devenv1>
References: <20091118084516.375817ff@devenv1>
    <630a05e93817ce501eb6a0ddd6246a39.squirrel@webmail.xs4all.nl>
    <20091118100518.08e147ee@devenv1>
Date: Wed, 18 Nov 2009 10:22:18 +0100
Subject: Re: Driver for NXP SAA7154
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Andreas Feuersinger" <andreas.feuersinger@spintower.eu>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi Hans
>
> Thank you for your reply!
>
> On Wed, 18 Nov 2009 09:20:53 +0100
> "Hans Verkuil" <hverkuil@xs4all.nl> wrote:
>> > I wonder if there is work in progress for a Linux driver supporting
>> > the NXP SAA7154 Multistandard video decoder with comb filter,
> [..]
>> > Datasheet:
>> > http://www.nxp.com/documents/data_sheet/SAA7154E_SAA7154H.pdf
>
>> I think it will have to be a new driver, partially based on the
>> current saa7115.c driver (at least the composite/S-Video input part
>> seems to be very similar to that one). The good news is that the
>> datasheet is available, that will help a lot.
>
> Is it possible for you to estimate time and effort for writing the
> driver? I don't really have experience in Linux driver writing so far.

How long it will take depends on many factors. But I would guess between
2-8 weeks, depending on the experience of the developer, how much of
saa7115 can be reused, and how much of the functionality of the device has
to be available in the initial driver. I mean, if you need to support
complex features like raw and/or sliced VBI on the input side, then that
will add to the time.

Some parts like the VGA input (which needs support for non-PAL/NTSC
resolutions) require video4linux core support that is not yet available,
although I expect/hope that we will have that very soon.

> How much help could one expect?

On this list people can give you pointers and do code reviews. Actual
coding is another matter.

> Are there other people interested in or willing to write the driver?
>
> I considered asking people from Linux Driver Project for assistance...

That's definitely a possibility, although such a request might end up on
this list anyway.

The important thing is that whoever is going to develop such a driver
needs the hardware to test it with.

>
> Sorry for asking probably silly questions, I am new to the kernel
> development process.

Not silly at all!

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

