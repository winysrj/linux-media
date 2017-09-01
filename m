Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:37489 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751813AbdIAMnL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 08:43:11 -0400
Received: by mail-lf0-f44.google.com with SMTP id y128so365889lfd.4
        for <linux-media@vger.kernel.org>; Fri, 01 Sep 2017 05:43:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1962548.KP01uVGcTd@avalon>
References: <20170821155203.GB38943@e107564-lin.cambridge.arm.com>
 <4559442.sz5HF0f0o4@avalon> <1504195978.18413.14.camel@ndufresne.ca> <1962548.KP01uVGcTd@avalon>
From: Rob Clark <robdclark@gmail.com>
Date: Fri, 1 Sep 2017 08:43:09 -0400
Message-ID: <CAF6AEGu1v-_hWbyRfdoWnJN=bqBV_OZcEaNhWgdrjqNamvu62A@mail.gmail.com>
Subject: Re: DRM Format Modifiers in v4l2
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>, jonathan.chai@arm.com,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 1, 2017 at 3:13 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Nicolas,
>
> On Thursday, 31 August 2017 19:12:58 EEST Nicolas Dufresne wrote:
>> Le jeudi 31 ao=C3=BBt 2017 =C3=A0 17:28 +0300, Laurent Pinchart a =C3=A9=
crit :
>> >> e.g. if I have two devices which support MODIFIER_FOO, I could attemp=
t
>> >> to share a buffer between them which uses MODIFIER_FOO without
>> >> necessarily knowing exactly what it is/does.
>> >
>> > Userspace could certainly set modifiers blindly, but the point of
>> > modifiers is to generate side effects benefitial to the use case at ha=
nd
>> > (for instance by optimizing the memory access pattern). To use them
>> > meaningfully userspace would need to have at least an idea of the side
>> > effects they generate.
>>
>> Generic userspace will basically pick some random combination.
>
> In that case userspace could set no modifier at all by default (except in=
 the
> case where unmodified formats are not supported by the hardware, but I do=
n't
> expect that to be the most common case).
>
>> To allow generically picking the optimal configuration we could indeed r=
ely
>> on the application knowledge, but we could also enhance the spec so that
>> the order in the enumeration becomes meaningful.
>
> I'm not sure how far we should go. I could imagine a system where the API
> would report capabilities for modifiers (e.g. this modifier lowers the
> bandwidth, this one enhances the quality, ...), but going in that directi=
on,
> where do we stop ? In practice I expect userspace to know some informatio=
n
> about the hardware, so I'd rather avoid over-engineering the API.
>

I think in the (hopefully not too) long term, something like
https://github.com/cubanismo/allocator/ is the way forward.  That
doesn't quite solve how v4l2 kernel part sorts out w/ corresponding
userspace .so what is preferable, but at least that is
compartmentalized to v4l2.. on the gl/vk side of things there will ofc
be a hardware specific userspace part that knows what it prefers.  For
v4l2, it probably makes sense to sort out what the userspace level API
is and work backwards from there, rather than risk trying to design a
kernel uapi that might turn out to be the wrong thing.

BR,
-R
