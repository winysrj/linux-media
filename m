Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41198 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751330AbdIAHNU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 03:13:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Brian Starkey <brian.starkey@arm.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Daniel Vetter <daniel@ffwll.ch>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        jonathan.chai@arm.com, dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: DRM Format Modifiers in v4l2
Date: Fri, 01 Sep 2017 10:13:53 +0300
Message-ID: <1962548.KP01uVGcTd@avalon>
In-Reply-To: <1504195978.18413.14.camel@ndufresne.ca>
References: <20170821155203.GB38943@e107564-lin.cambridge.arm.com> <4559442.sz5HF0f0o4@avalon> <1504195978.18413.14.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On Thursday, 31 August 2017 19:12:58 EEST Nicolas Dufresne wrote:
> Le jeudi 31 ao=FBt 2017 =E0 17:28 +0300, Laurent Pinchart a =E9crit :
> >> e.g. if I have two devices which support MODIFIER_FOO, I could attempt
> >> to share a buffer between them which uses MODIFIER_FOO without
> >> necessarily knowing exactly what it is/does.
> >=20
> > Userspace could certainly set modifiers blindly, but the point of
> > modifiers is to generate side effects benefitial to the use case at hand
> > (for instance by optimizing the memory access pattern). To use them
> > meaningfully userspace would need to have at least an idea of the side
> > effects they generate.
>=20
> Generic userspace will basically pick some random combination.

In that case userspace could set no modifier at all by default (except in t=
he=20
case where unmodified formats are not supported by the hardware, but I don'=
t=20
expect that to be the most common case).

> To allow generically picking the optimal configuration we could indeed re=
ly
> on the application knowledge, but we could also enhance the spec so that
> the order in the enumeration becomes meaningful.

I'm not sure how far we should go. I could imagine a system where the API=20
would report capabilities for modifiers (e.g. this modifier lowers the=20
bandwidth, this one enhances the quality, ...), but going in that direction=
,=20
where do we stop ? In practice I expect userspace to know some information=
=20
about the hardware, so I'd rather avoid over-engineering the API.

=2D-=20
Regards,

Laurent Pinchart
