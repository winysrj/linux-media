Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33053 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751461AbdICJAp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Sep 2017 05:00:45 -0400
Received: by mail-io0-f178.google.com with SMTP id b2so12887703iof.0
        for <linux-media@vger.kernel.org>; Sun, 03 Sep 2017 02:00:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAF6AEGu1v-_hWbyRfdoWnJN=bqBV_OZcEaNhWgdrjqNamvu62A@mail.gmail.com>
References: <20170821155203.GB38943@e107564-lin.cambridge.arm.com>
 <4559442.sz5HF0f0o4@avalon> <1504195978.18413.14.camel@ndufresne.ca>
 <1962548.KP01uVGcTd@avalon> <CAF6AEGu1v-_hWbyRfdoWnJN=bqBV_OZcEaNhWgdrjqNamvu62A@mail.gmail.com>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Sun, 3 Sep 2017 11:00:43 +0200
Message-ID: <CAKMK7uG+oP36sipLyV5L+wzWT-C00WXQZRmrFsborjzkoZTQUg@mail.gmail.com>
Subject: Re: DRM Format Modifiers in v4l2
To: Rob Clark <robdclark@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, jonathan.chai@arm.com,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 1, 2017 at 2:43 PM, Rob Clark <robdclark@gmail.com> wrote:
> On Fri, Sep 1, 2017 at 3:13 AM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi Nicolas,
>>
>> On Thursday, 31 August 2017 19:12:58 EEST Nicolas Dufresne wrote:
>>> Le jeudi 31 ao=C3=BBt 2017 =C3=A0 17:28 +0300, Laurent Pinchart a =C3=
=A9crit :
>>> >> e.g. if I have two devices which support MODIFIER_FOO, I could attem=
pt
>>> >> to share a buffer between them which uses MODIFIER_FOO without
>>> >> necessarily knowing exactly what it is/does.
>>> >
>>> > Userspace could certainly set modifiers blindly, but the point of
>>> > modifiers is to generate side effects benefitial to the use case at h=
and
>>> > (for instance by optimizing the memory access pattern). To use them
>>> > meaningfully userspace would need to have at least an idea of the sid=
e
>>> > effects they generate.
>>>
>>> Generic userspace will basically pick some random combination.
>>
>> In that case userspace could set no modifier at all by default (except i=
n the
>> case where unmodified formats are not supported by the hardware, but I d=
on't
>> expect that to be the most common case).
>>
>>> To allow generically picking the optimal configuration we could indeed =
rely
>>> on the application knowledge, but we could also enhance the spec so tha=
t
>>> the order in the enumeration becomes meaningful.
>>
>> I'm not sure how far we should go. I could imagine a system where the AP=
I
>> would report capabilities for modifiers (e.g. this modifier lowers the
>> bandwidth, this one enhances the quality, ...), but going in that direct=
ion,
>> where do we stop ? In practice I expect userspace to know some informati=
on
>> about the hardware, so I'd rather avoid over-engineering the API.
>>
>
> I think in the (hopefully not too) long term, something like
> https://github.com/cubanismo/allocator/ is the way forward.  That
> doesn't quite solve how v4l2 kernel part sorts out w/ corresponding
> userspace .so what is preferable, but at least that is
> compartmentalized to v4l2.. on the gl/vk side of things there will ofc
> be a hardware specific userspace part that knows what it prefers.  For
> v4l2, it probably makes sense to sort out what the userspace level API
> is and work backwards from there, rather than risk trying to design a
> kernel uapi that might turn out to be the wrong thing.

I thought for kms the plan is to make the ordering meaningful, because
it doesn't necessarily match the gl/vk one. E.g. on intel gl would
prefer Y compressed, Y, X, untiled. Whereas display would be Y
compressed, X (much easier to scan out, in many cases allows more
planes to be used), Y (is necessary for 90=C2=B0 rotation), untiled. So if
drm_hwc really wants to use all the planes, it could prioritize the
display over rendering and request X instead of Y tiled.

I think the same would go for v4l.
-Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
