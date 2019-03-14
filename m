Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C8EEC43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 14:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FAC921852
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 14:43:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=lucaceresoli.net header.i=@lucaceresoli.net header.b="b8iKz7nK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfCNOnR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 10:43:17 -0400
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:39399 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726629AbfCNOnR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 10:43:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lucaceresoli.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=f7IqrjFivUc5aUzLkZQ37hN6EXQDi2I82XlQc74mcFc=; b=b8iKz7nK8Jg5NtffjKhp+UHQ2A
        0M/rtThGveTpKr+wJMfHesjIzWtctjC9NaiLTlv8FhC5BJ4jIp3jj3rUZcHt5l8pfdI7X8G1CicTT
        uigrCt0Pgmj2K7qHJUYH9RZKI0il4oaukkfjIFg1xWZU2e3KaE3XHPIYFYiCJ1NebYb4=;
Received: from [109.168.11.45] (port=50888 helo=[192.168.101.76])
        by hostingweb31.netsons.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@lucaceresoli.net>)
        id 1h4RZg-00HGQw-AA; Thu, 14 Mar 2019 15:43:12 +0100
Subject: Re: [PATCH v3 19/31] media: Documentation: Add GS_ROUTING
 documentation
To:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190305185150.20776-20-jacopo+renesas@jmondi.org>
From:   Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <c3245f8d-1a78-2d6e-f754-5a8d1c93d7ea@lucaceresoli.net>
Date:   Thu, 14 Mar 2019 15:43:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190305185150.20776-20-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On 05/03/19 19:51, Jacopo Mondi wrote:
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
> +entity by providing a routing table that applications can inspect and manipulate
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
> +
> +One of the most notable examples of logical stream multiplexing techniques is
> +represented by the data interleaving mechanism implemented by mean of Virtual
> +Channels identifiers as defined by the MIPI CSI-2 media bus specifications. A
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

`` around V4L2_SUBDEV_ROUTE_FL_ACTIVE would be better.

> +:c:type:`v4l2_subdev_route`.
> +
> +Subdev driver might create routes that cannot be modified by applications. Such
> +routes are identified by the presence of the V4L2_SUBDEV_ROUTE_FL_IMMUTABLE

`` here too.

> +flag in the ``flags`` field of struct :c:type:`v4l2_subdev_route`.
> +
> +As an example, the routing table of a source pad which supports two logical
> +video streams and can be connected to two sink pads is here below described.

After this sentence I expected to find the routing table, but instead
there's a pad description. I'd rephrase as:

--------8<--------
Take for example a subdevice that has two sink pads and can combnie
their streams on a single source pad as two logical streams. The
following table describes the pads for such subdevice.
--------8<--------

> +
> +.. flat-table::

To make the headers bold as in other tables just add here:
:header-rows:  1

> +    :widths:       1 2 1

The content of the central column is not really larger than the others,
you can set '1 1 1' here or just ditch the :width: line.

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

Here as well:
:header-rows:  1

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

...

> +Description
> +===========
> +
> +These ioctls are used to get and set the routing informations associated to

"information" is uncountable, thus s/informations/information/ here and
in other places.

> +media pads in a media entity. Routing informations are used to enable or disable
> +data connections between stream endpoints of multiplexed media pads.

...

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

The 3rd and 4th field are wrong, they should be source_pad and
source_stream.

> +    * - __u32
> +      - ``flags``
> +      - Route enable/disable flags
> +	:ref:`v4l2_subdev_routing_flags <v4l2-subdev-routing-flags>`.
> +    * - __u32
> +      - ``reserved``\ [5]
> +      - Reserved for future extensions. Applications and drivers must set
> +	the array to zero.

-- 
Luca
