Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D506FC10F09
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 13:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B211F2087C
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 13:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbfCHNbE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:31:04 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:56627 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfCHNbD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2019 08:31:03 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id AD8814000D;
        Fri,  8 Mar 2019 13:30:59 +0000 (UTC)
Date:   Fri, 8 Mar 2019 14:31:33 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 19/31] media: Documentation: Add GS_ROUTING
 documentation
Message-ID: <20190308133133.ium6nzkbw6g3z22r@uno.localdomain>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190305185150.20776-20-jacopo+renesas@jmondi.org>
 <20190307151928.dogdsks22acqawc3@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wldqhjby6gkwcgqj"
Content-Disposition: inline
In-Reply-To: <20190307151928.dogdsks22acqawc3@paasikivi.fi.intel.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--wldqhjby6gkwcgqj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,
   thanks for the review

On Thu, Mar 07, 2019 at 05:19:29PM +0200, Sakari Ailus wrote:
> Hi Jacopo,
>
> Thanks for writing the documentation for this!
>
> The text is nice and informative; I have a few suggestions below.
>
> On Tue, Mar 05, 2019 at 07:51:38PM +0100, Jacopo Mondi wrote:
> > Add documentation for VIDIOC_SUBDEV_G/S_ROUTING ioctl and add
> > description of multiplexed media pads and internal routing to the
> > V4L2-subdev documentation section.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  Documentation/media/uapi/v4l/dev-subdev.rst   |  90 +++++++++++
> >  Documentation/media/uapi/v4l/user-func.rst    |   1 +
> >  .../uapi/v4l/vidioc-subdev-g-routing.rst      | 142 ++++++++++++++++++
> >  3 files changed, 233 insertions(+)
> >  create mode 100644 Documentation/media/uapi/v4l/vidioc-subdev-g-routing.rst
> >
> > diff --git a/Documentation/media/uapi/v4l/dev-subdev.rst b/Documentation/media/uapi/v4l/dev-subdev.rst
> > index 2c2768c7343b..b9fbb5d2caec 100644
> > --- a/Documentation/media/uapi/v4l/dev-subdev.rst
> > +++ b/Documentation/media/uapi/v4l/dev-subdev.rst
> > @@ -36,6 +36,8 @@ will feature a character device node on which ioctls can be called to
> >
> >  -  negotiate image formats on individual pads
> >
> > +-  inspect and modify internal data routing between pads of the same entity
> > +
> >  Sub-device character device nodes, conventionally named
> >  ``/dev/v4l-subdev*``, use major number 81.
> >
> > @@ -461,3 +463,91 @@ source pads.
> >      :maxdepth: 1
> >
> >      subdev-formats
> > +
> > +
> > +Multiplexed media pads and internal routing
> > +-------------------------------------------
> > +
> > +Subdevice drivers might expose the internal connections between media pads of an
>
> s/might/may/
>
> > +entity by providing a routing table that applications can inspect and manipulate
>
> s/providing/exposing/
>

Ack on both the above suggestions

> > +to change the internal routing between sink and source pads' data connection
> > +endpoints. A routing table is described by a struct
> > +:c:type:`v4l2_subdev_routing`, which contains ``num_routes`` route entries, each
> > +one represented by a struct :c:type:`v4l2_subdev_route`.
> > +
> > +Data routes do not just connect one pad to another in an entity, but they refer
> > +instead to the ``streams`` a media pad provides. Streams are data connection
> > +endpoints in a media pad. Multiplexed media pads expose multiple ``streams``
> > +which represent, when the underlying hardware technology allows that, logical
> > +data streams transported over a single physical media bus.
>
> How about s/streams/flows/ for this instance?
>

Agreed, there are too many "streams" already in that paragraph

> > +
> > +One of the most notable examples of logical stream multiplexing techniques is
>
> s/One of the most notable examples/A noteworthy example/
>
> > +represented by the data interleaving mechanism implemented by mean of Virtual
> > +Channels identifiers as defined by the MIPI CSI-2 media bus specifications. A
>
> s/identifiers //
>

