Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0588EC10F03
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 15:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4DF52085A
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 15:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfCGPTc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 10:19:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:14765 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbfCGPTc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Mar 2019 10:19:32 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Mar 2019 07:19:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,451,1544515200"; 
   d="scan'208";a="149507778"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga002.fm.intel.com with ESMTP; 07 Mar 2019 07:19:30 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 2131D204CC; Thu,  7 Mar 2019 17:19:29 +0200 (EET)
Date:   Thu, 7 Mar 2019 17:19:29 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 19/31] media: Documentation: Add GS_ROUTING
 documentation
Message-ID: <20190307151928.dogdsks22acqawc3@paasikivi.fi.intel.com>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190305185150.20776-20-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190305185150.20776-20-jacopo+renesas@jmondi.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

Thanks for writing the documentation for this!

The text is nice and informative; I have a few suggestions below.

On Tue, Mar 05, 2019 at 07:51:38PM +0100, Jacopo Mondi wrote:
> Add documentation for VIDIOC_SUBDEV_G/S_ROUTING ioctl and add
> description of multiplexed media pads and internal routing to the
> V4L2-subdev documentation section.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  Documentation/media/uapi/v4l/dev-subdev.rst   |  90 +++++++++++
>  Documentation/media/uapi/v4l/user-func.rst    |   1 +
>  .../uapi/v4l/vidioc-subdev-g-routing.rst      | 142 ++++++++++++++++++
>  3 files changed, 233 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/vidioc-subdev-g-routing.rst
> 
> diff --git a/Documentation/media/uapi/v4l/dev-subdev.rst b/Documentation/media/uapi/v4l/dev-subdev.rst
> index 2c2768c7343b..b9fbb5d2caec 100644
> --- a/Documentation/media/uapi/v4l/dev-subdev.rst
> +++ b/Documentation/media/uapi/v4l/dev-subdev.rst
> @@ -36,6 +36,8 @@ will feature a character device node on which ioctls can be called to
>  
>  -  negotiate image formats on individual pads
>  
> +-  inspect and modify internal data routing between pads of the same entity
> +
>  Sub-device character device nodes, conventionally named
>  ``/dev/v4l-subdev*``, use major number 81.
>  
> @@ -461,3 +463,91 @@ source pads.
>      :maxdepth: 1
>  
>      subdev-formats
> +
> +
> +Multiplexed media pads and internal routing
> +-------------------------------------------
> +
> +Subdevice drivers might expose the internal connections between media pads of an

s/might/may/

> +entity by providing a routing table that applications can inspect and manipulate

s/providing/exposing/

> +to change the internal routing between sink and source pads' data connection
> +endpoints. A routing table is described by a struct
> +:c:type:`v4l2_subdev_routing`, which contains ``num_routes`` route entries, each
> +one represented by a struct :c:type:`v4l2_subdev_route`.
> +
> +Data routes do not just connect one pad to another in an entity, but they refer
> +instead to the ``streams`` a media pad provides. Streams are data connection
> +endpoints in a media pad. Multiplexed media pads expose multiple ``streams``
> +which represent, when the underlying hardware technology allows that, logical
> +data streams transported over a single physical media bus.

How about s/streams/flows/ for this instance?

> +
> +One of the most notable examples of logical stream multiplexing techniques is

s/One of the most notable examples/A noteworthy example/

> +represented by the data interleaving mechanism implemented by mean of Virtual
> +Channels identifiers as defined by the MIPI CSI-2 media bus specifications. A

s/identifiers //

> +subdevice that implements support for Virtual Channel data interleaving might
> +expose up to 4 data ``streams``, one for each available Virtual Channel, on the
> +source media pad that represents a CSI-2 connection endpoint.
> +
> +Routes are defined as potential data connections between a ``(sink_pad,
> +sink_stream)`` pair and a ``(source_pad, source_stream)`` one, where
> +``sink_pad`` and ``source_pad`` are the indexes of two media pads part of the
> +same media entity, and ``sink_stream`` and ``source_stream`` are the identifiers
> +of the data streams to be connected in the media pads. Media pads that do not
> +support data multiplexing expose a single stream, usually with identifier 0.
> +
> +Routes are reported to applications in a routing table which can be
> +inspected and manipulated using the :ref:`routing <VIDIOC_SUBDEV_G_ROUTING>`
> +ioctls.
> +
> +Routes can be activated and deactivated by setting or clearing the
> +V4L2_SUBDEV_ROUTE_FL_ACTIVE flag in the ``flags`` field of struct
> +:c:type:`v4l2_subdev_route`.
> +
> +Subdev driver might create routes that cannot be modified by applications. Such

