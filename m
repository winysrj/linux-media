Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:37972 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdH1UtJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 16:49:09 -0400
Received: by mail-io0-f196.google.com with SMTP id m40so1395270ioi.5
        for <linux-media@vger.kernel.org>; Mon, 28 Aug 2017 13:49:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1503943642.3316.7.camel@ndufresne.ca>
References: <20170821155203.GB38943@e107564-lin.cambridge.arm.com>
 <CAKMK7uFdQPUomZDCp_ak6sTsUayZuut4us08defjKmiy=24QnA@mail.gmail.com>
 <47128f36-2990-bd45-ead9-06a31ed8cde0@xs4all.nl> <20170824111430.GB25711@e107564-lin.cambridge.arm.com>
 <ba202456-4bc6-733e-4950-88ce64ca990e@xs4all.nl> <20170824122647.GA28829@e107564-lin.cambridge.arm.com>
 <1503943642.3316.7.camel@ndufresne.ca>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Mon, 28 Aug 2017 22:49:07 +0200
Message-ID: <CAKMK7uGaQ+9cZ2PyLkwC06Qpch3AK+Tkr4SZFZVLfUqUFKyygQ@mail.gmail.com>
Subject: Re: DRM Format Modifiers in v4l2
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Brian Starkey <brian.starkey@arm.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        jonathan.chai@arm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 28, 2017 at 8:07 PM, Nicolas Dufresne <nicolas@ndufresne.ca> wr=
ote:
> Le jeudi 24 ao=C3=BBt 2017 =C3=A0 13:26 +0100, Brian Starkey a =C3=A9crit=
 :
>> > What I mean was: an application can use the modifier to give buffers f=
rom
>> > one device to another without needing to understand it.
>> >
>> > But a generic video capture application that processes the video itsel=
f
>> > cannot be expected to know about the modifiers. It's a custom HW speci=
fic
>> > format that you only use between two HW devices or with software writt=
en
>> > for that hardware.
>> >
>>
>> Yes, makes sense.
>>
>> > >
>> > > However, in DRM the API lets you get the supported formats for each
>> > > modifier as-well-as the modifier list itself. I'm not sure how exact=
ly
>> > > to provide that in a control.
>> >
>> > We have support for a 'menu' of 64 bit integers: V4L2_CTRL_TYPE_INTEGE=
R_MENU.
>> > You use VIDIOC_QUERYMENU to enumerate the available modifiers.
>> >
>> > So enumerating these modifiers would work out-of-the-box.
>>
>> Right. So I guess the supported set of formats could be somehow
>> enumerated in the menu item string. In DRM the pairs are (modifier +
>> bitmask) where bits represent formats in the supported formats list
>> (commit db1689aa61bd in drm-next). Printing a hex representation of
>> the bitmask would be functional but I concede not very pretty.
>
> The problem is that the list of modifiers depends on the format
> selected. Having to call S_FMT to obtain this list is quite
> inefficient.
>
> Also, be aware that DRM_FORMAT_MOD_SAMSUNG_64_32_TILE modifier has been
> implemented in V4L2 with a direct format (V4L2_PIX_FMT_NV12MT). I think
> an other one made it the same way recently, something from Mediatek if
> I remember. Though, unlike the Intel one, the same modifier does not
> have various result depending on the hardware revision.

Note on the intel modifers: On most recent platforms (iirc gen9) the
modifier is well defined and always describes the same byte layout. We
simply didn't want to rewrite our entire software stack for all the
old gunk platforms, hence the language. I guess we could/should
describe the layout in detail, but atm we're the only ones using it.

On your topic of v4l2 encoding the drm fourcc+modifier combo into a
special v4l fourcc: That's exactly the mismatch I was thinking of.
There's other examples of v4l2 fourcc being more specific than their
drm counters (e.g. specific way the different planes are laid out).
-Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