Ack on both the above suggestions

> > +subdevice that implements support for Virtual Channel data interleaving might
> > +expose up to 4 data ``streams``, one for each available Virtual Channel, on the
> > +source media pad that represents a CSI-2 connection endpoint.
> > +
> > +Routes are defined as potential data connections between a ``(sink_pad,
> > +sink_stream)`` pair and a ``(source_pad, source_stream)`` one, where
> > +``sink_pad`` and ``source_pad`` are the indexes of two media pads part of the
> > +same media entity, and ``sink_stream`` and ``source_stream`` are the identifiers
> > +of the data streams to be connected in the media pads. Media pads that do not
> > +support data multiplexing expose a single stream, usually with identifier 0.
> > +
> > +Routes are reported to applications in a routing table which can be
> > +inspected and manipulated using the :ref:`routing <VIDIOC_SUBDEV_G_ROUTING>`
> > +ioctls.
> > +
> > +Routes can be activated and deactivated by setting or clearing the
> > +V4L2_SUBDEV_ROUTE_FL_ACTIVE flag in the ``flags`` field of struct
> > +:c:type:`v4l2_subdev_route`.
> > +
> > +Subdev driver might create routes that cannot be modified by applications. Such
>
> s/S/A s/

Or "Subdevice drivers" ?

>
> > +routes are identified by the presence of the V4L2_SUBDEV_ROUTE_FL_IMMUTABLE
> > +flag in the ``flags`` field of struct :c:type:`v4l2_subdev_route`.
> > +
> > +As an example, the routing table of a source pad which supports two logical
> > +video streams and can be connected to two sink pads is here below described.
> > +
> > +.. flat-table::
> > +    :widths:       1 2 1
> > +
> > +    * - Pad Index
> > +      - Function
> > +      - Number of streams
> > +    * - 0
> > +      - SINK
> > +      - 1
> > +    * - 1
> > +      - SINK
> > +      - 1
> > +    * - 2
> > +      - SOURCE
> > +      - 2
> > +
> > +In such an example, the source media pad will report a routing table with 4
> > +entries, one entry for each possible ``(sink_pad, sink_stream) - (source_pad,
> > +source_stream)`` combination.
> > +
> > +.. flat-table:: routing table
> > +    :widths:       2 1 2
> > +
> > +    * - Sink Pad/Sink Stream
> > +      - ->
> > +      - Source Pad/Source Stream
> > +    * - 0/0
> > +      - ->
> > +      - 2/0
> > +    * - 0/0
> > +      - ->
> > +      - 2/1
> > +    * - 1/0
> > +      - ->
> > +      - 2/0
> > +    * - 1/0
> > +      - ->
> > +      - 2/1
> > +
> > +Subdev drivers are free to decide how many routes an application can enable on
> > +a media pad at the same time, and refuse to enable or disable specific routes.
> > diff --git a/Documentation/media/uapi/v4l/user-func.rst b/Documentation/media/uapi/v4l/user-func.rst
> > index ca0ef21d77fe..0166446f4ab4 100644
> > --- a/Documentation/media/uapi/v4l/user-func.rst
> > +++ b/Documentation/media/uapi/v4l/user-func.rst
> > @@ -77,6 +77,7 @@ Function Reference
> >      vidioc-subdev-g-crop
> >      vidioc-subdev-g-fmt
> >      vidioc-subdev-g-frame-interval
> > +    vidioc-subdev-g-routing
> >      vidioc-subdev-g-selection
> >      vidioc-subscribe-event
> >      func-mmap
> > diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-routing.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-routing.rst
> > new file mode 100644
> > index 000000000000..8b592722c477
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-routing.rst
> > @@ -0,0 +1,142 @@
> > +.. Permission is granted to copy, distribute and/or modify this
> > +.. document under the terms of the GNU Free Documentation License,
> > +.. Version 1.1 or any later version published by the Free Software
> > +.. Foundation, with no Invariant Sections, no Front-Cover Texts
> > +.. and no Back-Cover Texts. A copy of the license is included at
> > +.. Documentation/media/uapi/fdl-appendix.rst.
> > +..
> > +.. TODO: replace it to GFDL-1.1-or-later WITH no-invariant-sections
> > +
> > +.. _VIDIOC_SUBDEV_G_ROUTING:
> > +
> > +******************************************************
> > +ioctl VIDIOC_SUBDEV_G_ROUTING, VIDIOC_SUBDEV_S_ROUTING
> > +******************************************************
> > +
> > +Name
> > +====
> > +
> > +VIDIOC_SUBDEV_G_ROUTING - VIDIOC_SUBDEV_S_ROUTING - Get or set routing between streams of media pads in a media entity.
> > +
> > +
> > +Synopsis
> > +========
> > +
> > +.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_G_ROUTING, struct v4l2_subdev_routing *argp )
> > +    :name: VIDIOC_SUBDEV_G_ROUTING
> > +
> > +.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_S_ROUTING, struct v4l2_subdev_routing *argp )
> > +    :name: VIDIOC_SUBDEV_S_ROUTING
> > +
> > +
> > +Arguments
> > +=========
> > +
> > +``fd``
> > +    File descriptor returned by :ref:`open() <func-open>`.
> > +
> > +``argp``
> > +    Pointer to struct :c:type:`v4l2_subdev_routing`.
> > +
> > +
> > +Description
> > +===========
> > +
> > +These ioctls are used to get and set the routing informations associated to
> > +media pads in a media entity. Routing informations are used to enable or disable
>
> The routing is a property of an entity. How about
>
> s/the routing informations associated to media pads in/routing/
>
> s/R[^\.]+(?=\.)/The routing configuration determines the flows of data
> inside an entity/

