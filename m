Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:46232 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbeESFRV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 May 2018 01:17:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        LMML <linux-media@vger.kernel.org>,
        Wim Taymans <wtaymans@redhat.com>, schaller@redhat.com
Subject: Re: [ANN] Meeting to discuss improvements to support MC-based cameras on generic apps
Date: Sat, 19 May 2018 08:17:42 +0300
Message-ID: <2039084.mzKZ95HuWk@avalon>
In-Reply-To: <7f9f800349eb45fb9c3a96b37f238fab0a610ee4.camel@ndufresne.ca>
References: <20180517160708.74811cfb@vento.lan> <1568098.156aR60jyk@avalon> <7f9f800349eb45fb9c3a96b37f238fab0a610ee4.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On Friday, 18 May 2018 18:15:20 EEST Nicolas Dufresne wrote:
> Le vendredi 18 mai 2018 =E0 15:38 +0300, Laurent Pinchart a =E9crit :
> >> Before libv4l, media support for a given device were limited to a few
> >> apps that knew how to decode the format. There were even cases were a
> >> proprietary app were required, as no open source decoders were
> >> available.
> >>=20
> >> From my PoV, the biggest gain with libv4l is that the same group of
> >> maintainers can ensure that the entire solution (Kernel driver and
> >> low level userspace support) will provide everything required for an
> >> open source app to work with it.
> >>=20
> >> I'm not sure how we would keep enforcing it if the pipeline setting
> >> and control propagation logic for an specific hardware will be
> >> delegated to PipeWire. It seems easier to keep doing it on a libv4l
> >> (version 2) and let PipeWire to use it.
> >=20
> > I believe we need to first study pipewire in more details. I have no
> > personal opinion yet as I haven't had time to investigate it. That being
> > said, I don't think that libv4l with closed-source plugins would be much
> > better than a closed-source pipewire plugin. What main concern once we
> > provide a userspace camera stack API is that vendors might implement th=
at
> > API in a closed-source component that calls to a kernel driver
> > implementing a custom API, with all knowledge about the camera located =
in
> > the closed-source component. I'm not sure how to prevent that, my best
> > proposal would be to make V4L2 so useful that vendors wouldn't even thi=
nk
> > about a different solution (possibly coupled by the pressure put by
> > platform vendors such as Google who mandate upstream kernel drivers for
> > Chrome OS, but that's still limited as even when it comes to Google
> > there's no such pressure on the Android side).
>=20
> If there is proprietary plugins, then I don't think it will make any
> difference were this is implemented.

I tend to agree overall, although the community that develops the framework=
 we=20
will end up using can make a difference in that area.

> The difference is the feature set we expose. 3A is per device, but multip=
le
> streams, with per request controls is also possible.

Could you detail what you mean exactly by multiple streams ? Are you talkin=
g=20
about multiple independent streams coming from the same device (such as vid=
eo=20
+ depth map, 3D video, ...) or streams created from a single source (sensor=
)=20
to serve different purposes (viewfinder, video capture, still image capture=
,=20
=2E..) ?

> PipeWire gives central place to manage this, while giving multiple process
> access to the camera streams. I think in the end, what fits better would =
be
> something like or the Android Camera HAL2. But we could encourage OSS by
> maintaining a base implementation that covers all the V4L2 aspect, leaving
> only the 3A aspect of the work to be done.

Ideally that's the goal I'd like to reach, regardless of which multimedia=20
stack we go for.

> Maybe we need to come up with an abstraction that does not prevent multi-
> streams, but only requires 3A per vendors

That would be tricky to achieve, as it's usually very use-case- and ISP-
dependent. Maybe we could come up with an interface for another vendor-
specific component to handle this, but I fear it will be so intertwined wit=
h=20
the 3A implementation that it wouldn't be possible to isolate those two=20
components.

> (saying per vendors, as some of this could be Open Source by third partie=
s).

Note that in practice 3A is often tuned per-device, starting from a per-ven=
dor=20
implementation.

> just thinking out loud now ;-P

That's exactly what we need to do to start with :-)

> p.s. Do we have the Intel / IPU3 folks in in the loop ? This is likely
> the most pressing HW as it's shipping on many laptops now.

=2D-=20
Regards,

Laurent Pinchart
