Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1687 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab0IINi0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 09:38:26 -0400
Message-ID: <ed5d9db2e3f0e35b69130b1b6148135b.squirrel@webmail.xs4all.nl>
In-Reply-To: <4C88C1DA.1070606@redhat.com>
References: <20100906201105.4029d7e7@tele>
    <201009071730.33642.hverkuil@xs4all.nl> <4C86AB22.7020206@redhat.com>
    <201009090855.53072.hverkuil@xs4all.nl> <4C88C1DA.1070606@redhat.com>
Date: Thu, 9 Sep 2010 15:38:12 +0200
Subject: Re: [PATCH] Illuminators and status LED controls
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Hans de Goede" <hdegoede@redhat.com>
Cc: "Jean-Francois Moine" <moinejf@free.fr>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>


> Hi,
>
> On 09/09/2010 08:55 AM, Hans Verkuil wrote:
>> On Tuesday, September 07, 2010 23:14:10 Hans de Goede wrote:
>
> <snip>
>
>>> How about a compromise, we add a set of standard defines for menu
>>> index meanings, with a note that these are present as a way to
>>> standardize
>>> things between drivers, but that some drivers may deviate and that
>>> apps should always use VIDIOC_QUERYMENU ?
>>
>> Let's use boolean for these illuminator controls instead. Problem solved
>> :-)
>
> Erm, no. If you take a look at the current qx5 microscope support code in
> the
> cpia2 driver it currently is a menu with the following possible values:
> Off
> Top
> Bottom
> Both
>
> So now lets say we create standard controls for illuminators and make them
> booleans and use 2 booleans. And then modify the cpia2 driver to follow
> the
> new standard.
>
> The user behavior then goes from:
> - user things lets switch from top to bottom lighting
> - go to control
> - click menu drops down select top / bottom
> -> easy
>
> To:
> - user things lets switch from top to bottom lighting
> - go to control
> - heuh 2 checkboxes ?
> - click one check box off
> - clock other check box on
> -> not easy

So two clicks in the case of a menu and two in the case of a checkbox.
Personally I don't see this as a big deal. But it will be good to get
other people's opinion on this.

>
> If I were a user I would call this change a regression, and as such I find
> the boolean proposal unacceptable. Maybe we should call the control
> V4L2_CID_MICROSCOPE_ILLUMINATOR
>
> To make it more clear that the menu variant of this is meant for
> microscopes (which typically have either only a bottom illuminator
> or both a bottom and a top one). And if we then ever need to support
> some other kind of illuminator we can add a separate cid for that/
>
> Otherwise I think it might be best to just keep this as a private control.

V4L2_CID_MICROSCOPE_ILLUMINATOR might be an option, but then the question
is whether the top/bottom illuminator combination is standard for all (or
at least the majority) of microscopes. If that is indeed the case, then we
can consider this. Although I still think that checkboxes work just as
well.

But if this arrangement and number of illuminators is specific to this
range of microscopes, then a private control is an option.

An other option is to have ILLUMINATOR_TOP and ..._BOTTOM boolean
controls. That way at least the name presented to the user makes sense (if
the user can read english of course, but that's a discussion for another -
very rainy - day).

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