Thanks, you made me discover regexr.com here
>
> > +data connections between stream endpoints of multiplexed media pads.
> > +
> > +Drivers report their routing tables using VIDIOC_SUBDEV_G_ROUTING and
> > +application use the information there reported to enable or disable data
> > +connections between streams in a pad, by setting or clearing the
>
> How about:
>
> s/applications\K.*a pad/may enable or disable routes with the
> VIDIOC_SUBDEV_S_ROUTING IOCTL,
>

Yes, reads better

> > +V4L2_SUBDEV_ROUTE_FL_ACTIVE flag of ``flags`` field of a struct
> > +:c:type:`v4l2_subdev_route`.
> > +
> > +When inspecting routes through VIDIOC_SUBDEV_G_ROUTING and the application
> > +provided ``num_routes`` is not big enough to contain all the available routes
> > +the subdevice exposes, drivers return the ENOSPC error code and adjust the
> > +``num_routes`` value. Application should then reserve enough memory for all the
>
> s/the\K$/value of the/
> s/value\K\./field/
>

Will update

> > +route entries and call VIDIOC_SUBDEV_G_ROUTING again.
> > +
> > +.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
> > +
> > +.. c:type:: v4l2_subdev_routing
> > +
> > +.. flat-table:: struct v4l2_subdev_routing
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - struct :c:type:`v4l2_subdev_route`
> > +      - ``routes[]``
> > +      - Array of struct :c:type:`v4l2_subdev_route` entries
> > +    * - __u32
> > +      - ``num_routes``
> > +      - Number of entries of the routes array
> > +    * - __u32
> > +      - ``reserved``\ [5]
> > +      - Reserved for future extensions. Applications and drivers must set
> > +	the array to zero.
> > +
> > +.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
> > +
> > +.. c:type:: v4l2_subdev_route
> > +
> > +.. flat-table:: struct v4l2_subdev_route
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       1 1 2
> > +
> > +    * - __u32
> > +      - ``sink_pad``
> > +      - Sink pad number
> > +    * - __u32
> > +      - ``sink_stream``
> > +      - Sink pad stream number
> > +    * - __u32
> > +      - ``source_stream``
> > +      - Source pad stream number
> > +    * - __u32
> > +      - ``sink_stream``
> > +      - Sink pad stream number
> > +    * - __u32
> > +      - ``flags``
> > +      - Route enable/disable flags
> > +	:ref:`v4l2_subdev_routing_flags <v4l2-subdev-routing-flags>`.
> > +    * - __u32
> > +      - ``reserved``\ [5]
> > +      - Reserved for future extensions. Applications and drivers must set
> > +	the array to zero.
> > +
> > +.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
> > +
> > +.. _v4l2-subdev-routing-flags:
> > +
> > +.. flat-table:: enum v4l2_subdev_routing_flags
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       3 1 4
> > +
> > +    * - V4L2_SUBDEV_ROUTE_FL_ACTIVE
> > +      - 0
> > +      - The route is enabled. Set by applications.
> > +    * - V4L2_SUBDEV_ROUTE_FL_IMMUTABLE
> > +      - 1
> > +      - The route is immutable. Set by the driver.
> > +
> > +Return Value
> > +============
> > +
> > +On success 0 is returned, on error -1 and the ``errno`` variable is set
> > +appropriately. The generic error codes are described at the
> > +:ref:`Generic Error Codes <gen-errors>` chapter.
> > +
> > +ENOSPC
> > +   The number of provided route entries is less than the available ones.
> > +
> > +EINVAL
> > +   The sink or source pad identifiers reference a non-existing pad, or refernce
> > +   pads of different types (ie. the sink_pad identifiers refers to a source pad)
> > +   The sink or source stream identifiers reference a non-existing stream
>
> s/The/or the/
>
> > +   in the sink or source pad.
>
> s/i/o/