s/S/A s/

> +routes are identified by the presence of the V4L2_SUBDEV_ROUTE_FL_IMMUTABLE
> +flag in the ``flags`` field of struct :c:type:`v4l2_subdev_route`.
> +
> +As an example, the routing table of a source pad which supports two logical
> +video streams and can be connected to two sink pads is here below described.
> +
> +.. flat-table::
> +    :widths:       1 2 1
> +
> +    * - Pad Index
> +      - Function
> +      - Number of streams
> +    * - 0
> +      - SINK
> +      - 1
> +    * - 1
> +      - SINK
> +      - 1
> +    * - 2
> +      - SOURCE
> +      - 2
> +
> +In such an example, the source media pad will report a routing table with 4
> +entries, one entry for each possible ``(sink_pad, sink_stream) - (source_pad,
> +source_stream)`` combination.
> +
> +.. flat-table:: routing table
> +    :widths:       2 1 2
> +
> +    * - Sink Pad/Sink Stream
> +      - ->
> +      - Source Pad/Source Stream
> +    * - 0/0
> +      - ->
> +      - 2/0
> +    * - 0/0
> +      - ->
> +      - 2/1
> +    * - 1/0
> +      - ->
> +      - 2/0
> +    * - 1/0
> +      - ->
> +      - 2/1
> +
> +Subdev drivers are free to decide how many routes an application can enable on
> +a media pad at the same time, and refuse to enable or disable specific routes.
> diff --git a/Documentation/media/uapi/v4l/user-func.rst b/Documentation/media/uapi/v4l/user-func.rst
> index ca0ef21d77fe..0166446f4ab4 100644
> --- a/Documentation/media/uapi/v4l/user-func.rst
> +++ b/Documentation/media/uapi/v4l/user-func.rst
> @@ -77,6 +77,7 @@ Function Reference
>      vidioc-subdev-g-crop
>      vidioc-subdev-g-fmt
>      vidioc-subdev-g-frame-interval
> +    vidioc-subdev-g-routing
>      vidioc-subdev-g-selection
>      vidioc-subscribe-event
>      func-mmap
> diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-g-routing.rst b/Documentation/media/uapi/v4l/vidioc-subdev-g-routing.rst
> new file mode 100644
> index 000000000000..8b592722c477
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/vidioc-subdev-g-routing.rst
> @@ -0,0 +1,142 @@
> +.. Permission is granted to copy, distribute and/or modify this
> +.. document under the terms of the GNU Free Documentation License,
> +.. Version 1.1 or any later version published by the Free Software
> +.. Foundation, with no Invariant Sections, no Front-Cover Texts
> +.. and no Back-Cover Texts. A copy of the license is included at
> +.. Documentation/media/uapi/fdl-appendix.rst.
> +..
> +.. TODO: replace it to GFDL-1.1-or-later WITH no-invariant-sections
> +
> +.. _VIDIOC_SUBDEV_G_ROUTING:
> +
> +******************************************************
> +ioctl VIDIOC_SUBDEV_G_ROUTING, VIDIOC_SUBDEV_S_ROUTING
> +******************************************************
> +
> +Name
> +====
> +
> +VIDIOC_SUBDEV_G_ROUTING - VIDIOC_SUBDEV_S_ROUTING - Get or set routing between streams of media pads in a media entity.
> +
> +
> +Synopsis
> +========
> +
> +.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_G_ROUTING, struct v4l2_subdev_routing *argp )
> +    :name: VIDIOC_SUBDEV_G_ROUTING
> +
> +.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_S_ROUTING, struct v4l2_subdev_routing *argp )
> +    :name: VIDIOC_SUBDEV_S_ROUTING
> +
> +
> +Arguments
> +=========
> +
> +``fd``
> +    File descriptor returned by :ref:`open() <func-open>`.
> +
> +``argp``
> +    Pointer to struct :c:type:`v4l2_subdev_routing`.
> +
> +
> +Description
> +===========
> +
> +These ioctls are used to get and set the routing informations associated to
> +media pads in a media entity. Routing informations are used to enable or disable

