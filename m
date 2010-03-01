Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4446 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab0CAJ6V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 04:58:21 -0500
Message-ID: <49ae9be6ffaaac102dc02f94f2fd047c.squirrel@webmail.xs4all.nl>
In-Reply-To: <829197381003010107m79ff65bajde4da911eafc6740@mail.gmail.com>
References: <829197381002281856o749e3e9al36334b8b42b34562@mail.gmail.com>
    <201003010957.49198.laurent.pinchart@ideasonboard.com>
    <829197381003010107m79ff65bajde4da911eafc6740@mail.gmail.com>
Date: Mon, 1 Mar 2010 10:58:16 +0100
Subject: Re: How do private controls actually work?
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Cc: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hello Laurent,
>
> On Mon, Mar 1, 2010 at 3:57 AM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> I don't think it should matter which API (the base one or the extended
>> one)
>> you use for controls, be they private, standard or whatever. I don't see
>> a
>> reason for disallowing some controls to be used through one or the other
>> API.
>
> I would generally agree.  My original belief was that the extended
> control API was designed to be a superset of the older API and that it
> could be used for both types of controls.  Imagine my surprise to find
> that private controls were specifically excluded from the extended
> control interface.

New private controls should not use V4L2_CID_PRIVATE_BASE at all. That
mechanism was a really bad idea. Instead a new control should be added to
the appropriate control class and with a offset >= 0x1000. See for example
the CX2341X private controls in videodev2.h.

The EXT_G/S_CTRLS ioctls do not accept PRIVATE_BASE because I want to
force driver developers to stop using PRIVATE_BASE. So only G/S_CTRL will
support controls in that range for backwards compatibility.

Regards,

        Hans

>>> I can change v4l2-ctl to use g_ctrl for private controls if we think
>>> that is the correct approach.  But I didn't want to do that until I
>>> knew for sure that it is correct that you can never have a private
>>> extended control.
>>
>> Do we have extended *controls* ? All I see today is two APIs to access
>> controls, a base *control API* and an extended *control API*.
>> G_CTRL/S_CTRL
>> should always be available to userspace. If you want to set a single
>> control,
>> the extended API isn't required.
>
> The MPEG controls count as "extended" controls, since they provide the
> ability for grouping controls and modifying the values for multiple
> controls in an atomic manner.
>
> It's worth noting that I actually did track down the regression in
> v4l2-ctl, and the fix ended up being pretty simple (although it took a
> couple of hours to understand the code and nail down the proper fix):
>
> http://kernellabs.com/hg/~dheitmueller/em28xx-test/rev/142ae5aa9e8e
>
> It's kind of annoying that I have to tell my client that the ability
> to query/update private controls using v4l2-ctl has been completely
> broken for six months, but it seems like that is where we are at.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