Thanks, I will update all of these in v4.

>
> > +
>
> --
> Kind regards,
>
> Sakari Ailus
> sakari.ailus@linux.intel.com

--wldqhjby6gkwcgqj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlyCbrUACgkQcjQGjxah
VjxWXxAAwT08YiWjkHueKTAVDlIa+cUAa3AO1UJ/HAbHFBswPo8Lsip0dmtJG9dF
xzJM5K8TdEez2ty+eKHxxW7qaUWRRSIMbwMBLcnI/dCIyPjm18z1jxDsmNKh74wb
OOOzpRHu/U4os7XV8Ax9MdQ7V78aOYz8SPsEeCSprQ+VPgDAYVaU8t8au/uqNjLX
w/lREzaMRmq1iPUYeGb54LQHEUfFjlCm012X/pouI1diPSQPjff5trEEw5tcPNNT
LNGNIhIEheENJqB4cGbX1omb7n8vWN5pnJ4k0k8V3y1BPZm0gVIjDopDPQahlVu3
7mkeS732EIBi23stKkvCUimHAhf+E1FrkT/4muj7vHuYEXo8B53O6CHxXKoltUAf
ijbRM3hrGDiUWS5trKz/24aFbZO1UjTiQUpNbQmIwEUy1bNAEuM9LhMbQmoFR8Uw
YuJseBjiEKhx8wcYiCqnxLhC3iRUEIkxsRYjuBbPv3sjHtgnooNBRP/Nd2fW2zEQ
YxZmNWM3+qxI7HCQKB8FDmBQTKYut+c/1ZK+4U3J2fedC4vHTzSiU6HX4sakMV4J
1yh5fOa+0IbV3w+GBL59qrQGDT6CJVnhvVp3ALWNLq1DOyudeRtfUiUBXrBzMKhc
L9WrboVarU/5w4Qo5Xt1SODGsZpctEF5jekMoe5cMogbwFrFXuI=
=1BDy
-----END PGP SIGNATURE-----

--wldqhjby6gkwcgqj--