The routing is a property of an entity. How about

s/the routing informations associated to media pads in/routing/

s/R[^\.]+(?=\.)/The routing configuration determines the flows of data
inside an entity/

> +data connections between stream endpoints of multiplexed media pads.
> +
> +Drivers report their routing tables using VIDIOC_SUBDEV_G_ROUTING and
> +application use the information there reported to enable or disable data
> +connections between streams in a pad, by setting or clearing the

How about:

s/applications\K.*a pad/may enable or disable routes with the
VIDIOC_SUBDEV_S_ROUTING IOCTL,

> +V4L2_SUBDEV_ROUTE_FL_ACTIVE flag of ``flags`` field of a struct
> +:c:type:`v4l2_subdev_route`.
> +
> +When inspecting routes through VIDIOC_SUBDEV_G_ROUTING and the application
> +provided ``num_routes`` is not big enough to contain all the available routes
> +the subdevice exposes, drivers return the ENOSPC error code and adjust the
> +``num_routes`` value. Application should then reserve enough memory for all the

s/the\K$/value of the/
s/value\K\./field/

> +route entries and call VIDIOC_SUBDEV_G_ROUTING again.
> +
> +.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
> +
> +.. c:type:: v4l2_subdev_routing
> +
> +.. flat-table:: struct v4l2_subdev_routing
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - struct :c:type:`v4l2_subdev_route`
> +      - ``routes[]``
> +      - Array of struct :c:type:`v4l2_subdev_route` entries
> +    * - __u32
> +      - ``num_routes``
> +      - Number of entries of the routes array
> +    * - __u32
> +      - ``reserved``\ [5]
> +      - Reserved for future extensions. Applications and drivers must set
> +	the array to zero.
> +
> +.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
> +
> +.. c:type:: v4l2_subdev_route
> +
> +.. flat-table:: struct v4l2_subdev_route
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       1 1 2
> +
> +    * - __u32
> +      - ``sink_pad``
> +      - Sink pad number
> +    * - __u32
> +      - ``sink_stream``
> +      - Sink pad stream number
> +    * - __u32
> +      - ``source_stream``
> +      - Source pad stream number
> +    * - __u32
> +      - ``sink_stream``
> +      - Sink pad stream number
> +    * - __u32
> +      - ``flags``
> +      - Route enable/disable flags
> +	:ref:`v4l2_subdev_routing_flags <v4l2-subdev-routing-flags>`.
> +    * - __u32
> +      - ``reserved``\ [5]
> +      - Reserved for future extensions. Applications and drivers must set
> +	the array to zero.
> +
> +.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
> +
> +.. _v4l2-subdev-routing-flags:
> +
> +.. flat-table:: enum v4l2_subdev_routing_flags
> +    :header-rows:  0
> +    :stub-columns: 0
> +    :widths:       3 1 4
> +
> +    * - V4L2_SUBDEV_ROUTE_FL_ACTIVE
> +      - 0
> +      - The route is enabled. Set by applications.
> +    * - V4L2_SUBDEV_ROUTE_FL_IMMUTABLE
> +      - 1
> +      - The route is immutable. Set by the driver.
> +
> +Return Value
> +============
> +
> +On success 0 is returned, on error -1 and the ``errno`` variable is set
> +appropriately. The generic error codes are described at the
> +:ref:`Generic Error Codes <gen-errors>` chapter.
> +
> +ENOSPC
> +   The number of provided route entries is less than the available ones.
> +
> +EINVAL
> +   The sink or source pad identifiers reference a non-existing pad, or refernce
> +   pads of different types (ie. the sink_pad identifiers refers to a source pad)
> +   The sink or source stream identifiers reference a non-existing stream

s/The/or the/

> +   in the sink or source pad.

s/i/o/

> +

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
